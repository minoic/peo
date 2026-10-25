<?php

declare(strict_types=1);

use Peo\PanelExtension\Http\BridgeController;
use Illuminate\Contracts\Console\Kernel;
use Illuminate\Database\Eloquent\Collection as EloquentCollection;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Http\Request;
use Illuminate\Routing\Route;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Pterodactyl\Actions\Backups\InitiateBackup;
use Pterodactyl\Exceptions\Service\Backup\TooManyBackupsException;
use Pterodactyl\Http\Controllers\Api\Client\Servers\StartupController;
use Pterodactyl\Http\Middleware\Api\Client\Server\AuthenticateServerAccess;
use Pterodactyl\Http\Requests\Api\Client\Servers\SendPowerRequest;
use Pterodactyl\Http\Requests\Api\Client\Servers\Settings\SetDockerImageRequest;
use Pterodactyl\Http\Requests\Api\Client\Servers\Startup\UpdateStartupVariableRequest;
use Pterodactyl\Models\Backup;
use Pterodactyl\Models\Egg;
use Pterodactyl\Models\Node;
use Pterodactyl\Models\Server;
use Pterodactyl\Models\User;
use Pterodactyl\Contracts\Servers\UpdatesServerVariable;
use Pterodactyl\Contracts\Servers\ReadsServerState;
use Pterodactyl\Data\ServerState;
use Symfony\Component\HttpKernel\Exception\BadRequestHttpException;
use Symfony\Component\HttpKernel\Exception\ConflictHttpException;
use Symfony\Component\HttpFoundation\Response;

$autoload = getenv('PANEL_VENDOR_AUTOLOAD') ?: '/app/vendor/autoload.php';
$loader = require $autoload;
$loader->addPsr4('Peo\\PanelExtension\\', dirname(__DIR__).'/src/');
$app = require '/app/bootstrap/app.php';
$app->make(Kernel::class)->bootstrap();
if (getenv('PEO_CONTRACT_SQLITE') === '1') {
    config(['database.default' => 'sqlite', 'database.connections.sqlite.database' => ':memory:']);
    Illuminate\Support\Facades\DB::setDefaultConnection('sqlite');
    Illuminate\Support\Facades\DB::purge('sqlite');
}

require dirname(__DIR__).'/routes/application.php';
$routes = Illuminate\Support\Facades\Route::getRoutes();
foreach (['GET', 'POST'] as $method) {
    $route = $routes->match(Request::create('/v1/capabilities', $method));
    if ($route->getActionName() !== BridgeController::class.'@capabilities') {
        throw new RuntimeException($method.' capabilities route does not use the side-effect-free probe');
    }
}

$controller = (new ReflectionClass(BridgeController::class))->newInstanceWithoutConstructor();
$invoke = static function (string $method, mixed ...$arguments) use ($controller): mixed {
    return (new ReflectionMethod($controller, $method))->invoke($controller, ...$arguments);
};
$same = static function (mixed $expected, mixed $actual, string $case): void {
    if ($expected !== $actual) {
        throw new RuntimeException($case.' mismatch: '.var_export($actual, true));
    }
};

$backup = $invoke('backupAttributes', [
    'uuid' => 'backup-id',
    'is_successful' => true,
    'is_locked' => false,
    'completed_at' => '2026-10-17T00:00:00Z',
]);
$same(true, $backup['completed'], 'backup completed');
$same(false, $backup['locked'], 'backup lock');
$same('completed', $backup['status'], 'backup status');
$backupRecord = ['attributes' => ['uuid' => 'panel-2-backup']];
[$panelTwoBackups, $panelTwoPagination] = $invoke('backupPage', [
    'data' => [$backupRecord],
    'meta' => ['backup_count' => 1, 'pagination' => ['total' => 1, 'total_pages' => 1]],
]);
$same([$backupRecord], $panelTwoBackups, 'Panel 2 root-level backup list');
$same(1, $panelTwoPagination['total'], 'Panel 2 root-level backup pagination');
[$nestedBackups, $nestedPagination] = $invoke('backupPage', [
    'data' => ['data' => [$backupRecord], 'meta' => ['pagination' => ['total' => 2, 'total_pages' => 2]]],
]);
$same([$backupRecord], $nestedBackups, 'nested backup list compatibility');
$same(2, $nestedPagination['total_pages'], 'nested backup pagination compatibility');

