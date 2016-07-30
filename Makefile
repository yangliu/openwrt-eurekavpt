#
# Copyright (C) 2016 openwrt-eurekavpt
# Copyright (C) 2015 Yang <i@yangliu.name>
#
# This is free software, licensed under the MIT License.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-eurekavpt
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-eurekavpt
  SECTION:=LuCI
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=EurekaVPT
  DEPENDS:=+luci +dns2socks +haproxy +redsocks +libopenssl +libpthread +dnsmasq-full +ipset +iptables +kmod-ipt-ipset +wget +ca-certificates +curl +coreutils-base64
  PKGARCH:=all
  MAINTAINER:=Yang Liu
endef

define Package/luci-app-eurekavpt/description
EurekaVPT is an elegant way to bypass China GFW.
endef

define Build/Compile
endef


define Package/luci-app-eurekavpt/install
	$(CP) ./files/* $(1)
endef

$(eval $(call BuildPackage,luci-app-eurekavpt))