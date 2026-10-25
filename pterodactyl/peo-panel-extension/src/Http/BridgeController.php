<?php

declare(strict_types=1);

namespace Peo\PanelExtension\Http;

use Carbon\CarbonImmutable;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Http\Response;
use Illuminate\Routing\Route;
use Illuminate\Support\Facades\App;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Redirect;
use Pterodactyl\Enum\JwtScope;
use Pterodactyl\Enum\Permissions;
use Pterodactyl\Exceptions\Http\HttpForbiddenException;
use Pterodactyl\Http\Controllers\Api\Client\Servers\BackupController;
use Pterodactyl\Http\Controllers\Api\Client\Servers\CommandController;
use Pterodactyl\Http\Controllers\Api\Client\Servers\FileController;
use Pterodactyl\Http\Controllers\Api\Client\Servers\FileUploadController;
use Pterodactyl\Http\Controllers\Api\Client\Servers\PowerController;
use Pterodactyl\Http\Controllers\Api\Client\Servers\ResourceUtilizationController;
use Pterodactyl\Http\Controllers\Api\Client\Servers\ServerController;
use Pterodactyl\Http\Controllers\Api\Client\Servers\SettingsController;
use Pterodactyl\Http\Controllers\Api\Client\Servers\StartupController;
use Pterodactyl\Http\Middleware\Api\Client\Server\AuthenticateServerAccess;
use Pterodactyl\Http\Requests\Api\Client\Servers\Backups\DeleteBackupRequest;
use Pterodactyl\Http\Requests\Api\Client\Servers\Backups\DownloadBackupRequest;
use Pterodactyl\Http\Requests\Api\Client\Servers\Backups\ListBackupsRequest;
use Pterodactyl\Http\Requests\Api\Client\Servers\Backups\RestoreBackupRequest;
use Pterodactyl\Http\Requests\Api\Client\Servers\Backups\StoreBackupRequest;
use Pterodactyl\Http\Requests\Api\Client\Servers\Backups\ToggleBackupLockRequest;
use Pterodactyl\Http\Requests\Api\Client\Servers\Backups\ViewBackupRequest;
use Pterodactyl\Http\Requests\Api\Client\Servers\Files\ChmodFilesRequest;
use Pterodactyl\Http\Requests\Api\Client\Servers\Files\CompressFilesRequest;
use Pterodactyl\Http\Requests\Api\Client\Servers\Files\CopyFileRequest;
use Pterodactyl\Http\Requests\Api\Client\Servers\Files\CreateFolderRequest;
use Pterodactyl\Http\Requests\Api\Client\Servers\Files\DecompressFilesRequest;
use Pterodactyl\Http\Requests\Api\Client\Servers\Files\DeleteFileRequest;
use Pterodactyl\Http\Requests\Api\Client\Servers\Files\GetFileContentsRequest;
use Pterodactyl\Http\Requests\Api\Client\Servers\Files\ListFilesRequest;
use Pterodactyl\Http\Requests\Api\Client\Servers\Files\RenameFileRequest;
use Pterodactyl\Http\Requests\Api\Client\Servers\Files\UploadFileRequest;
use Pterodactyl\Http\Requests\Api\Client\Servers\Files\WriteFileContentRequest;
use Pterodactyl\Http\Requests\Api\Client\Servers\GetServerRequest;
use Pterodactyl\Http\Requests\Api\Client\Servers\GetServerRequest as GetResourcesRequest;
use Pterodactyl\Http\Requests\Api\Client\Servers\SendCommandRequest;
use Pterodactyl\Http\Requests\Api\Client\Servers\SendPowerRequest;
use Pterodactyl\Http\Requests\Api\Client\Servers\Settings\SetDockerImageRequest;
use Pterodactyl\Http\Requests\Api\Client\Servers\Startup\GetStartupRequest;
use Pterodactyl\Http\Requests\Api\Client\Servers\Startup\UpdateStartupVariableRequest;
use Pterodactyl\Models\Backup;
use Pterodactyl\Models\Server;
use Pterodactyl\Models\User;
use Pterodactyl\Services\Nodes\NodeJwt;
use Pterodactyl\Contracts\Servers\ReadsServerState;
use Symfony\Component\HttpKernel\Exception\BadRequestHttpException;

final class BridgeController
{
    private const int PROTOCOL_VERSION = 1;

    private const string EXTENSION_VERSION = '1.0.0';

