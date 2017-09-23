
moonscript = require "moonscript"
util = require "moonscript.util"
lfs = require "lfs"
argparse = require "argparse"

service_helpers = require "services.service_helpers"

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
		registeredServices = {}

		helpers = {
			provides: service_helpers.Provides
			consumes: service_helpers.Consumes
			service: (...) ->
				service = service_helpers.Service ...

				table.insert registeredServices, service

			print: print
			table: table
			string: string
			io: io
			tostring: tostring
			os: os
			templates: templates
		}

		util.setfenv func, helpers
		func!

		for service in *registeredServices
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
		with \option "-r --root",    "Sets the root of the configuration tree.", "test-cfg"
			\count 1
		with \option "-c --cache",   "Sets the path to the cache to read and save.", "/var/cache/services"
			\count 1
	parser\parse!

---
-- Importing configuration.
---

configuration = Configuration.fromFileName "config.cfg", {
	cacheDirectoryPath: arg.cache
}

if arg.print
	configuration\print!
elseif arg.generate
	configuration.rootDirectory = arg.root

	configuration\generate!

