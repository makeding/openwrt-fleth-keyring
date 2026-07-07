include $(TOPDIR)/rules.mk

PKG_NAME:=openwrt-fleth-keyring
PKG_VERSION:=v1
PKG_RELEASE:=1
PKGARCH:=all

PKG_MAINTAINER:=huggy
PKG_LICENSE:=GPL-2.0-only

include $(INCLUDE_DIR)/package.mk

define Package/openwrt-fleth-keyring
  SECTION:=base
  CATEGORY:=Base system
  TITLE:=Flet'H Package Feed Keyring
  URL:=https://dl.fleth.link/
endef

define Package/openwrt-fleth-keyring/description
  Public keys for verifying packages from the Flet'H OpenWrt package feed.
endef

Build/Compile=

ifneq ($(CONFIG_USE_APK),)
define Package/openwrt-fleth-keyring/install
	$(INSTALL_DIR) $(1)/etc/apk/keys/
	$(INSTALL_DATA) ./apk/fleth.pem $(1)/etc/apk/keys/
endef

define Package/openwrt-fleth-keyring/postinst
#!/bin/sh
feed="https://dl.fleth.link/apk/all/packages.adb"
file="$${IPKG_INSTROOT}/etc/apk/repositories.d/customfeeds.list"
mkdir -p "$${file%/*}"
touch "$$file"
grep -qxF "$$feed" "$$file" || echo "$$feed" >> "$$file"
endef

define Package/openwrt-fleth-keyring/postrm
#!/bin/sh
file="$${IPKG_INSTROOT}/etc/apk/repositories.d/customfeeds.list"
[ -f "$$file" ] || exit 0
sed -i "\|^https://dl\.fleth\.link/apk/all/packages\.adb$$|d" "$$file"
endef
else
define Package/openwrt-fleth-keyring/install
	$(INSTALL_DIR) $(1)/etc/opkg/keys/
	$(INSTALL_DATA) ./usign/064499bbef2b4ee5 $(1)/etc/opkg/keys/
endef

define Package/openwrt-fleth-keyring/postinst
#!/bin/sh
feed="src/gz fleth https://dl.fleth.link/opkg/all"
file="$${IPKG_INSTROOT}/etc/opkg/customfeeds.conf"
mkdir -p "$${file%/*}"
touch "$$file"
grep -qxF "$$feed" "$$file" || echo "$$feed" >> "$$file"
endef

define Package/openwrt-fleth-keyring/postrm
#!/bin/sh
file="$${IPKG_INSTROOT}/etc/opkg/customfeeds.conf"
[ -f "$$file" ] || exit 0
sed -i "\|^src/gz fleth https://dl\.fleth\.link/opkg/all$$|d" "$$file"
endef
endif

$(eval $(call BuildPackage,openwrt-fleth-keyring))