    public function capabilities(): JsonResponse
    {
        return response()->json(['data' => [
            'extension' => ['id' => 'peo-bridge', 'version' => self::EXTENSION_VERSION],
            'protocol_version' => self::PROTOCOL_VERSION,
            'panel_version' => config('app.version'),
            'capabilities' => ['servers', 'resources', 'power', 'command', 'websocket', 'files', 'backups', 'startup'],
            'trusted_stream_hosts' => $this->trustedBackupHosts(),
            'trusted_stream_origins' => $this->trustedBackupOrigins(),
        ]]);
    }

    public function server(string $uuid): JsonResponse
    {
        $server = $this->serverByUuid($uuid);
        $owner = $this->serverOwner($server);
        $resource = $this->callClient(ServerController::class, 'index', GetServerRequest::class, $server, method: 'GET', routeName: 'api:client:server.view');
        $attributes = $resource['attributes'] ?? [];
        $startup = $this->startupData($server);
        $egg = $server->egg;

        return response()->json(['data' => [
            'uuid' => $server->uuid,
            'identifier' => $attributes['identifier'] ?? $server->uuidShort,
            'name' => $server->name,
            'description' => $server->description,
            'status' => $server->status,
            'suspended' => $server->isSuspended(),
            'installing' => ! $server->isInstalled(),
            'docker_image' => $server->image,
            'limits' => $attributes['limits'] ?? [],
            'feature_limits' => $attributes['feature_limits'] ?? [],
            'egg' => ['id' => $egg?->id, 'name' => $egg?->name, 'docker_images' => $this->dockerImages($egg?->docker_images ?? [])],
            'startup' => $startup,
            'user_permissions' => $owner->permissionsOn($server),
        ]]);
    }

    public function resources(string $uuid): JsonResponse
    {
        $server = $this->serverByUuid($uuid);
        $payload = $this->callClient(ResourceUtilizationController::class, '__invoke', GetResourcesRequest::class, $server, method: 'GET', routeName: 'api:client:server.resources');

        return response()->json(['data' => $payload['attributes'] ?? []]);
    }

    public function power(Request $request, string $uuid): JsonResponse
    {
        $server = $this->serverByUuid($uuid);
        $this->callClient(PowerController::class, 'index', SendPowerRequest::class, $server, $request->all());

        return response()->json(['data' => ['accepted' => true]]);
    }

    public function command(Request $request, string $uuid): JsonResponse
    {
        $server = $this->serverByUuid($uuid);
        $this->callClient(CommandController::class, 'index', SendCommandRequest::class, $server, $request->all());

        return response()->json(['data' => ['accepted' => true]]);
    }

    public function websocket(string $uuid, NodeJwt $jwt): JsonResponse
    {
        $server = $this->serverByUuid($uuid);
        $owner = $this->serverOwner($server);
        $this->assertServerAccess($server, $owner, 'GET', 'api:client:server.ws');
        throw_unless($owner->can(Permissions::WebsocketConnect->value, $server), HttpForbiddenException::class);
        throw_if($server->transfer !== null, HttpForbiddenException::class, 'Websocket access is unavailable during a server transfer.');

        $permissions = $this->websocketPermissions($owner->permissionsOn($server));
        $token = $jwt->issue(
            $server->node,
            JwtScope::Websocket,
            identifiedBy: $owner->id.$server->uuid,
            expiresAt: CarbonImmutable::now()->addMinutes(10),
            user: $owner,
            claims: ['server_uuid' => $server->uuid, 'permissions' => $permissions],
        );
        $socket = str_replace(['https://', 'http://'], ['wss://', 'ws://'], $server->node->getConnectionAddress());

        return response()->json(['data' => [
            'socket' => $socket.sprintf('/api/servers/%s/ws', $server->uuid),
            'token' => $token->toString(),
            'expires_in' => 600,
        ]]);
    }

    public function listFiles(Request $request, string $uuid): JsonResponse
    {
        $result = $this->callClient(FileController::class, 'directory', ListFilesRequest::class, $this->serverByUuid($uuid), $request->query(), method: 'GET');

        return response()->json(['data' => array_map($this->attributes(...), $result['data'] ?? [])]);
    }

    public function fileContents(Request $request, string $uuid): JsonResponse
    {
        $result = $this->callClient(FileController::class, 'contents', GetFileContentsRequest::class, $this->serverByUuid($uuid), $request->query(), method: 'GET');

        return response()->json(['data' => ['content' => $result['content'] ?? '']]);
    }

