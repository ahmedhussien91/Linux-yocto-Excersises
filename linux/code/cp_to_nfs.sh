#!/bin/bash

# Script to copy Linux build outputs to TFTP and NFS directories
# Usage: ./cp_to_nfs.sh <target1> [target2] [target3]
# Supported targets: bb, rpi4, qemu

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display usage
usage() {
    echo -e "${YELLOW}Usage: $0 <target1> [target2] [target3]${NC}"
    echo -e "${YELLOW}Supported targets: bb, rpi4, qemu${NC}"
    echo -e "${YELLOW}Example: $0 bb rpi4${NC}"
    exit 1
}

# Check if at least one argument is provided
if [ $# -eq 0 ]; then
    echo -e "${RED}Error: No target specified${NC}"
    usage
fi

# Function to check if directory exists and create if needed
check_and_create_dir() {
    local dir=$1
    if [ ! -d "$dir" ]; then
        echo -e "${YELLOW}Creating directory: $dir${NC}"
        sudo mkdir -p "$dir"
    fi
}

# Function to get target-specific paths and settings
get_target_config() {
    local target=$1
    
    case $target in
        bb)
            KERNEL_IMAGE="zImage"
            DTB_PATTERN="am335x-boneblack.dtb"
            TFTP_KERNEL_NAME="zImage_native_bb"
            NFS_DIR="/srv/nfs4/bb_busybox"
            TARGET_DIR="bb"
            TOOLCHAIN_PREFIX="arm-cortex_a8-linux-gnueabihf"
            ;;
        rpi4)
            KERNEL_IMAGE="zImage"
            DTB_PATTERN="bcm2711-rpi-4-b.dtb"
            TFTP_KERNEL_NAME="zImage_native_rpi4"
            NFS_DIR="/srv/nfs4/rpi4_busybox"
            TARGET_DIR="rpi4"
            TOOLCHAIN_PREFIX="aarch64-rpi4-linux-gnu"
            ;;
        qemu)
            KERNEL_IMAGE="zImage"
            DTB_PATTERN="*vexpress*.dtb"
            TFTP_KERNEL_NAME="zImage_native_qemu"
            NFS_DIR="/srv/nfs4/qemu_busybox"
            TARGET_DIR="qemu"
            TOOLCHAIN_PREFIX="arm-unknown-linux-gnueabi"
            ;;
        *)
            echo -e "${RED}Error: Unsupported target '$target'${NC}"
            echo -e "${YELLOW}Supported targets: bb, rpi4, qemu${NC}"
            return 1
            ;;
    esac
}

