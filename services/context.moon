
moonscript = require "moonscript"
util = require "moonscript.util"
lfs = require "lfs"

ServiceDefinition = require("services.definition.service")
ConfigurationService = require("services.configuration.service")

class
	new: (opt) =>
		opt or= {}

		@outputDirectory = opt.outputDirectory or "/"
		@cacheDirectory = opt.cacheDirectory or "/var/cache/services"
		@servicesDirectory = opt.servicesDirectory or "./data"
		@servicesManager = opt.servicesManager or "openrc"

		@definedServices = {}

		@allCachedPorts = {}
		@lastLocalPortUsed = 6666 - 1

		@templatesLoadPath = opt.templatesLoadPath or "/etc/services/templates/?.lua"

		@\loadCachedData!

	loadCachedData: =>
		cacheDirectory = @cacheDirectory
		cacheAttributes = lfs.attributes cacheDirectory

		if cacheAttributes and cacheAttributes.mode == "directory"
			for entry in lfs.dir cacheDirectory
				if entry == "." or entry == ".."
					continue

				filePath = table.concat {cacheDirectory, entry}, "/"

				file, reason = io.open filePath, "r"

				unless file
					print "warning: could not open cache file '#{filePath}': #{reason}"
					continue

				_, data = serpent.load file\read "*all"

				file\close!

				for tagName, ports in pairs(data.portNumbers or {})
					for port in *ports
						@allCachedPorts[#@allCachedPorts+1] = port

	importServices: =>
		for entry in lfs.dir @servicesDirectory
			entryLength = string.len entry

			if entry\sub(entryLength - 4, entryLength) != ".moon"
				continue

			completeFilePath = @servicesDirectory .. "/" .. entry

			f, reason = moonscript.loadfile completeFilePath

			unless f
				print "warning: could not load #{completeFilePath}"
				print "          ... #{reason}"
				continue

			definedServices = {}

			util.setfenv f, {
				service: (...) ->
					table.insert definedServices, ServiceDefinition ...
				consumes: require("services.definition.consumes")
				provides: require("services.definition.provides")

				:tostring, :tonumber, :print
				:table, :os, :io, :string
			}

			f!

			for service in *definedServices
				table.insert @definedServices, service

				if @definedServices[service.name]
					print "warning: service '#{service.name}' is defined more than once"

				@definedServices[service.name] = service

	importConfiguration: (filename = "config.cfg") =>
		f = assert moonscript.loadfile filename

		util.setfenv f, {
			root: require("services.configuration.root")
			domain: require("services.configuration.domain")
			service: (name, opt) ->
				opt.definition = @definedServices[name]

				ConfigurationService name, opt
		}

		@configuration = f!

		@configuration\finalize self

		@configuration

	getFreeLocalPortNumber: =>
		while true
			@lastLocalPortUsed += 1

			portIsFree = true
			for port in *@allCachedPorts
				if port == @lastLocalPortUsed
					portIsFree = false

					break

			if portIsFree
				return @lastLocalPortUsed

	print: =>
		@configuration\print!

	generate: =>
		@configuration\generate self

	__tostring: => "<configuration.context>"