    public function fileDownload(Request $request, string $uuid): JsonResponse
    {
        $result = $this->callClient(FileController::class, 'download', GetFileContentsRequest::class, $this->serverByUuid($uuid), $request->query(), method: 'GET');

        $url = (string) data_get($result, 'attributes.url', '');
        $parts = parse_url($url);

        return response()->json(['data' => [
            'url' => $url,
            'filename' => basename((string) $request->query('file', '')),
            'content_type' => null,
            'content_length' => null,
            'host' => is_array($parts) ? ($parts['host'] ?? null) : null,
        ]]);
    }

    public function fileUpload(Request $request, string $uuid): JsonResponse
    {
        $result = $this->callClient(FileUploadController::class, '__invoke', UploadFileRequest::class, $this->serverByUuid($uuid), $request->query(), method: 'GET');

        $url = (string) data_get($result, 'attributes.url', '');
        $parts = parse_url($url);

        return response()->json(['data' => [
            'url' => $url,
            'filename' => null,
            'content_type' => null,
            'content_length' => null,
            'host' => is_array($parts) ? ($parts['host'] ?? null) : null,
        ]]);
    }

    public function renameFiles(Request $request, string $uuid): JsonResponse
    {
        $this->callClient(FileController::class, 'rename', RenameFileRequest::class, $this->serverByUuid($uuid), $request->all(), method: 'PUT');

        return $this->accepted();
    }

    public function copyFile(Request $request, string $uuid): JsonResponse
    {
        $this->callClient(FileController::class, 'copy', CopyFileRequest::class, $this->serverByUuid($uuid), $request->all());

        return $this->accepted();
    }

    public function writeFile(Request $request, string $uuid): JsonResponse
    {
        $parameters = $request->query();
        $body = $request->getContent();
        if ($request->isJson()) {
            $content = $this->validatedFileContent($request);
            $parameters['file'] = $request->query('file', $request->input('file'));
            $body = $content;
        }

        $this->callClient(FileController::class, 'write', WriteFileContentRequest::class, $this->serverByUuid($uuid), $parameters, rawBody: $body);

        return $this->accepted();
    }

    private function validatedFileContent(Request $request): string
    {
        return $request->validate(['content' => ['present', 'nullable', 'string']])['content'] ?? '';
    }

    public function compressFiles(Request $request, string $uuid): JsonResponse
    {
        $result = $this->callClient(FileController::class, 'compress', CompressFilesRequest::class, $this->serverByUuid($uuid), $request->all());

        return response()->json(['data' => $result['attributes'] ?? []]);
    }

    public function decompressFiles(Request $request, string $uuid): JsonResponse
    {
        $this->callClient(FileController::class, 'decompress', DecompressFilesRequest::class, $this->serverByUuid($uuid), $request->all());

        return $this->accepted();
    }

    public function deleteFiles(Request $request, string $uuid): JsonResponse
    {
        $this->callClient(FileController::class, 'delete', DeleteFileRequest::class, $this->serverByUuid($uuid), $request->all());

        return $this->accepted();
    }

    public function createFolder(Request $request, string $uuid): JsonResponse
    {
        $this->callClient(FileController::class, 'create', CreateFolderRequest::class, $this->serverByUuid($uuid), $request->all());

        return $this->accepted();
    }

    public function chmodFiles(Request $request, string $uuid): JsonResponse
    {
        $this->callClient(FileController::class, 'chmod', ChmodFilesRequest::class, $this->serverByUuid($uuid), $request->all());

        return $this->accepted();
    }

    public function listBackups(Request $request, string $uuid): JsonResponse
    {
        $server = $this->serverByUuid($uuid);
        $query = array_merge($request->query(), ['per_page' => 50]);
        $result = $this->callClient(BackupController::class, 'index', ListBackupsRequest::class, $server, $query, method: 'GET');
        [$backups, $pagination] = $this->backupPage($result);
        $lastPage = min(100, max(1, (int) data_get($pagination, 'total_pages', 1)));
        for ($pageNumber = 2; $pageNumber <= $lastPage; $pageNumber++) {
            $next = $this->callClient(BackupController::class, 'index', ListBackupsRequest::class, $server, ['per_page' => 50, 'page' => $pageNumber], method: 'GET');
            [$nextBackups] = $this->backupPage($next);
            $backups = [...$backups, ...$nextBackups];
        }

        return response()->json([
            'data' => array_map($this->backupAttributes(...), $backups),
            'meta' => [
                'pagination' => ['current_page' => 1, 'last_page' => $lastPage, 'per_page' => 50, 'total' => (int) data_get($pagination, 'total', count($backups))],
                'backup_count' => data_get($result, 'meta.backup_count', 0),
            ],
        ]);
    }

