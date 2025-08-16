#!/bin/bash

# Exit immediately on error
set -e

# Step 1: Clean local manifests
rm -rf .repo/local_manifests/
echo "==========================="
echo " Local manifests cleaned ✅"
echo "==========================="

# Step 2: Initialize repo
repo init -u https://github.com/Lunaris-AOSP/android -b 16 --git-lfs
echo "=================="
echo " Repo init success ✅"
echo "=================="

# Step 3: Clone device/kernel/vendor/hardware repos
echo "=========================="
echo " Cloning device tree... "
echo "=========================="
git clone --depth=1 -b lunaris https://github.com/MaheshTechnicals/device_xiaomi_miatoll-16 device/xiaomi/miatoll

echo "=========================="
echo " Cloning kernel tree... "
echo "=========================="
git clone --depth=1 -b clover-16 https://github.com/MaheshTechnicals/kernel_xiaomi_sm6250-16 kernel/xiaomi/sm6250

echo "=========================="
echo " Cloning vendor tree... "
echo "=========================="
git clone --depth=1 -b clover-16 https://github.com/MaheshTechnicals/vendor_xiaomi_miatoll-16 vendor/xiaomi/miatoll

echo "=========================="
echo " Cloning Sony timekeep... "
echo "=========================="
rm -rf hardware/sony/timekeep
git clone --depth=1 -b lineage-22.2 https://github.com/LineageOS/android_hardware_sony_timekeep hardware/sony/timekeep

echo "=========================="
echo " Cloning Xiaomi hardware... "
echo "=========================="
rm -rf hardware/xiaomi
git clone --depth=1 -b lineage-22.2 https://github.com/LineageOS/android_hardware_xiaomi hardware/xiaomi

echo "=========================="
echo " Cloning lineage priv keys... "
echo "=========================="
git clone --depth=1 -b alpha https://github.com/MaheshTechnicals/vendor_lineage-priv vendor/lineage-priv/keys

echo "======================================="
echo " ✅ All repositories cloned successfully"
echo "======================================="

# Step 4: Sync remaining sources
/opt/crave/resync.sh
echo "============="
echo " Repo sync success ✅"
echo "============="

# Step 5: Export build info
export BUILD_USERNAME=mahesh
export BUILD_HOSTNAME=crave
echo "======================"
echo " Export vars done ✅"
echo "======================"

# Step 6: Setup build environment
source build/envsetup.sh
echo "====================="
echo " Envsetup success ✅"
echo "====================="

# Step 7: Lunch target
lunch lineage_miatoll-bp2a-user
echo "====================="
echo " Lunch target set ✅"
echo "====================="

# Step 8: Clean intermediates
make installclean
echo "====================="
echo " Installclean done ✅"
echo "====================="

# Step 9: Start build
m lunaris
echo "====================="
echo " Build started 🚀"
echo "====================="