$images = $invoke('dockerImages', ['Java 21' => 'ghcr.io/pterodactyl/yolks:java_21']);
$same(['ghcr.io/pterodactyl/yolks:java_21' => 'Java 21'], $images, 'docker image direction');

$rootAdmin = new User;
$rootAdmin->setAttribute('id', 42);
$rootAdmin->setAttribute('root_admin', true);
$server = new Server;
$server->setRelation('user', $rootAdmin);
$owner = $invoke('serverOwner', $server);
$same(false, (bool) $owner->root_admin, 'root admin owner privilege');
$same(42, (int) $owner->id, 'owner identity');

$consoleOwner = new User;
$consoleOwner->setAttribute('id', 100);
$consoleOwner->setAttribute('root_admin', false);
$consoleServer = new Server;
$consoleServer->setAttribute('owner_id', 100);
$ownerPermissions = $consoleOwner->permissionsOn($consoleServer);
$same(['*'], $ownerPermissions, 'server owner effective permissions');
$same(['websocket.connect'], $invoke('websocketPermissions', $ownerPermissions), 'owner websocket permissions are explicit and minimal');
$same(
    ['websocket.connect'],
    $invoke('websocketPermissions', ['*', 'admin.websocket.errors', 'admin:servers.read']),
    'wildcard does not grant Panel administrator permissions',
);
$same(
    ['websocket.connect', 'control.console'],
    $invoke('websocketPermissions', ['websocket.connect', 'control.console', 'admin.websocket.errors', 'admin:servers.read']),
    'subuser permissions remain scoped to explicit server permissions',
);

config([
    'backups.default' => 's3',
    'backups.disks.s3.endpoint' => 'https://s3.example.test',
    'backups.disks.s3.bucket' => 'peo-backups',
    'backups.disks.s3.region' => 'test-1',
    'backups.disks.s3.use_path_style_endpoint' => false,
    'backups.disks.s3.use_accelerate_endpoint' => false,
]);
$same(['peo-backups.s3.example.test'], $invoke('trustedBackupHosts'), 'virtual-hosted S3 endpoint');
config(['backups.disks.s3.use_path_style_endpoint' => true]);
$same(['s3.example.test'], $invoke('trustedBackupHosts'), 'path-style S3 endpoint');
config([
    'backups.disks.s3.endpoint' => null,
    'backups.disks.s3.use_path_style_endpoint' => false,
    'backups.disks.s3.use_accelerate_endpoint' => true,
]);
$same(['peo-backups.s3-accelerate.amazonaws.com'], $invoke('trustedBackupHosts'), 'accelerated AWS endpoint');
$same(['https://peo-backups.s3-accelerate.amazonaws.com'], $invoke('trustedBackupOrigins'), 'accelerated AWS origin');
config([
    'backups.disks.s3.endpoint' => 'https://s3.example.test:9443',
    'backups.disks.s3.use_accelerate_endpoint' => false,
    'backups.disks.s3.use_path_style_endpoint' => false,
]);
$same(['https://peo-backups.s3.example.test:9443'], $invoke('trustedBackupOrigins'), 'virtual-hosted S3 custom port origin');
config(['backups.disks.s3.use_path_style_endpoint' => true]);
$same(['https://s3.example.test:9443'], $invoke('trustedBackupOrigins'), 'path-style S3 custom port origin');

$makeRequest = static function (string $uri, string $method, array $input, Server $server, User $user, ?string $name = null): Request {
    $request = Request::create('/api/client/servers/test', $method, $input);
    $route = new Route([$method], '/api/client/servers/{server}', static fn (): null => null);
    $route->bind($request);
    $route->setParameter('server', $server);
    if ($name !== null) {
        $route->name($name);
    }
    $request->setRouteResolver(static fn (): Route => $route);
    $request->setUserResolver(static fn (): User => $user);

    return $request;
};
$form = static function (string $class, Request $request) use ($app): FormRequest {
    $formRequest = $class::createFrom($request);
    $formRequest->setContainer($app);
    $formRequest->setRedirector($app->make('redirect'));

    return $formRequest;
};
$expectException = static function (string $expected, callable $callback, string $case): Throwable {
    try {
        $callback();
    } catch (Throwable $exception) {
        if (! $exception instanceof $expected) {
            throw new RuntimeException($case.' threw '.get_class($exception).' instead of '.$expected, previous: $exception);
        }

        return $exception;
    }

    throw new RuntimeException($case.' did not throw '.$expected);
};

