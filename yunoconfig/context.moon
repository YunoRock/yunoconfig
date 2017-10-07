
serpent = require "serpent"
moonscript = require "moonscript"
util = require "moonscript.util"
lfs = require "lfs"

ServiceDefinition = require("yunoconfig.definition.service")
ConfigurationService = require("yunoconfig.configuration.service")
Host = require("yunoconfig.configuration.host")

class
	new: (opt) =>
		opt or= {}

		@outputDirectory = opt.outputDirectory or "/"
		@cacheDirectory = opt.cacheDirectory or "/var/cache/yunoconfig"
		@servicesDirectory = opt.servicesDirectory or "./data"
		@servicesManager = opt.servicesManager or "openrc"

		@definedServices = {}
		@definedHosts = {}

		@allCachedPorts = {}
		@lastLocalPortUsed = 6666 - 1

		@templatesLoadPath = opt.templatesLoadPath or "/etc/yunoconfig/templates/?.lua"

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
				consumes: require("yunoconfig.definition.consumes")
				provides: require("yunoconfig.definition.provides")

				:tostring, :tonumber, :print
				:table, :os, :io, :string
				:require
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
			root: require("yunoconfig.configuration.root")
			domain: require("yunoconfig.configuration.domain")
			service: (name, opt) ->
				opt.definition = @definedServices[name]

				unless opt.definition
					print "error: no definition for service '#{name}'"
					os.exit 1

				ConfigurationService name, opt
			host: (name, opt) ->
				table.insert @definedHosts, Host name, opt
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

