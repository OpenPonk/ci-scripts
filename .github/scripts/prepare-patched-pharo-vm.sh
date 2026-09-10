#!/bin/bash
set -euxo pipefail

PHARO_VER="${PHARO_VERSION:-14}"
ZEROCONF_VER="${PHARO_VER}0"
CAIRO_NAME="cairo-1.18.4"
CAIRO_TAG="$CAIRO_NAME"
VM_TARGET_DIR="${1:-${RUNNER_TEMP:-$HOME}/pharo-vm}"

mkdir -p "$VM_TARGET_DIR"
cd "$VM_TARGET_DIR"

# 1. Download the base Pharo VM from original zeroconf source
echo "Downloading base Pharo ${PHARO_VER} VM via zeroconf..."
curl -sSL "https://get.pharo.org/64/vm${ZEROCONF_VER}" | bash

# 2. Download and extract platform-specific Cairo assets
case "$(uname -s)" in
    Linux*)
        CAIRO_ZIP="${CAIRO_NAME}-linux.zip"
        ASSET_URL="https://github.com/OpenPonk/ci-scripts/releases/download/${CAIRO_TAG}/${CAIRO_ZIP}"
        echo "Downloading patched Cairo libraries for Linux..."
        curl -sSL -O "${ASSET_URL}"

        mkdir -p cairo-extract
        unzip -q -o "${CAIRO_ZIP}" -d cairo-extract

        mkdir -p "$VM_TARGET_DIR/pharo-vm/lib"
        if [ -d "cairo-extract/lib" ]; then
            cp -rf cairo-extract/lib/* "$VM_TARGET_DIR/pharo-vm/lib/"
        else
            cp -rf cairo-extract/* "$VM_TARGET_DIR/pharo-vm/lib/"
        fi
        rm -rf cairo-extract "${CAIRO_ZIP}"
        ;;

    CYGWIN*|MINGW*|MSYS*)
        CAIRO_ZIP="${CAIRO_NAME}-win.zip"
        ASSET_URL="https://github.com/OpenPonk/ci-scripts/releases/download/${CAIRO_TAG}/${CAIRO_ZIP}"
        echo "Downloading patched Cairo libraries for Windows..."
        curl -sSL -O "${ASSET_URL}"

        mkdir -p cairo-extract
        unzip -q -o "${CAIRO_ZIP}" -d cairo-extract

        mkdir -p "$VM_TARGET_DIR/pharo-vm"
        cp -rf cairo-extract/* "$VM_TARGET_DIR/pharo-vm/"
        rm -rf cairo-extract "${CAIRO_ZIP}"
        ;;

    Darwin*)
        echo "macOS does not require a patched Cairo library."
        exit 0
        ;;

    *)
        echo "Unsupported OS platform: $(uname -s)" >&2
        exit 1
        ;;
esac