$owner = new User;
$owner->setAttribute('id', 100);
$owner->setAttribute('root_admin', true);
$server = new Server;
$server->setAttribute('id', 1);
$server->setAttribute('owner_id', 100);
$server->setAttribute('egg_id', 12);
$server->setAttribute('status', '');
$server->exists = true;
$server->setRelation('transfer', null);
$expectException(\Illuminate\Validation\ValidationException::class, static function () use ($makeRequest, $form, $server, $owner): void {
    $form(SendPowerRequest::class, $makeRequest('/power', 'POST', ['signal' => 'explode'], $server, $owner))->validateResolved();
}, 'invalid power signal');

Schema::create('egg_variables', static function (Blueprint $table): void {
    $table->increments('id');
    $table->unsignedInteger('egg_id');
    $table->string('env_variable');
    $table->boolean('user_viewable')->default(false);
    $table->boolean('user_editable')->default(false);
    $table->string('rules')->nullable();
});
Schema::create('server_variables', static function (Blueprint $table): void {
    $table->increments('id');
    $table->unsignedInteger('server_id');
    $table->unsignedInteger('variable_id');
    $table->text('variable_value')->nullable();
});
Schema::create('backups', static function (Blueprint $table): void {
    $table->increments('id');
    $table->unsignedInteger('server_id');
    $table->string('uuid');
    $table->boolean('is_successful')->default(false);
    $table->boolean('is_locked')->default(false);
    $table->timestamp('completed_at')->nullable();
    $table->timestamp('deleted_at')->nullable();
    $table->timestamp('created_at')->nullable();
});
Schema::create('users', static function (Blueprint $table): void {
    $table->increments('id');
    $table->boolean('root_admin')->default(false);
});
Schema::create('nodes', static function (Blueprint $table): void {
    $table->increments('id');
    $table->boolean('maintenance_mode')->default(false);
});
Schema::create('allocations', static function (Blueprint $table): void {
    $table->increments('id');
});
Schema::create('server_transfers', static function (Blueprint $table): void {
    $table->increments('id');
    $table->unsignedInteger('server_id');
    $table->boolean('successful')->nullable();
});
Schema::create('servers', static function (Blueprint $table): void {
    $table->increments('id');
    $table->string('uuid');
    $table->unsignedInteger('owner_id');
    $table->unsignedInteger('node_id');
    $table->unsignedInteger('allocation_id')->nullable();
    $table->unsignedInteger('egg_id')->nullable();
    $table->string('status')->nullable();
});
DB::table('egg_variables')->insert([
    ['id' => 1, 'egg_id' => 12, 'env_variable' => 'VISIBLE_LOCKED', 'user_viewable' => true, 'user_editable' => false, 'rules' => 'string'],
    ['id' => 2, 'egg_id' => 12, 'env_variable' => 'HIDDEN', 'user_viewable' => false, 'user_editable' => true, 'rules' => 'string'],
]);
$server->setAttribute('startup', 'run {{VISIBLE_LOCKED}}');
$updates = new class implements UpdatesServerVariable {
    public bool $called = false;

    public function update(Server $server, int $variableId, string $value): void
    {
        $this->called = true;
    }
};
$startup = new StartupController;
foreach ([['VISIBLE_LOCKED', BadRequestHttpException::class], ['HIDDEN', BadRequestHttpException::class]] as [$key, $exception]) {
    $request = $form(UpdateStartupVariableRequest::class, $makeRequest('/startup', 'PUT', ['key' => $key, 'value' => 'changed'], $server, $owner));
    $request->validateResolved();
    $expectException($exception, static fn () => $startup->update($request, $updates, $server), 'startup variable '.$key);
}
$same(false, $updates->called, 'read-only and hidden startup variable mutation');

$egg = new Egg;
$egg->setAttribute('docker_images', ['Java 21' => 'ghcr.io/example/java:21']);
$server->setRelation('egg', $egg);
$expectException(\Illuminate\Validation\ValidationException::class, static function () use ($makeRequest, $form, $server, $owner): void {
    $form(SetDockerImageRequest::class, $makeRequest('/image', 'PUT', ['docker_image' => 'ghcr.io/other/java:21'], $server, $owner))->validateResolved();
}, 'image outside egg allowlist');

