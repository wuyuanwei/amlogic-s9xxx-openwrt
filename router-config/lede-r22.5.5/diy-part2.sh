#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt for Amlogic s9xxx tv box
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/coolsnowwolf/lede / Branch: master
#========================================================================================================================

# ------------------------------- Main source started -------------------------------
#
# Modify default theme（FROM uci-theme-bootstrap CHANGE TO luci-theme-material）
# sed -i 's/luci-theme-bootstrap/luci-theme-material/g' ./feeds/luci/collections/luci/Makefile

# Add autocore support for armvirt
sed -i 's/TARGET_rockchip/TARGET_rockchip\|\|TARGET_armvirt/g' package/lean/autocore/Makefile

# Set etc/openwrt_release
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R22.5.5'|g" package/lean/default-settings/files/zzz-default-settings
echo "DISTRIB_SOURCECODE='lede'" >>package/base-files/files/etc/openwrt_release

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.31.4）
# sed -i 's/192.168.1.1/192.168.31.4/g' package/base-files/files/bin/config_generate

# Modify default root's password（FROM 'password'[$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.] CHANGE TO 'your password'）
# sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' /etc/shadow

# Replace the default software source
# sed -i 's#openwrt.proxy.ustclug.org#mirrors.bfsu.edu.cn\\/openwrt#' package/lean/default-settings/files/zzz-default-settings
#
# ------------------------------- Main source ends -------------------------------

# ------------------------------- Other started -------------------------------
#
# Add luci-app-amlogic
# svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic

# Fix runc version error
# rm -rf ./feeds/packages/utils/runc/Makefile
# svn export https://github.com/openwrt/packages/trunk/utils/runc/Makefile ./feeds/packages/utils/runc/Makefile

# coolsnowwolf default software package replaced with Lienol related software package
# rm -rf feeds/packages/utils/{containerd,libnetwork,runc,tini}
# svn co https://github.com/Lienol/openwrt-packages/trunk/utils/{containerd,libnetwork,runc,tini} feeds/packages/utils

# Add third-party software packages (The entire repository)
# git clone https://github.com/libremesh/lime-packages.git package/lime-packages
# Add third-party software packages (Specify the package)
# svn co https://github.com/libremesh/lime-packages/trunk/packages/{shared-state-pirania,pirania-app,pirania} package/lime-packages/packages
# Add to compile options (Add related dependencies according to the requirements of the third-party software package Makefile)
# sed -i "/DEFAULT_PACKAGES/ s/$/ pirania-app pirania ip6tables-mod-nat ipset shared-state-pirania uhttpd-mod-lua/" target/linux/armvirt/Makefile

wget -q https://github.com/coolsnowwolf/packages/archive/77a3bd982aff20721cfd09faee0dd7b7daec8985.zip -P tmp/
unzip -q tmp/77a3bd982aff20721cfd09faee0dd7b7daec8985.zip -d tmp/
mv tmp/packages-77a3bd982aff20721cfd09faee0dd7b7daec8985/net/redsocks2 feeds/helloworld/
rm -rf tmp/*77a3bd982aff20721cfd09faee0dd7b7daec8985*

wget -q https://github.com/ophub/luci-app-amlogic/archive/0db575e9a3718aec86f9c0ccef2df6eeb096f60d.zip -P tmp/
unzip -q tmp/0db575e9a3718aec86f9c0ccef2df6eeb096f60d.zip -d tmp/
mv tmp/luci-app-amlogic-0db575e9a3718aec86f9c0ccef2df6eeb096f60d/luci-app-amlogic feeds/luci/applications/
rm -rf tmp/*0db575e9a3718aec86f9c0ccef2df6eeb096f60d*

wget -q https://github.com/vernesong/OpenClash/archive/6b111db23ef5f967c7962d5f8ae8d9a7255506c6.zip -P tmp/
unzip -q tmp/6b111db23ef5f967c7962d5f8ae8d9a7255506c6.zip -d tmp/
mv tmp/OpenClash-6b111db23ef5f967c7962d5f8ae8d9a7255506c6/luci-app-openclash feeds/luci/applications/
rm -rf tmp/*6b111db23ef5f967c7962d5f8ae8d9a7255506c6*

cp -r feeds/passwall/luci-app-passwall feeds/luci/applications/
cp -r feeds/helloworld/luci-app-ssr-plus feeds/luci/applications/

scripts/feeds update -a
scripts/feeds install -a

# Apply patch
# git apply ../router-config/patches/{0001*,0002*}.patch --directory=feeds/luci
#
# ------------------------------- Other ends -------------------------------

