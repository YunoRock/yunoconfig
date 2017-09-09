
moonscript = require "moonscript"
util = require "moonscript.util"
lfs = require "lfs"
argparse = require "argparse"

-- :(
export registeredServices = {}

---
-- Importing service files.
---

for fileName in lfs.dir "data/services"
	switch fileName
		when ".", ".."
			continue

	fileName = "data/services/" .. fileName

	func, reason = moonscript.loadfile fileName
	if func
		helpers = require "services.service_helpers"
		helpers.registeredServices = {}

		util.setfenv func, helpers
		func!

		for service in *helpers.registeredServices
			if registeredServices[service.name]
				error "service #{service.name} already declared."

			table.insert registeredServices, service
			registeredServices[service.name] = service
	else
		error reason, 0

---
-- Importing configuration.
--

helpers = require "services.config_helpers"

func, reason = moonscript.loadfile "config.cfg"

local root

if func
	util.setfenv func, helpers
	root = func!
else
	error reason, 0

if root and root.__class == require("services.config_helpers").Root
	root\print!
else
	error "could not load configuration (returned item must be root object)", 0

