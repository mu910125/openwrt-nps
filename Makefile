#
# Copyright (C) 2015-2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v3.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=nps
PKG_VERSION:=0.26.2
PKG_RELEASE:=1

PKG_HASH:=skip
ifeq ($(ARCH),mipsel)
	NPC_ARCH:=mipsle
endif
ifeq ($(ARCH),mips)
	NPC_ARCH:=mips
	PKG_HASH:=4db5b987bf40ca66fd4ef5f93778fc734034289a61478d6efc44acc1fcb2cf67
endif
ifeq ($(ARCH),i386)
	NPC_ARCH:=386
endif
ifeq ($(ARCH),x86_64)
	NPC_ARCH:=amd64
	PKG_HASH:=5dd43e3c3522e8dfa5c95cd9d8209a12a22cd30ee3606e07b596bb6a1fc65dca
endif
ifeq ($(ARCH),arm)
	NPC_ARCH:=arm_v7
	PKG_HASH:=7c4f021f39678a8e4d7355bffe392963b34ac17eb515e4bf55fa43f8f5e4a729
endif
ifeq ($(ARCH),aarch64)
	NPC_ARCH:=arm64
endif

PKG_LICENSE:=Apache-2.0

PKG_SOURCE_URL:=https://github.com/cnlh/nps/releases/download/v$(PKG_VERSION)
PKG_SOURCE:=linux_$(NPC_ARCH)_server.tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/nps

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=net
	CATEGORY:=Network
	TITLE:=NPS Server
	DEPENDS:=
	URL:=https://github.com/cnlh/nps/releases
endef



define Package/$(PKG_NAME)/description
npc is a fast reverse proxy to help you expose a local server behind a NAT or firewall to the internet
endef


UNPACK_CMD=tar -zxvf "$(DL_DIR)/$(PKG_SOURCE)" -C $(PKG_BUILD_DIR)
define Build/Prepare
	$(PKG_UNPACK)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_DIR) $(1)/etc/nps/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/nps $(1)/usr/bin/
	$(CP) $(PKG_BUILD_DIR)/web $(1)/etc/nps/
	$(CP) $(PKG_BUILD_DIR)/conf $(1)/etc/nps/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
