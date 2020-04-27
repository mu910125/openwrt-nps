#
# Copyright (C) 2019-2020 
# Copyright (C) 2019-2020 
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=openwrt-nps
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/ehang-io/nps
PKG_SOURCE_VERSION:=c9b755360c3b3513e53bb265ae49703f06d6f34f
PKG_SOURCE:=$(PKG_NAME)-$(PKG_SOURCE_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_SOURCE_VERSION)
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_SOURCE_VERSION)

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=mujw <mujw@gmail.com>

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

GO_PKG:=github.com/ehang-io/nps
GO_PKG_LDFLAGS:=-s -w

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/$(PKG_NAME)
	TITLE:=A platform for building proxies
	SECTION:=net
	CATEGORY:=Network
	DEPENDS:=$(GO_ARCH_DEPENDS) +ca-certificates
endef

define Package/$(PKG_NAME)/config
	source "$(SOURCE)/Config.in"
endef

define Package/$(PKG_NAME)/description
	nps is a fast reverse proxy to help you expose a local server behind a NAT or firewall to the internet
endef

define Build/Prepare
	$(call Build/Prepare/Default)
	mkdir -p $(PKG_BUILD_DIR)/cmd/sdk
	mv $(PKG_BUILD_DIR)/cmd/npc/sdk.go $(PKG_BUILD_DIR)/cmd/sdk/sdk.go
endef

define Build/Compile
	$(if $(CONFIG_NPS), \
		$(eval GO_PKG_BUILD_PKG:=github.com/ehang-io/nps/cmd/nps) \
		$(call GoPackage/Build/Compile); \
		$(STAGING_DIR_HOST)/bin/upx --lzma --best $(GO_PKG_BUILD_BIN_DIR)/nps)

	 $(if $(CONFIG_NPC), \
		 $(eval GO_PKG_BUILD_PKG:=github.com/ehang-io/nps/cmd/npc) \
		 $(call GoPackage/Build/Compile); \
		 $(STAGING_DIR_HOST)/bin/upx --lzma --best $(GO_PKG_BUILD_BIN_DIR)/npc)
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin/
ifneq ($(CONFIG_NPS), )
	$(INSTALL_BIN) $(GO_PKG_BUILD_BIN_DIR)/nps $(1)/usr/bin/
endif

ifneq ($(CONFIG_NPC), )
	$(INSTALL_BIN) $(GO_PKG_BUILD_BIN_DIR)/npc $(1)/usr/bin/
endif

endef

$(eval $(call GoBinPackage,$(PKG_NAME)))
$(eval $(call BuildPackage,$(PKG_NAME)))
