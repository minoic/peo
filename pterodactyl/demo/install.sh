#!/bin/sh
set -eu

mkdir -p /mnt/server

cat > /mnt/server/peo-demo.sh <<'EOF'
#!/bin/bash
set -u

show_help() {
    printf '%s\n' 'Commands: help, version, status, say <message>, stop'
}

printf '%s\n' 'PEO Console Demo ready. Type help for commands.'
while IFS= read -r line; do
    command_name="${line%% *}"
    argument="${line#* }"
    if [[ "$line" == "$command_name" ]]; then
        argument=''
    fi

    case "$command_name" in
        help)
            show_help
            ;;
        version)
            printf '%s\n' 'PEO Console Demo 1.0'
            ;;
        status)
            printf 'uptime: %s seconds\n' "$(awk '{print int($1)}' /proc/uptime)"
            printf 'hostname: %s\n' "$(hostname)"
            ;;
        say)
            printf '[demo] %s\n' "$argument"
            ;;
        stop)
            printf '%s\n' 'PEO Console Demo stopping.'
            exit 0
            ;;
        '')
            ;;
        *)
            printf 'Unknown command: %s\n' "$command_name"
            show_help
            ;;
    esac
done
EOF

cat > /mnt/server/README.md <<'EOF'
# PEO Console Demo

This lightweight shell server demonstrates the PEO console without installing a game server.

Use the console command field with `help`, `version`, `status`, `say hello`, or `stop`.
The sample has no external download, game files, or EULA requirement.
EOF

cat > /mnt/server/sample.txt <<'EOF'
PEO Console Demo

This file is recreated by the local Egg install script.
Edit it in the PEO file manager, then create a backup and restore it to see file changes roll back.
EOF

printf '%s\n' 'PEO Console Demo files installed.'
