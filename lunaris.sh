#!/bin/bash

# Exit immediately on error
set -e

# ===============================
# Step 1: Clean local manifests
# ===============================
rm -rf .repo/local_manifests/
echo "==========================="
echo " Local manifests cleaned ✅"
echo "==========================="

# ===============================
# Step 2: Initialize AxionOS repo
# ===============================
repo init -u https://github.com/AxionAOSP/android.git -b lineage-22.2 --git-lfs
echo "=================="
echo " Repo init success ✅"
echo "=================="

# ===============================
# Step 3: Sync sources using your custom script
# ===============================
/opt/crave/resync.sh
echo "============="
echo " Repo sync success ✅"
echo "============="

# ===============================
# Step 4: Clone device/kernel/vendor/hardware repos
# ===============================

echo "=========================="
echo " Cloning device tree... "
echo "=========================="
rm -rf device/xiaomi/miatoll
git clone --depth=1 -b axion-15 https://github.com/MaheshTechnicals/android_device_xiaomi_miatoll-15.git device/xiaomi/miatoll

echo "=========================="
echo " Cloning sm6250-common device tree... "
echo "=========================="
rm -rf device/xiaomi/sm6250-common
git clone --depth=1 -b lineage-22.2 https://github.com/MaheshTechnicals/android_device_xiaomi_sm6250-common-15.git device/xiaomi/sm6250-common

echo "=========================="
echo " Cloning kernel tree... "
echo "=========================="
rm -rf kernel/xiaomi/sm6250
git clone --depth=1 -b lineage-22.2 https://github.com/MaheshTechnicals/android_kernel_xiaomi_sm6250-15.git kernel/xiaomi/sm6250

echo "=========================="
echo " Cloning vendor tree (miatoll)... "
echo "=========================="
rm -rf vendor/xiaomi/miatoll
git clone --depth=1 -b lineage-22.2 https://github.com/MaheshTechnicals/proprietary_vendor_xiaomi_miatoll-15.git vendor/xiaomi/miatoll

echo "=========================="
echo " Cloning vendor tree (sm6250-common)... "
echo "=========================="
rm -rf vendor/xiaomi/sm6250-common
git clone --depth=1 -b lineage-22.2 https://github.com/MaheshTechnicals/proprietary_vendor_xiaomi_sm6250-common-15.git vendor/xiaomi/sm6250-common

echo "=========================="
echo " Cloning LineageOS private keys... "
echo "=========================="
rm -rf vendor/lineage-priv/keys
git clone --depth=1 -b alpha https://github.com/MaheshTechnicals/vendor_lineage-priv vendor/lineage-priv/keys

echo "=========================="
echo " Cloning Sony timekeep... "
echo "=========================="
rm -rf hardware/sony/timekeep
git clone --depth=1 -b lineage-22.2 https://github.com/LineageOS/android_hardware_sony_timekeep.git hardware/sony/timekeep

echo "=========================="
echo " Cloning Xiaomi hardware... "
echo "=========================="
rm -rf hardware/xiaomi
git clone --depth=1 -b lineage-22.2 https://github.com/LineageOS/android_hardware_xiaomi.git hardware/xiaomi

echo "======================================="
echo " ✅ All repositories cloned successfully"
echo "======================================="

# ===============================
# Step 5: Export build info
# ===============================
export BUILD_USERNAME=mahesh
export BUILD_HOSTNAME=crave
echo "======================"
echo " Export vars done ✅"
echo "======================"

# ===============================
# Step 6: Setup build environment
# ===============================
source build/envsetup.sh
echo "====================="
echo " Envsetup success ✅"
echo "====================="

# ===============================
# Step 7: Lunch target
# ===============================
lunch axion_miatoll-userdebug
echo "====================="
echo " Lunch target set ✅"
echo "====================="

# ===============================
# Step 8: Clean intermediates
# ===============================
make installclean
echo "====================="
echo " Installclean done ✅"
echo "====================="

# ===============================
# Step 9: Start GApps build
# ===============================
axion miatoll gms pico
echo "====================="
echo " GApps build started 🚀"
echo "====================="
