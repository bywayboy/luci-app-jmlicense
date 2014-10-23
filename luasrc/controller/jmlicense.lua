--[[
LuCI - Lua Configuration Interface

Copyright 2014 bywayboy <bywayboy@qq.com>

]]--

module("luci.controller.jmlicense", package.seeall)

function index()
	
	local page

	page = entry({"admin", "system", "licensekey"}, call("action_licensekey"), _("License Key"))
	page.dependent = true
	
	entry({"admin", "system", "jimair_status"}, call("action_jimair_status"))
	entry({"admin", "system", "jimair_licenstate"}, call("action_jimair_licenstate"))
	
	if nixio.fs.access("/etc/config/devinfo") then
		page = entry({"admin", "system", "whitelist"}, cbi("admin_system/whitelist"),_("MAC White list"))
		page.dependent = true
	end
	
	if nixio.fs.access("/etc/config/ap") then
		page = entry({"admin", "services", "apmanage"}, cbi("admin_services/apmanage"), _("AP Manager"))
		page.dependent = true
	end
end

function action_licensekey()
	local sys = require "luci.sys"
	local fs  = require "luci.fs"
	local license_file = "/etc/licenseKey"
	local license_key_value = luci.http.formvalue("license_key")
	
	if license_key_value then
		-- write to file
		nixio.fs.writefile(license_file, license_key_value);
	else
		license_key_value=nixio.fs.readfile(license_file)
	end

	luci.template.render("admin_system/licensekey", {
		license_key   = license_key_value
	});
end

function action_jimair_licenstate()
	local file="/etc/licenseconfig"
	local json =  "{\"valid\":false, \"expires\":\"19700101\"}"
	
	luci.http.prepare_content("application/json")
	
	if nixio.fs.access(file) then
		json = nixio.fs.readfile(file)
	end
	
	luci.http.write(json);	
end

function action_jimair_status()

	local file="/var/yifi.stat"
	local json =  "{\"bind\":false, \"username\":\"\",\"message\":\"\"}"
	
	luci.http.prepare_content("application/json")
	
	if nixio.fs.access(file) then
		json = nixio.fs.readfile(file)
	end
	
	luci.http.write(json);	
end