    public function createBackup(Request $request, string $uuid): JsonResponse
    {
        $result = $this->callClient(BackupController::class, 'store', StoreBackupRequest::class, $this->serverByUuid($uuid), $request->all());

        return response()->json(['data' => $this->backupAttributes($result['attributes'] ?? [])], Response::HTTP_CREATED);
    }

    public function viewBackup(string $uuid, string $backup): JsonResponse
    {
        $server = $this->serverByUuid($uuid);
        $result = $this->callClient(BackupController::class, 'view', ViewBackupRequest::class, $server, backup: $this->backupByUuid($server, $backup), method: 'GET');

        return response()->json(['data' => $this->backupAttributes($result['attributes'] ?? [])]);
    }

    public function backupDownload(string $uuid, string $backup): JsonResponse
    {
        $server = $this->serverByUuid($uuid);
        $backupModel = $this->backupByUuid($server, $backup);
        $result = $this->callClient(BackupController::class, 'download', DownloadBackupRequest::class, $server, backup: $backupModel, method: 'GET');

        $url = (string) data_get($result, 'attributes.url', '');
        $parts = parse_url($url);

        return response()->json(['data' => [
            'url' => $url,
            'filename' => $backupModel->name.'.tar.gz',
            'content_type' => 'application/gzip',
            'content_length' => null,
            'host' => is_array($parts) ? ($parts['host'] ?? null) : null,
        ]]);
    }

    public function toggleBackupLock(Request $request, string $uuid, string $backup): JsonResponse
    {
        $server = $this->serverByUuid($uuid);
        $backupModel = $this->backupByUuid($server, $backup);
        $locked = $request->validate(['locked' => ['required', 'boolean']])['locked'];
        throw_unless($this->serverOwner($server)->can(Permissions::BackupDelete->value, $server), HttpForbiddenException::class);

        if ($backupModel->is_locked !== (bool) $locked) {
            $result = $this->callClient(BackupController::class, 'toggleLock', ToggleBackupLockRequest::class, $server, backup: $backupModel);

            return response()->json(['data' => $this->backupAttributes($result['attributes'] ?? [])]);
        }

        return response()->json(['data' => $this->backupAttributes(['uuid' => $backupModel->uuid, 'is_locked' => $backupModel->is_locked])]);
    }

    public function restoreBackup(Request $request, string $uuid, string $backup): JsonResponse
    {
        $server = $this->serverByUuid($uuid);
        $owner = $this->serverOwner($server);
        $this->assertServerAccess($server, $owner, 'POST', 'api:client:server.backups.restore');
        throw_unless($owner->can(Permissions::BackupRestore->value, $server), HttpForbiddenException::class);
        $state = App::make(ReadsServerState::class)->read($server)->state;
        throw_unless(in_array($state, ['offline', 'stopped'], true), BadRequestHttpException::class, 'Stop the server before restoring a backup.');
        $this->callClient(BackupController::class, 'restore', RestoreBackupRequest::class, $server, $request->all(), $this->backupByUuid($server, $backup));

        return $this->accepted();
    }

    public function deleteBackup(string $uuid, string $backup): JsonResponse
    {
        $server = $this->serverByUuid($uuid);
        $this->callClient(BackupController::class, 'delete', DeleteBackupRequest::class, $server, backup: $this->backupByUuid($server, $backup), method: 'DELETE');

        return $this->accepted();
    }

    public function startup(string $uuid): JsonResponse
    {
        $data = $this->startupData($this->serverByUuid($uuid));

        return response()->json(['data' => $data]);
    }

    public function updateStartupVariable(Request $request, string $uuid): JsonResponse
    {
        $result = $this->callClient(StartupController::class, 'update', UpdateStartupVariableRequest::class, $this->serverByUuid($uuid), $request->all(), method: 'PUT');

        return response()->json(['data' => [
            'variable' => $result['attributes'] ?? [],
            'command' => data_get($result, 'meta.startup_command'),
            'raw_command' => data_get($result, 'meta.raw_startup_command'),
        ]]);
    }

    public function updateStartupImage(Request $request, string $uuid): JsonResponse
    {
        $image = $request->validate(['image' => ['required', 'string']])['image'];
        $this->callClient(SettingsController::class, 'dockerImage', SetDockerImageRequest::class, $this->serverByUuid($uuid), ['docker_image' => $image], method: 'PUT');

        return $this->accepted();
    }

