--[[
--EurekaVPT configuration page. Made by Yang
--
]]--

local fs = require "nixio.fs"


m = Map("eurekavpt", translate("EurekaVPT"),
        translatef("EurekaVPT, re-enable the real internet."))

s = m:section(TypedSection, "eurekavpt", translate("EurekaVPT"))
s.anonymous = true

o = s:option(Flag, 'enabled', translate("Enabled"))
o.rmempty=false


o = s:option(ListValue, "backend", translate("Backend"))
o:value('custom',translate("Custom"))
o:value('ssledge',translate("SSLedge"))
o:value('shadowsocks',translate("Shadowsocks"))
o.default = "ssledge"
o.rmempty=false

s = m:section(TypedSection, "ssledge", translate("SSLedge Settings"))
s.anonymous = true
o = s:option(Flag, "enabled", translate("Enable SSLedge"))
o.rmempty = false
o.default = 0

username = s:option(Value, "username", translate("Username"))
username.rmempty = false
username.default = ''

password = s:option(Value, "password", translate("Password"))
password.password = true
password.rmempty = false
password.default = ''

-- o = s:option(DummyValue, "_dummy", translate("Available HTTPS Servers"))
-- o.template = "cbi/ssledgelist"
-- o.testid = username.cbid

o = s:option(DynamicList, "serverhttps", translate("HTTPS Proxy Servers"))

o = s:option(DynamicList, "serversocks", translate("Socks Proxy Servers"))

o = s:option(ListValue, "servercipher", translate("Encrypt cipher"))
o:value('AES128','ECDHE-RSA-AES128-GCM-SHA256')
o:value('ECDHE-RSA-CHACHA20-POLY1305', 'ECDHE-RSA-CHACHA20-POLY1305')
o.default = 'AES128'
o.rmempty = false

o = s:option(Value, 'haproxy_maxconn', translate("HAProxy Maxconn"))
o.default = '3000'
o.rmempty = false

o = s:option(Value, 'haproxy_nbproc', translate("HAProxy nbproc"))
o.default = '1'
o.rmempty = false



s = m:section(TypedSection, "bypassmode", translate("Bypass Options"))
s.anonymous = true
s:tab("tab_general", translate("General"))

o = s:taboption("tab_general", ListValue, 'mode', translate("Default to"))
o:value('isp', translate("ISP"))
o:value('proxy', translate("Proxy"))
o.default = 'isp'
o.rmempty = false

o = s:taboption("tab_general", ListValue, 'ingfw_dns', translate("CHN DNS"))
o:value('isp', translate("DNS from ISP"))
o:value('114.114.114.114', translate("114DNS (114.114.114.114)"))
o:value('114.114.115.115', translate("114DNS (114.114.115.115)"))
o:value('223.5.5.5', translate("AliDNS (223.5.5.5)"))
o:value('223.6.6.6', translate("AliDNS (223.6.6.6)"))
o:value('1.2.4.8', translate("sDNS (1.2.4.8)"))
o:value('210.2.4.8', translate("sDNS (210.2.4.8)"))
o:value('180.76.76.76', translate("Baidu DNS (180.76.76.76)"))
o:value('119.29.29.29', translate("DNSPOD Public DNS (119.29.29.29)"))
o.default = 'isp'
o.rmempty = false

o = s:taboption("tab_general", DummyValue, 'ingfw_dns_port', translate("CHN DNS Port"))

o = s:taboption("tab_general", Flag, "hijacklandns", translate("Redirect all DNS Queries to Router"))
o.default = '1'
o.rmempty = false

o = s:taboption("tab_general", Button, "update_lists", translate("Update gfwlist & chnroute & cdn"))
function o.write()
	luci.sys.call("/opt/ssledge/update-lists.sh")
end

s:tab("tab_dns2socks", translate("DNS2Socks"))
o = s:taboption("tab_dns2socks", Value, 'd2s_local_ip', translate("D2S Server IP"))
o.rmempty = false
o.default = '127.0.0.1'

o = s:taboption("tab_dns2socks", Value, 'd2s_local_port', translate("D2S Server Port"))
o.rmempty = false
o.default = '1052'

o = s:taboption("tab_dns2socks", ListValue, 'd2s_proxy_type', translate("D2S Proxy Type"))
o:value('http', translate("HTTP Proxy"))
o:value('socks', translate("Socks5 Proxy"))
o.rmempty = false
o.default = 'http'

o = s:taboption("tab_dns2socks", Value, 'remote_dns', translate("Remote DNS"))
o.default = '8.8.8.8'
o.rmempty = false

o = s:taboption("tab_dns2socks", Value, 'remote_dns_port', translate("Remote DNS Port"))
o.default = '53'
o.rmempty = false


s:tab("tab_blacklist", translate("Blacklist domains"))
o = s:taboption("tab_blacklist", Flag, 'gfwlist', translate("Enable GFWList"))
o.default = '1'
o.rmempty = false

o = s:taboption("tab_blacklist", Flag, 'blacklist', translate("Enable Custom Blacklist"))
o.default = '0'
o.rmempty = false

o = s:taboption("tab_blacklist", DynamicList, 'blacklist_domain', translate("Blacklist Domain"))

s:tab("tab_blackip", translate("Blacklist IPs"))
o = s:taboption("tab_blackip", Flag, 'blackip', translate("Enable Black IPs"))
o.default = '0'
o.rmempty = false

o = s:taboption("tab_blackip", DynamicList, 'blacklist_ip', translate("Blacklist IP"))
 

s:tab("tab_whitelist", translate("Whitelist domains"))
o = s:taboption("tab_whitelist", Flag, 'cdn', translate("CHN CDN Whitelist"))
o.default = '0'
o.rmempty = false

o = s:taboption("tab_whitelist", Flag, 'whitelist', translate("Enable Whitelist"))
o.default = '0'
o.rmempty = false

o = s:taboption("tab_whitelist", DynamicList, 'whitelist_domain', translate("Whitelist Domain"))

s:tab("tab_whiteip", translate("Whitelist IPs"))
o = s:taboption("tab_whiteip", Flag, 'chnroute', translate("Enable CHNRoute"))
o.default = '1'
o.rmempty = false

o = s:taboption("tab_whiteip", Flag, 'whiteip', translate("Enable Custom White IPs"))
o.default = '0'
o.rmempty = false
o = s:taboption("tab_whiteip", DynamicList, 'whitelist_ip', translate("Whitelist IP"))


return m
