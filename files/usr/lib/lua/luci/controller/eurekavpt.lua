module("luci.controller.eurekavpt", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/eurekavpt") then
		return
	end

	entry({"admin", "services", "eurekavpt"}, cbi("eurekavpt"), _("EurekaVPT"), 74).dependent = true
end