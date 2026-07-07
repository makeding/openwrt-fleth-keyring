include $(TOPDIR)/rules.mk

PKG_NAME:=openwrt-fleth-keyring
PKG_RELEASE:=1

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
else
define Package/openwrt-fleth-keyring/install
	$(INSTALL_DIR) $(1)/etc/opkg/keys/
	$(INSTALL_DATA) ./usign/064499bbef2b4ee5 $(1)/etc/opkg/keys/
endef
endif

$(eval $(call BuildPackage,openwrt-fleth-keyring))
