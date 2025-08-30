#!/bin/bash
#
# AxionOS Build Script for Miatoll (sm6250)
# Updated by Mahesh
#

# Exit immediately on error
set -e

# ===============================
# Step 1: Clean local manifests
# ===============================
rm -rf .repo/local_manifests/
echo "Local manifests cleaned ✅"

# ===============================
# Step 2: Initialize AxionOS repo
# ===============================
repo init -u https://github.com/AxionAOSP/android.git -b lineage-22.2 --git-lfs
echo "Repo init success ✅"

# ===============================
# Step 2.5: Fix possible repo corruption
# ===============================
echo "Cleaning possible corrupted prebuilts..."
rm -rf .repo/projects/prebuilts/clang/host/linux-x86.git
rm -rf .repo/project-objects/android_prebuilts_clang_host_linux-x86.git
rm -rf prebuilts/clang/host/linux-x86
echo "✅ Prebuilts cleanup done"

# ===============================
# Step 3: Sync sources
# ===============================
/opt/crave/resync.sh
echo "Repo sync success ✅"

# ===============================
# Step 4: Clone device/kernel/vendor/hardware repos
# ===============================
echo "Cloning device/kernel/vendor/hardware repos..."

# Device trees
rm -rf device/xiaomi/miatoll
git clone --depth=1 -b axion https://github.com/MaheshTechnicals/device_xiaomi_miatoll-15.git device/xiaomi/miatoll

rm -rf device/xiaomi/sm6250-common
git clone --depth=1 -b 15 https://github.com/Infinity-X-Devices/device_xiaomi_sm6250-common.git device/xiaomi/sm6250-common

# Kernel
rm -rf kernel/xiaomi/sm6250
git clone --depth=1 -b lineage-22.2 https://github.com/LineageOS/android_kernel_xiaomi_sm6250.git kernel/xiaomi/sm6250

# Vendor trees
rm -rf vendor/xiaomi/miatoll
git clone --depth=1 -b 15 https://github.com/ihsanulrahman/vendor_xiaomi_miatoll.git vendor/xiaomi/miatoll

rm -rf vendor/xiaomi/sm6250-common
git clone --depth=1 -b 15 https://github.com/ihsanulrahman/vendor_xiaomi_sm6250-common.git vendor/xiaomi/sm6250-common

# MIUI Camera
rm -rf vendor/xiaomi/miuicamera
git clone --depth=1 -b 15 https://github.com/ihsanulrahman/vendor_xiaomi_miuicamera.git vendor/xiaomi/miuicamera

# Hardware
rm -rf hardware/sony/timekeep
git clone --depth=1 -b lineage-22.2 https://github.com/LineageOS/android_hardware_sony_timekeep.git hardware/sony/timekeep

rm -rf hardware/xiaomi
git clone --depth=1 -b 15 https://github.com/ihsanulrahman/hardware_xiaomi.git hardware/xiaomi

echo "✅ All repositories cloned successfully"

# ===============================
# Step 5: Export build info
# ===============================
export BUILD_USERNAME=mahesh
export BUILD_HOSTNAME=crave
echo "Export vars done ✅"

# ===============================
# Step 6: Setup build environment
# ===============================
. build/envsetup.sh
echo "Envsetup success ✅"

# ===============================
# Step 7: Setup Lunch target
# ===============================
# Options:
#   va        → Vanilla (No GApps)
#   gms pico  → Minimal GApps
#   gms       → Full GApps (default)
#
echo "Setting up lunch target..."
axion miatoll va
echo "Lunch target set to: miatoll (Vanilla build) ✅"

# ===============================
# Step 8: Clean intermediates
# ===============================
make installclean
echo "Installclean done ✅"

# ===============================
# Step 9: Start AxionOS Build
# ===============================
echo "Starting AxionOS build 🚀"
ax -br
echo "Build completed ✅"