    private function startupData(Server $server): array
    {
        $result = $this->callClient(StartupController::class, 'index', GetStartupRequest::class, $server, method: 'GET');

        return [
            'command' => data_get($result, 'meta.startup_command'),
            'raw_command' => data_get($result, 'meta.raw_startup_command'),
            'docker_image' => $server->image,
            'docker_images' => $this->dockerImages(data_get($result, 'meta.docker_images', [])),
            'variables' => array_map($this->attributes(...), $result['data'] ?? []),
        ];
    }

    private function serverByUuid(string $uuid): Server
    {
        return Server::query()->where('uuid', $uuid)->firstOrFail();
    }

    private function backupByUuid(Server $server, string $uuid): Backup
    {
        return $server->backups()->where('uuid', $uuid)->firstOrFail();
    }

    /**
     * The Application token authenticates this bridge. Client API controllers and
     * FormRequests still perform their native validation and owner permission checks.
     *
     * @return array<string, mixed>
     */
    private function callClient(
        string $controllerClass,
        string $action,
        string $requestClass,
        Server $server,
        array $input = [],
        ?Backup $backup = null,
        ?string $rawBody = null,
        string $method = 'POST',
        ?string $routeName = null,
    ): array {
        $owner = $this->serverOwner($server);
        $clientRequest = Request::create(
            '/api/client/servers/'.$server->uuid,
            $method,
            $input,
            server: [],
            content: $rawBody,
        );
        $clientRequest->headers->set('Accept', 'application/json');
        $clientRequest->setUserResolver(static fn (): User => $owner);

        $route = new Route([$method], '/', static fn (): null => null);
        $route->bind($clientRequest);
        $route->setParameter('server', $server);
        if ($routeName !== null) {
            $route->name($routeName);
        }
        if ($backup instanceof Backup) {
            $route->setParameter('backup', $backup);
        }
        $clientRequest->setRouteResolver(static fn (): Route => $route);
        App::make(AuthenticateServerAccess::class)->handle($clientRequest, static fn (): Response => new Response);

        /** @var FormRequest $form */
        $form = $requestClass::createFrom($clientRequest);
        $form->setContainer(App::getFacadeRoot());
        $form->setRedirector(Redirect::getFacadeRoot());
        $form->validateResolved();

        $guard = Auth::guard();
        $previousUser = $guard->user();
        $guard->setUser($owner);
        try {
            $controller = App::make($controllerClass);
            $result = App::call([$controller, $action], [
                'request' => $form,
                'server' => $server,
                'backup' => $backup,
            ]);
        } finally {
            if ($previousUser !== null) {
                $guard->setUser($previousUser);
            } elseif (method_exists($guard, 'forgetUser')) {
                $guard->forgetUser();
            } else {
                Auth::forgetGuards();
            }
        }

        if ($result instanceof JsonResource) {
            $response = $result->toResponse($form);
            $payload = $response instanceof JsonResponse ? $response->getData(true) : [];
        } elseif ($result instanceof JsonResponse) {
            $payload = $result->getData(true);
        } elseif ($result instanceof Response) {
            if ($result->getStatusCode() >= 400) {
                abort($result->getStatusCode(), $result->getContent());
            }
            $payload = ['content' => $result->getContent()];
        } elseif (is_array($result)) {
            $payload = $result;
        } else {
            $payload = [];
        }

        return $this->normalize($payload);
    }

    /** @param array<string, mixed> $payload
     *  @return array<string, mixed>
     */
    private function normalize(array $payload): array
    {
        if (isset($payload['errors'])) {
            abort(response()->json($payload, 422));
        }

        if (isset($payload['attributes']) && is_array($payload['attributes'])) {
            return ['attributes' => $payload['attributes'], ...array_diff_key($payload, ['attributes' => true])];
        }

        if (isset($payload['data']) && is_array($payload['data']) && isset($payload['data']['attributes'])) {
            $payload['data'] = $payload['data']['attributes'];
        }

        return $payload;
    }

    /** @param array<string, mixed> $resource
     *  @return array<string, mixed>
     */
    private function attributes(array $resource): array
    {
        return is_array($resource['attributes'] ?? null) ? $resource['attributes'] : $resource;
    }

    /** @param array<string, mixed> $resource
     *  @return array<string, mixed>
     */
    private function backupAttributes(array $resource): array
    {
        $resource = $this->attributes($resource);
        $resource['completed'] = (bool) ($resource['is_successful'] ?? false);
        $resource['locked'] = (bool) ($resource['is_locked'] ?? false);
        $resource['status'] = $resource['completed'] ? 'completed' : (($resource['completed_at'] ?? null) === null ? 'processing' : 'failed');

        return $resource;
    }

