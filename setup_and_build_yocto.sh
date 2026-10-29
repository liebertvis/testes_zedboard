#!/usr/bin/env bash
# ==============================================================================
# setup_and_build_yocto.sh
# Automates Yocto (Scarthgap / Xilinx rel-v2024.2) workspace setup and build
# for Digilent ZedBoard (Zynq-7000) with custom .xsa and C application.
# ==============================================================================

set -e

YOCTO_DIR="$HOME/yocto_zedboard"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CUSTOM_LAYER_SRC="$SCRIPT_DIR/meta-zedboard-custom"

echo "=== [1/5] Creating Yocto Workspace at $YOCTO_DIR ==="
mkdir -p "$YOCTO_DIR/sources"
cd "$YOCTO_DIR/sources"

# Clone standard Yocto & Xilinx repositories (2024.2 correlates to Yocto 'scarthgap')
if [ ! -d "poky" ]; then
    git clone -b scarthgap https://git.yoctoproject.org/poky.git
fi

if [ ! -d "meta-openembedded" ]; then
    git clone -b scarthgap https://git.openembedded.org/meta-openembedded
fi

if [ ! -d "meta-xilinx" ]; then
    git clone -b rel-v2024.2 https://github.com/Xilinx/meta-xilinx.git
fi

if [ ! -d "meta-xilinx-tools" ]; then
    git clone -b rel-v2024.2 https://github.com/Xilinx/meta-xilinx-tools.git
fi

echo "=== [2/5] Copying meta-zedboard-custom into sources/ ==="
rm -rf "$YOCTO_DIR/sources/meta-zedboard-custom"
cp -r "$CUSTOM_LAYER_SRC" "$YOCTO_DIR/sources/meta-zedboard-custom"

echo "=== [3/5] Initializing BitBake Build Environment ==="
cd "$YOCTO_DIR"
source sources/poky/oe-init-build-env build

echo "=== [4/5] Adding Layers to conf/bblayers.conf ==="
bitbake-layers add-layer "$YOCTO_DIR/sources/meta-openembedded/meta-oe"
bitbake-layers add-layer "$YOCTO_DIR/sources/meta-openembedded/meta-python"
bitbake-layers add-layer "$YOCTO_DIR/sources/meta-xilinx/meta-xilinx-core"
bitbake-layers add-layer "$YOCTO_DIR/sources/meta-xilinx/meta-xilinx-bsp"
bitbake-layers add-layer "$YOCTO_DIR/sources/meta-xilinx/meta-xilinx-standalone"
bitbake-layers add-layer "$YOCTO_DIR/sources/meta-xilinx-tools"
bitbake-layers add-layer "$YOCTO_DIR/sources/meta-zedboard-custom"

echo "=== [5/5] Configuring conf/local.conf for ZedBoard ==="
if ! grep -q "zedboard-zynq7" conf/local.conf; then
    cat << 'EOF' >> conf/local.conf

# --- ZedBoard Custom Configuration ---
MACHINE = "zedboard-zynq7"

# Enable /dev/mem access from userspace for our led_blink C program
EXTRA_IMAGE_FEATURES:append = " debug-tweaks tools-debug"
EOF
fi

echo "======================================================================"
echo "Setup complete! Starting BitBake build for core-image-minimal..."
echo "======================================================================"
bitbake core-image-minimal

