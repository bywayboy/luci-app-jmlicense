local wa = require "luci.tools.webadmin"
local fs = require "nixio.fs"

m = Map("ap", translate("AP Manager"),
	translate("."))
		
s = m:section(TypedSection, "ap", translate("AP List"), translate("This page allows you to manage AP router below, please do not modify the MAC, model."))
s.template = "cbi/tblsection"
s.anonymous = true
s.addremove = true
s.sortable  = false

t = s:option(Value, "nick", translate("Name"))


t = s:option(Value, "macaddr", translate("MAC"))
t.datatype = "macaddr"
t.disabled  = true

t = s:option(Value, "model", translate("Model"))
t = s:option(ListValue, "channel", translate("Channel"))
t:value("auto")
for v=1,13 do
	t:value(v)
end

t = s:option(ListValue, "power", translate("Power"))
for v=10,100,10 do
	t:value(v)
end

t = s:option(Value, "ssid", translate("SSID"))

return m