# Function to copy sysroot to NFS
copy_sysroot() {
    local target=$1
    
    # Find sysroot directory in the crosstool-ng build
    SYSROOT_PATH="${HOME}/x-tools/${TOOLCHAIN_PREFIX}/${TOOLCHAIN_PREFIX}/sysroot"
    
    if [ -d "$SYSROOT_PATH" ]; then
        echo -e "${GREEN}Copying sysroot from $SYSROOT_PATH to $NFS_DIR${NC}"
        
        # Copy sysroot contents to NFS directory
        sudo cp -r "$SYSROOT_PATH"/* "$NFS_DIR/"
        
        # Ensure proper directory structure exists
        sudo mkdir -p "$NFS_DIR"/{dev,proc,sys,tmp,var,run}
        
    else
        echo -e "${YELLOW}Warning: Sysroot not found at $SYSROOT_PATH${NC}"
        echo -e "${YELLOW}Skipping sysroot copy for $target${NC}"
    fi
}

# Function to process a single target
process_target() {
    local target=$1
    
    echo -e "${BLUE}Processing target: $target${NC}"
    
    # Get target configuration
    if ! get_target_config "$target"; then
        return 1
    fi
    
    # Define source paths based on target directory structure
    KERNEL_BUILD_DIR="${TARGET_DIR}/linux/arch/arm/boot"
    DTB_BUILD_DIR="${TARGET_DIR}/linux/arch/arm/boot/dts"
    BUSYBOX_BUILD_DIR="${TARGET_DIR}/busybox/_install"
    TFTP_DIR="/srv/tftp"
    
    # Check if target directory exists
    if [ ! -d "${TARGET_DIR}" ]; then
        echo -e "${RED}Error: Target directory '${TARGET_DIR}' not found${NC}"
        return 1
    fi
    
    # Check and create destination directories
    check_and_create_dir "$TFTP_DIR"
    check_and_create_dir "$NFS_DIR"
    
    # Copy kernel image to TFTP
    if [ -f "$KERNEL_BUILD_DIR/$KERNEL_IMAGE" ]; then
        echo -e "${GREEN}Copying $KERNEL_IMAGE to $TFTP_DIR/$TFTP_KERNEL_NAME${NC}"
        sudo cp "$KERNEL_BUILD_DIR/$KERNEL_IMAGE" "$TFTP_DIR/$TFTP_KERNEL_NAME"
    else
        echo -e "${RED}Error: $KERNEL_IMAGE not found in $KERNEL_BUILD_DIR${NC}"
        return 1
    fi
    
    # Copy device tree blob to TFTP
    DTB_FILES=$(find "$DTB_BUILD_DIR" -name "$DTB_PATTERN" 2>/dev/null || true)
    if [ -n "$DTB_FILES" ]; then
        for dtb in $DTB_FILES; do
            dtb_name=$(basename "$dtb")
            target_dtb_name="${target}_${dtb_name}"
            echo -e "${GREEN}Copying $dtb_name to $TFTP_DIR/$target_dtb_name${NC}"
            sudo cp "$dtb" "$TFTP_DIR/$target_dtb_name"
        done
    else
        echo -e "${YELLOW}Warning: No DTB files found matching pattern '$DTB_PATTERN' in $DTB_BUILD_DIR${NC}"
    fi
    
    # Clear existing NFS directory first
    echo -e "${GREEN}Clearing existing NFS directory: $NFS_DIR${NC}"
    sudo rm -rf "$NFS_DIR"/*
    
    # Copy sysroot first (base filesystem)
    copy_sysroot "$target"
    
    # Copy BusyBox filesystem (overlay on top of sysroot)
    if [ -d "$BUSYBOX_BUILD_DIR" ]; then
        echo -e "${GREEN}Copying BusyBox filesystem to $NFS_DIR${NC}"
        sudo cp -r "$BUSYBOX_BUILD_DIR"/* "$NFS_DIR/"
    else
        echo -e "${YELLOW}Warning: BusyBox install directory not found: $BUSYBOX_BUILD_DIR${NC}"
        echo -e "${YELLOW}Continuing with sysroot only...${NC}"
    fi
    
    # Set proper permissions for NFS
    echo -e "${GREEN}Setting NFS permissions for $target...${NC}"
    sudo chown -R nobody:nogroup "$NFS_DIR"
    sudo chmod -R 755 "$NFS_DIR"
    
    # Fix some common directory permissions
    sudo chmod 1777 "$NFS_DIR/tmp" 2>/dev/null || true
    sudo chmod 755 "$NFS_DIR/var" 2>/dev/null || true
    
    echo -e "${GREEN}Target $target processed successfully!${NC}"
    echo ""
}

# Main execution
echo -e "${YELLOW}Starting copy process for targets: $@${NC}"
echo ""

# Process each target
for target in "$@"; do
    if ! process_target "$target"; then
        echo -e "${RED}Failed to process target: $target${NC}"
        exit 1
    fi
done

# Display summary
echo -e "${GREEN}All targets processed successfully!${NC}"
echo -e "${YELLOW}Files in TFTP directory:${NC}"
ls -la /srv/tftp/

echo -e "${YELLOW}NFS directories created:${NC}"
for target in "$@"; do
    get_target_config "$target"
    if [ -d "$NFS_DIR" ]; then
        echo -e "${GREEN}$NFS_DIR${NC}"
        echo "Total size: $(du -sh "$NFS_DIR" | cut -f1)"
        ls -la "$NFS_DIR/" | head -5
        echo "..."
        echo ""
    fi
done

echo -e "${GREEN}Done!${NC}"