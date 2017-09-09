
moonscript = require "moonscript"
util = require "moonscript.util"

helpers = require "services.config_helpers"

(filename = "config.cfg") ->
	func, reason = moonscript.loadfile "config.cfg"

	local root

	if func
		util.setfenv func, {k,v for k,v in pairs helpers}
		root = func!
	else
		error reason, 0

	unless root or root.__class == require("services.config_helpers").Root
		error "could not load configuration (returned item must be root object)", 0

	root

