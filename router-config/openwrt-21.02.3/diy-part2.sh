#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt for Amlogic s9xxx tv box
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/openwrt/openwrt / Branch: 21.02
#========================================================================================================================

# ------------------------------- Main source started -------------------------------
#
# Modify default theme（FROM uci-theme-bootstrap CHANGE TO luci-theme-material）
# sed -i 's/luci-theme-bootstrap/luci-theme-material/g' feeds/luci/collections/luci/Makefile

# Add the default password for the 'root' user（Change the empty password to 'password'）
# sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' package/base-files/files/etc/shadow

# Set etc/openwrt_release
# sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/base-files/files/etc/openwrt_release
# echo "DISTRIB_SOURCECODE='openwrt.21.02'" >>package/base-files/files/etc/openwrt_release

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.31.4）
# sed -i 's/192.168.1.1/192.168.31.4/g' package/base-files/files/bin/config_generate

#
# ------------------------------- Main source ends -------------------------------

# ------------------------------- Other started -------------------------------
#
# Add luci-app-amlogic
# svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic

# coolsnowwolf default software package replaced with Lienol related software package
# rm -rf feeds/packages/utils/{containerd,libnetwork,runc,tini}
# svn co https://github.com/Lienol/openwrt-packages/trunk/utils/{containerd,libnetwork,runc,tini} feeds/packages/utils

wget -q https://github.com/coolsnowwolf/packages/archive/77a3bd982aff20721cfd09faee0dd7b7daec8985.zip -P tmp/
wget -q https://github.com/coolsnowwolf/luci/archive/2a5da72bb4df112abf4e42f249b7c732263d82fd.zip -P tmp/
unzip -q tmp/77a3bd982aff20721cfd09faee0dd7b7daec8985.zip -d tmp/
unzip -q tmp/2a5da72bb4df112abf4e42f249b7c732263d82fd.zip -d tmp/
mv tmp/packages-77a3bd982aff20721cfd09faee0dd7b7daec8985/net/redsocks2 feeds/helloworld/
mv tmp/packages-77a3bd982aff20721cfd09faee0dd7b7daec8985/net/vlmcsd feeds/packages/net/
mv tmp/luci-2a5da72bb4df112abf4e42f249b7c732263d82fd/libs/luci-lib-fs feeds/luci/libs/
mv tmp/luci-2a5da72bb4df112abf4e42f249b7c732263d82fd/applications/{luci-app-arpbind,luci-app-autoreboot,luci-app-diskman,luci-app-filetransfer,luci-app-openvpn-server,luci-app-vlmcsd,luci-app-webadmin} feeds/luci/applications/
rm -rf tmp/{*77a3bd982aff20721cfd09faee0dd7b7daec8985*,*2a5da72bb4df112abf4e42f249b7c732263d82fd*}

wget -q https://github.com/ophub/luci-app-amlogic/archive/0db575e9a3718aec86f9c0ccef2df6eeb096f60d.zip -P tmp/
unzip -q tmp/0db575e9a3718aec86f9c0ccef2df6eeb096f60d.zip -d tmp/
mv tmp/luci-app-amlogic-0db575e9a3718aec86f9c0ccef2df6eeb096f60d/luci-app-amlogic feeds/luci/applications/
rm -rf tmp/*0db575e9a3718aec86f9c0ccef2df6eeb096f60d*

wget -q https://github.com/vernesong/OpenClash/archive/6277c212650f8110e854a3ed9a9e4bde09cf6935.zip -P tmp/
unzip -q tmp/6277c212650f8110e854a3ed9a9e4bde09cf6935.zip -d tmp/
mv tmp/OpenClash-6277c212650f8110e854a3ed9a9e4bde09cf6935/luci-app-openclash feeds/luci/applications/
rm -rf tmp/*6277c212650f8110e854a3ed9a9e4bde09cf6935*

cp -r feeds/passwall/luci-app-passwall feeds/luci/applications/
cp -r feeds/helloworld/luci-app-ssr-plus feeds/luci/applications/

scripts/feeds update -a
scripts/feeds install -a

# Add third-party software packages (The entire repository)
# git clone https://github.com/libremesh/lime-packages.git package/lime-packages
# Add third-party software packages (Specify the package)
# svn co https://github.com/libremesh/lime-packages/trunk/packages/{shared-state-pirania,pirania-app,pirania} package/lime-packages/packages
# Add to compile options (Add related dependencies according to the requirements of the third-party software package Makefile)
# sed -i "/DEFAULT_PACKAGES/ s/$/ pirania-app pirania ip6tables-mod-nat ipset shared-state-pirania uhttpd-mod-lua/" target/linux/armvirt/Makefile

# Apply patch
# git apply ../router-config/patches/{0001*,0002*}.patch --directory=feeds/luci
#
# ------------------------------- Other ends -------------------------------
