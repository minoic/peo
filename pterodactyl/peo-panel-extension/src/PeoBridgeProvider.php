<?php

declare(strict_types=1);

namespace Peo\PanelExtension;

use Pterodactyl\Extensions\ExtensionProvider;

final class PeoBridgeProvider extends ExtensionProvider
{
    public function register(): void {}

    public function boot(): void
    {
        $this->registerApiRoutes();
    }
}
