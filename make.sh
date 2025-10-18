#!/bin/bash
set -e

SRC="src"
SRC_CONF="$SRC/conf"
SRC_BIN="$SRC/bin"
SRC_XDG="$SRC/xdg"
SRC_IMG="$SRC/img"
SRC_ICON="$SRC_IMG/icons"

CONF="/etc/byedpictl"
BIN="/usr/local/bin"

C_RESET="\e[0m"
C_BOLD="\e[1m"
C_GREEN="\e[0;32m"
C_RED="\e[0;31m"


cmd_help () {
    cat <<EOF
$0

COMMANDS:
    install
        Deploy the project files and dependencies.
    remove
        Uninstall the project.
    help
        Show this message and exit.
EOF
}

cmd_install () {
    tmp_dir=$( mktemp -d )
    if [[ ! -d $tmp_dir ]]; then
        printf "${C_RED}Failed to initialize temporary directory.${C_RESET}\n"
        exit 1
    fi
    trap 'rm -rf -- "$tmp_dir"' EXIT

    printf "${C_BOLD}Setting up${C_RESET}\n"
    target_arch=$( uname -m )
    mkdir -p "$CONF"
    id -u byedpi &>/dev/null || useradd -r -s /bin/false byedpi

    printf "${C_BOLD}- Downloading and preparing the dependencies${C_RESET}\n"
    printf -- "- Server\n"
    curl -L --progress-bar -o "$tmp_dir/ciadpi.tar.gz" \
        "https://github.com/hufrea/byedpi/releases/download/v0.17.3/byedpi-17.3-$target_arch.tar.gz"
    cd "$tmp_dir"
    tar -zxf "ciadpi.tar.gz"
    find -type f -name "ciadpi-*" -exec mv -f {} $BIN/ciadpi \;
    cd "$OLDPWD"
    chmod +x "$BIN/ciadpi"

    printf -- "- Tunnel\n"
    curl -L --progress-bar -o "$BIN/hev-socks5-tunnel" \
        "https://github.com/heiher/hev-socks5-tunnel/releases/download/2.13.0/hev-socks5-tunnel-linux-$target_arch"
    chmod +x "$BIN/hev-socks5-tunnel"

    printf "${C_BOLD}- Installing the main components${C_RESET}\n"
    cp "$SRC_BIN/byedpictl.sh" "$BIN/byedpictl"
    cp -r "$SRC_CONF"/* "$CONF"

    # Profilleri sistem dizinine kopyala
    printf "${C_BOLD}- Installing profiles${C_RESET}\n"
    if [[ -d "profiles" ]]; then
        mkdir -p "$CONF/profiles"
        cp profiles/*.conf "$CONF/profiles/"
        echo "Profiller $CONF/profiles/ dizinine kopyalandı"
    else
        echo "UYARI: profiles klasörü bulunamadı"
    fi

    printf "${C_BOLD}- Installing the desktop integration${C_RESET}\n"
    xdg-desktop-menu install --novendor "$SRC_XDG/byedpictl.desktop"
    xdg-icon-resource install --novendor --size 128 "$SRC_ICON/128/byedpictl.png"

    printf "${C_GREEN}Installation complete${C_RESET}\n"
    cat <<EOF

Get basic usage information by executing
  $ byedpictl help

DPI desync parameters can be changed here
  $CONF/desync.conf

Profiles are available at
  $CONF/profiles/
EOF
}

cmd_remove () {
    printf "${C_BOLD}Removal${C_RESET} "
    rm -rf "$CONF"
    rm -f "$BIN/byedpictl"
    rm -f "$BIN/ciadpi"
    rm -f "$BIN/hev-socks5-tunnel"
    id -u byedpi &>/dev/null && userdel byedpi
    xdg-desktop-menu uninstall "$SRC_XDG/byedpictl.desktop"
    xdg-icon-resource uninstall --size 128 "$SRC_ICON/128/byedpictl.png"

    printf "${C_GREEN}Done${C_RESET}\n"
}


[[ $( id -u ) != 0 ]] && \
    printf "${C_RED}Superuser required!${C_RESET}\n" && exit 1

case $1 in
    help)
        cmd_help
        ;;
    install)
        cmd_install
        ;;
    remove)
        cmd_remove
        ;;
    *)
        printf "${C_RED}Invalid argument${C_RESET} $1\n"
        printf "Use ${C_BOLD}help${C_RESET} command\n"
        exit 1
esac
