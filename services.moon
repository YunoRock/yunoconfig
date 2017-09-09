
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
-- CLI parsing
---

arg = do
	parser = with argparse "services", "Centralized configuration management tool."
		\command "print", "Prints the current configuration tree."
	parser\parse!

---
-- Importing configuration.
---

configuration = require "services.configuration"

configuration = configuration "config.cfg"

if arg.print
	configuration\print!