    /**
     * Panel 2 returns list data and pagination metadata as siblings. Keep support
     * for the nested envelope used by earlier Panel resource responses as well.
     *
     * @return array{0: list<array<string, mixed>>, 1: array<string, mixed>}
     */
    private function backupPage(array $result): array
    {
        $data = $result['data'] ?? [];
        if (is_array($data) && is_array($data['data'] ?? null)) {
            return [$data['data'], is_array($data['meta']['pagination'] ?? null) ? $data['meta']['pagination'] : []];
        }

        return [
            is_array($data) ? array_values($data) : [],
            is_array($result['meta']['pagination'] ?? null) ? $result['meta']['pagination'] : [],
        ];
    }

    /** @param array<string, string> $images
     *  @return array<string, string>
     */
    private function dockerImages(array $images): array
    {
        $normalized = [];
        foreach ($images as $label => $image) {
            if (is_string($label) && is_string($image)) {
                $normalized[$image] = $label;
            }
        }

        return $normalized;
    }

    private function accepted(): JsonResponse
    {
        return response()->json(['data' => ['accepted' => true]]);
    }

    /** @param array<array-key, string> $permissions
     *  @return list<string>
     */
    private function websocketPermissions(array $permissions): array
    {
        if (in_array('*', $permissions, true)) {
            return [Permissions::WebsocketConnect->value];
        }

        return array_values(array_filter(
            $permissions,
            static fn (string $permission): bool => ! str_starts_with($permission, 'admin.')
                && ! str_starts_with($permission, 'admin:'),
        ));
    }

    private function assertServerAccess(Server $server, User $owner, string $method, string $routeName): void
    {
        $request = Request::create('/api/client/servers/'.$server->uuid, $method);
        $request->setUserResolver(static fn (): User => $owner);
        $route = new Route([$method], '/', static fn (): null => null);
        $route->bind($request);
        $route->setParameter('server', $server);
        $route->name($routeName);
        $request->setRouteResolver(static fn (): Route => $route);

        App::make(AuthenticateServerAccess::class)->handle($request, static fn (): Response => new Response);
    }

    private function serverOwner(Server $server): User
    {
        $owner = clone $server->user;
        $owner->root_admin = false;

        return $owner;
    }

    /** @return list<string> */
    private function trustedBackupHosts(): array
    {
        if (config('backups.default') !== 's3') {
            return [];
        }

        $endpoint = config('backups.disks.s3.endpoint');
        $region = (string) config('backups.disks.s3.region', '');
        $bucket = (string) config('backups.disks.s3.bucket', '');
        if (is_string($endpoint) && $endpoint !== '') {
            $host = parse_url($endpoint, PHP_URL_HOST);
            if (! is_string($host) || $host === '') {
                return [];
            }
            if (config('backups.disks.s3.use_path_style_endpoint') || $bucket === '') {
                return [strtolower($host)];
            }

            return [strtolower($bucket.'.'.$host)];
        }
        if ($bucket === '' || $region === '') {
            return [];
        }

        return [strtolower(config('backups.disks.s3.use_accelerate_endpoint')
            ? $bucket.'.s3-accelerate.amazonaws.com'
            : $bucket.'.s3.'.$region.'.amazonaws.com')];
    }

    /** @return list<string> */
    private function trustedBackupOrigins(): array
    {
        if (config('backups.default') !== 's3') {
            return [];
        }

        $endpoint = config('backups.disks.s3.endpoint');
        $bucket = (string) config('backups.disks.s3.bucket', '');
        if (is_string($endpoint) && $endpoint !== '') {
            $parts = parse_url($endpoint);
            if (! is_array($parts) || ! in_array($parts['scheme'] ?? null, ['http', 'https'], true) || empty($parts['host'])) {
                return [];
            }

            $host = strtolower($parts['host']);
            if (! config('backups.disks.s3.use_path_style_endpoint') && $bucket !== '') {
                $host = strtolower($bucket.'.'.$host);
            }
            $host = str_contains($host, ':') ? '['.$host.']' : $host;

            return [strtolower($parts['scheme']).'://'.$host.(isset($parts['port']) ? ':'.$parts['port'] : '')];
        }

        $host = (string) ($this->trustedBackupHosts()[0] ?? '');

        return $host === '' ? [] : ['https://'.$host];
    }
}
