include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-jmlicense
PKG_RELEASE:=0.0.1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

PO2LMO:=$(shell find $(TOPDIR)/build_dir/target-*/luci* -name po2lmo | awk '{if(match($$0,/build\/po2lmo/)) print $$0}')

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-jmlicense
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=jmtoo License Key 
  DEPENDS:=+luci
endef

define Package/luci-app-jmlicense/description
  License Key Save Application.
  Developer by bywayboy<bywayboy@qq.com>
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./luasrc $(PKG_BUILD_DIR)/
endef

define Build/Configure
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR)/luasrc
endef

define Package/luci-app-jmlicense/postinst
#!/bin/sh
[ -n "${IPKG_INSTROOT}" ] || {
	rm -f /tmp/luci-indexcache
	exit 0
}
endef

define Package/luci-app-jmlicense/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(CP) $(PKG_BUILD_DIR)/luasrc/controller/* $(1)/usr/lib/lua/luci/controller
	
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/admin_system
	$(CP) $(PKG_BUILD_DIR)/luasrc/view/admin_system/* $(1)/usr/lib/lua/luci/view/admin_system
	
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/admin_system
	$(CP) $(PKG_BUILD_DIR)/luasrc/model/cbi/admin_system/* $(1)/usr/lib/lua/luci/model/cbi/admin_system
	
	$(INSTALL_DIR) $(1)/www/cgi-bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/luasrc/www/cgi-bin/* $(1)/www/cgi-bin
	
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/luasrc/usr/sbin/* $(1)/usr/sbin
	
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	$(PO2LMO) ./lang/jmlicense.zh-cn.po $(1)/usr/lib/lua/luci/i18n/jmlicense.zh-cn.lmo
	
#	$(INSTALL_DIR) $(1)/www/luci-static/resources
#	$(CP) ./luci-static/resources/* $(1)/www/luci-static/resources
endef

$(eval $(call BuildPackage,luci-app-jmlicense))
