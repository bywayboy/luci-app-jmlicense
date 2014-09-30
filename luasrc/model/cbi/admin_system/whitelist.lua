local sys = require "luci.sys"
local datatypes = require "luci."
local uci    = require "luci.model.uci"
local cur = uci.cursor();
local http = require "luci.http";
local _ = luci.i18n.translate
local m


m = Map("devinfo", "MAC white list manage.",
		_("This page allows you to set MAC address white list."))	

-- 数据保存后 重启dhcp服务器
	m.on_after_commit = function(self)
		--luci.sys.call("/etc/init.d/yifi restart >/dev/null") 
	end
	
s = m:section(TypedSection, "whitelist", translate("White List MAC address"))
s.anonymous = true

val = s:option(DynamicList, "mac", translate("MAC"))
val.datatype = "list(macaddr)"
val.optional = true

sys.net.arptable(function(entry)
	val:value(entry["IP address"])
	val:value(
		entry["HW address"],
		entry["HW address"] .. " (" .. entry["IP address"] .. ")"
	)
end)


return m