$middleware = new AuthenticateServerAccess;
$normalUser = new User;
$normalUser->setAttribute('id', 100);
$normalUser->setAttribute('root_admin', false);
$node = new Node;
$node->setAttribute('maintenance_mode', false);
$stateServer = new Server;
$stateServer->setAttribute('id', 1);
$stateServer->setAttribute('owner_id', 100);
$stateServer->setAttribute('status', Server::STATUS_SUSPENDED);
$stateServer->setRelation('node', $node);
$stateServer->setRelation('transfer', null);
$stateServer->setRelation('subusers', new EloquentCollection);
$expectException(ConflictHttpException::class, static fn () => $middleware->handle($makeRequest('/power', 'POST', [], $stateServer, $normalUser, 'api:client:server.power'), static fn () => new Response), 'suspended server power guard');
$expectException(ConflictHttpException::class, static fn () => $middleware->handle($makeRequest('/resources', 'GET', [], $stateServer, $normalUser, 'api:client:server.resources'), static fn () => new Response), 'suspended server resources guard for non-admin owner');
$stateServer->setAttribute('status', Server::STATUS_INSTALLING);
$middleware->handle($makeRequest('/server', 'GET', [], $stateServer, $normalUser, 'api:client:server.view'), static fn () => new Response);
$expectException(ConflictHttpException::class, static fn () => $middleware->handle($makeRequest('/resources', 'GET', [], $stateServer, $normalUser, 'api:client:server.resources'), static fn () => new Response), 'installing server resource guard');

DB::table('backups')->insert([
    ['id' => 1, 'server_id' => 1, 'uuid' => 'server-a-backup', 'is_successful' => true, 'is_locked' => true, 'created_at' => now()],
    ['id' => 2, 'server_id' => 2, 'uuid' => 'server-b-backup', 'is_successful' => true, 'is_locked' => false, 'created_at' => now()],
]);
$serverA = new Server;
$serverA->setAttribute('id', 1);
$serverA->setAttribute('backup_limit', 1);
$serverBBackup = new Backup;
$serverBBackup->setAttribute('uuid', 'server-b-backup');
$expectException(ModelNotFoundException::class, static fn () => $invoke('backupByUuid', $serverA, 'server-b-backup'), 'cross-server backup lookup');
$same('server-a-backup', $invoke('backupByUuid', $serverA, 'server-a-backup')->uuid, 'server-scoped backup lookup');
config(['backups.throttles.period' => 0]);
$initiator = (new ReflectionClass(InitiateBackup::class))->newInstanceWithoutConstructor();
$expectException(TooManyBackupsException::class, static fn () => $initiator->initiate($serverA, 'replacement', override: true), 'locked backup quota');

DB::table('users')->insert(['id' => 200, 'root_admin' => false]);
DB::table('nodes')->insert(['id' => 20, 'maintenance_mode' => false]);
DB::table('allocations')->insert(['id' => 30]);
DB::table('servers')->insert([
    ['id' => 40, 'uuid' => 'server-resource-a', 'owner_id' => 200, 'node_id' => 20, 'allocation_id' => 30, 'status' => null],
    ['id' => 41, 'uuid' => 'server-resource-b', 'owner_id' => 200, 'node_id' => 20, 'allocation_id' => 30, 'status' => null],
]);
$app->instance(ReadsServerState::class, new class implements ReadsServerState {
    public function read(Server $server): ServerState
    {
        return new ServerState('offline', false, $server->id, 0, 0, 0, 0, 0);
    }
});
$resourceResponse = $controller->resources('server-resource-b')->getData(true);
$same(41, $resourceResponse['data']['resources']['memory_bytes'], 'UUID-scoped server resources');

$emptyContent = $invoke('validatedFileContent', Request::create('/write', 'POST', ['content' => null]));
$same('', $emptyContent, 'empty file content after Laravel normalization');
$emptyContent = $invoke('validatedFileContent', Request::create('/write', 'POST', ['content' => '']));
$same('', $emptyContent, 'empty file content');
$expectException(\Illuminate\Validation\ValidationException::class, static function () use ($invoke): void {
    $invoke('validatedFileContent', Request::create('/write', 'POST'));
}, 'missing file content');
$expectException(\Illuminate\Validation\ValidationException::class, static function () use ($invoke): void {
    $invoke('validatedFileContent', Request::create('/write', 'POST', ['content' => ['not', 'a', 'string']]));
}, 'non-string file content');

fwrite(STDOUT, "Bridge contract checks passed.\n");
