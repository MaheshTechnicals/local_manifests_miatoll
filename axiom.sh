#!/bin/bash
#
# AxionOS Build Script for Miatoll (sm6250)
# Author: Mahesh
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
# Step 3: Sync sources
# ===============================
/opt/crave/resync.sh
echo "Repo sync success ✅"

# ===============================
# Step 4: Clone device/kernel/vendor/hardware repos
# ===============================
echo "Cloning device/kernel/vendor/hardware repos..."

rm -rf device/xiaomi/miatoll
git clone --depth=1 -b axion-15 https://github.com/MaheshTechnicals/android_device_xiaomi_miatoll-15.git device/xiaomi/miatoll

rm -rf device/xiaomi/sm6250-common
git clone --depth=1 -b axion-15 https://github.com/MaheshTechnicals/android_device_xiaomi_sm6250-common-15.git device/xiaomi/sm6250-common

rm -rf kernel/xiaomi/sm6250
git clone --depth=1 -b lineage-22.2 https://github.com/MaheshTechnicals/android_kernel_xiaomi_sm6250-15.git kernel/xiaomi/sm6250

rm -rf vendor/xiaomi/miatoll
git clone --depth=1 -b lineage-22.2 https://github.com/MaheshTechnicals/proprietary_vendor_xiaomi_miatoll-15.git vendor/xiaomi/miatoll

rm -rf vendor/xiaomi/sm6250-common
git clone --depth=1 -b lineage-22.2 https://github.com/MaheshTechnicals/proprietary_vendor_xiaomi_sm6250-common-15.git vendor/xiaomi/sm6250-common

rm -rf vendor/lineage-priv/keys
git clone --depth=1 -b alpha https://github.com/MaheshTechnicals/vendor_lineage-priv vendor/lineage-priv/keys

rm -rf hardware/sony/timekeep
git clone --depth=1 -b lineage-22.2 https://github.com/LineageOS/android_hardware_sony_timekeep.git hardware/sony/timekeep

rm -rf hardware/xiaomi
git clone --depth=1 -b lineage-22.2 https://github.com/LineageOS/android_hardware_xiaomi.git hardware/xiaomi

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
# Step 7: Setup GApps build (Lunch target)
# ===============================
# Options:
#   va        → Vanilla (No GApps)
#   gms pico  → Minimal GApps
#   gms       → Full GApps (default)
#
echo "Setting up lunch target..."
axion miatoll gms
echo "Lunch target set to: miatoll (GMS build) ✅"

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

