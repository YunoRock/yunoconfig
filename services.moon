
moonscript = require "moonscript"
util = require "moonscript.util"
lfs = require "lfs"
argparse = require "argparse"

Configuration = require "services.configuration"

---
-- Importing service files.
---

for fileName in lfs.dir "data/services"
	switch fileName
		when ".", ".."
			continue

	if not fileName\match "%.moon$"
		continue

	fileName = "data/services/" .. fileName

	func, reason = moonscript.loadfile fileName
	if func
		helpers = require "services.service_helpers"
		helpers.print = print
		helpers.table = table
		helpers.string = string
		helpers.io = io
		helpers.tostring = tostring
		helpers.os = os
		helpers.templates = templates
		helpers.registeredServices = {}

		util.setfenv func, helpers
		func!

		for service in *helpers.registeredServices
			Configuration.Service.register service.name, service
	else
		error reason, 0

---
-- CLI parsing
---

arg = do
	parser = with argparse "services", "Centralized configuration management tool."
		\command "print",     "Prints the current configuration tree."
		\command "generate",  "Generates the configuration files for all the registered services."
	parser\parse!

---
-- Importing configuration.
---

configuration = Configuration.fromFileName "config.cfg"

if arg.print
	configuration\print!
elseif arg.generate
	configuration\generate!

