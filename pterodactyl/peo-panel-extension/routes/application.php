<?php

declare(strict_types=1);

use Illuminate\Support\Facades\Route;
use Peo\PanelExtension\Http\BridgeController;

Route::prefix('v1')->group(function (): void {
    Route::get('/capabilities', [BridgeController::class, 'capabilities']);
    Route::post('/capabilities', [BridgeController::class, 'capabilities']);
    Route::get('/servers/{uuid}', [BridgeController::class, 'server'])->whereUuid('uuid');
    Route::get('/servers/{uuid}/resources', [BridgeController::class, 'resources'])->whereUuid('uuid');
    Route::post('/servers/{uuid}/power', [BridgeController::class, 'power'])->whereUuid('uuid');
    Route::post('/servers/{uuid}/command', [BridgeController::class, 'command'])->whereUuid('uuid');
    Route::post('/servers/{uuid}/websocket', [BridgeController::class, 'websocket'])->whereUuid('uuid');

    Route::prefix('/servers/{uuid}/files')->where(['uuid' => '[0-9a-fA-F-]{36}'])->group(function (): void {
        Route::get('/list', [BridgeController::class, 'listFiles']);
        Route::get('/contents', [BridgeController::class, 'fileContents']);
        Route::get('/download', [BridgeController::class, 'fileDownload']);
        Route::get('/upload', [BridgeController::class, 'fileUpload']);
        Route::put('/rename', [BridgeController::class, 'renameFiles']);
        Route::post('/copy', [BridgeController::class, 'copyFile']);
        Route::post('/write', [BridgeController::class, 'writeFile']);
        Route::post('/compress', [BridgeController::class, 'compressFiles']);
        Route::post('/decompress', [BridgeController::class, 'decompressFiles']);
        Route::post('/delete', [BridgeController::class, 'deleteFiles']);
        Route::post('/create-folder', [BridgeController::class, 'createFolder']);
        Route::post('/chmod', [BridgeController::class, 'chmodFiles']);
    });

    Route::prefix('/servers/{uuid}/backups')->where(['uuid' => '[0-9a-fA-F-]{36}'])->group(function (): void {
        Route::get('/', [BridgeController::class, 'listBackups']);
        Route::post('/', [BridgeController::class, 'createBackup']);
        Route::get('/{backup}', [BridgeController::class, 'viewBackup'])->whereUuid('backup');
        Route::get('/{backup}/download', [BridgeController::class, 'backupDownload'])->whereUuid('backup');
        Route::post('/{backup}/lock', [BridgeController::class, 'toggleBackupLock'])->whereUuid('backup');
        Route::post('/{backup}/restore', [BridgeController::class, 'restoreBackup'])->whereUuid('backup');
        Route::delete('/{backup}', [BridgeController::class, 'deleteBackup'])->whereUuid('backup');
    });

    Route::get('/servers/{uuid}/startup', [BridgeController::class, 'startup'])->whereUuid('uuid');
    Route::put('/servers/{uuid}/startup/variable', [BridgeController::class, 'updateStartupVariable'])->whereUuid('uuid');
    Route::put('/servers/{uuid}/startup/image', [BridgeController::class, 'updateStartupImage'])->whereUuid('uuid');
});
