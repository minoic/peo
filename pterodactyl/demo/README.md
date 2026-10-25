# PEO Console Demo Egg

Egg 15 is a local-only shell sample for checking the PEO server console, file manager, backups, and lifecycle controls without accepting a game EULA or downloading a server jar.

`install.sh` is the Egg install script. It writes `/mnt/server/peo-demo.sh`, `README.md`, and `sample.txt` into the installer volume, which Wings exposes as `/home/container` at runtime. The configured startup command is `/bin/bash /home/container/peo-demo.sh`; it prints a ready marker and stays open for console commands.

In the console, try `help`, `version`, `status`, and `say hello`. `stop` exits the sample process.
