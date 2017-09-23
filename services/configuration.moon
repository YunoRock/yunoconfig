
moonscript = require "moonscript"
util = require "moonscript.util"
loadkit = require "loadkit"
etlua = require "etlua"
colors = require "term.colors"
serpent = require "serpent"

_M = {}

local Service, Domain, Root

Domain = class
	new: (name, opt) =>
		@name = name

		@domain = opt.domain

		@services = {}
		@domains = {}

		for e in *opt
			if e.__class == Service
				e.parent = self

				table.insert @services, e
			elseif e.__class == Domain
				e.parent = self

				table.insert @domains, e

	finalize: =>
		for service in *@services
			service\finalize!

		for domain in *@domains
			domain\finalize!

	getDomain: =>
		domain = @domain or @name

		if @parent
			parentDomain = @parent\getDomain!

			if parentDomain
				return domain .. "." .. @parent\getDomain!

		domain

	getServices: =>
		coroutine.wrap ->
			for service in *@services
				coroutine.yield service
			for domain in *@domains
				for service in domain\getServices!
					coroutine.yield service

	getServiceById: (id) =>
		domain, service = id\match "([^/]*)%/(.*)"

		if domain == @name or (domain == "" and not @parent)
			for s in *@services
				if s.name == service
					return s
		elseif @parent
			return @parent\getServiceById id

	print: (i = 0) =>
		for _ = 1, i
			io.write "  "
		print "#{@\getDomain!}"

		for service in *@services
			service\print i+1

		for domain in *@domains
			domain\print i+1

	generate: =>
		for s in *@services
			if s\isBroken!
				print "#{s\getDomain! or ''}/#{s.name} -- not generating"
				print " ... reason: #{s\isBroken!}"

				continue

			s\generate!
		for d in *@domains
			d\generate!

Root = class extends Domain
	new: (opt) =>
		super "{{ROOT}}", opt

		@lastLocalPortUsed = 6666

		@rootDirectory = "/"

		@cacheDirectoryPath = ".services-cache" -- Will be set in services.moon.

		@allCachedPorts = {}

	getDomain: => nil

	print: =>
		for s in *@services
			s\print!
		for d in *@domains
			d\print!

	finalize: =>
		cacheDirectoryAttributes = lfs.attributes(@cacheDirectoryPath)
			
		if cacheDirectoryAttributes and cacheDirectoryAttributes.mode == "directory"
			for f in lfs.dir @cacheDirectoryPath
				if f == "." or f == ".."
					continue

				filePath = "#{@cacheDirectoryPath}/#{f}"
				file, reason = io.open filePath, "r"

				unless file
					print "could not open #{filePath}: #{reason}"
					continue

				_, data = serpent.load file\read "*all"

				file\close!

				for name, ports in pairs data.portNumbers
					for port in *ports
						@allCachedPorts[#@allCachedPorts+1] = port

						print filePath, port

		Domain.finalize self

	getFreeLocalPort: (service) =>
		while true
			@lastLocalPortUsed += 1

			portIsFree = true
			for port in *@allCachedPorts
				if port == @lastLocalPortUsed
					portIsFree = false

					break

			if portIsFree
				return @lastLocalPortUsed

Service = class
	@registeredServices: {}
	@register = (name, reference) ->
		@@registeredServices[name] = reference

	new: (name, opt) =>
		@name = name

		unless @@registeredServices[name]
			error "unrecognized service '#{name}'"

		@reference = @@registeredServices[name]

		@domain = opt.domain

		@depends = {d.name, opt[d.name] for d in *@reference.depends}

		@portNumbers = {}

		for name, value in pairs (opt.portNumbers or {})
			switch type(value)
				when "table"
					@portNumbers[name] = value
				when "number"
					@portNumbers[name] = {value}
				else
					print "configuration error: #{self.name} has invalid portNumber for #{name}"
					print " ... using default values"

	finalize: =>
		@cache = @\loadCache! or {
			portNumbers: {}
		}

		for depend in *@reference.depends
			@portNumbers[depend.name] or= @cache.portNumbers[depend.name]
			@portNumbers[depend.name] or= [port for port in @\getDefaultPortNumbers depend.name]

	getCacheFilePath: =>
		root = @\getConfigurationRoot!

		cacheDirectoryPath = root.cacheDirectoryPath or ".services-cache"
		cacheFilePath = "#{cacheDirectoryPath}/#{@\getDomain! or "@"}.#{@name}.serpent"

		cacheFilePath, cacheDirectoryPath

	loadCache: =>
		cacheFilePath, cacheDirectoryPath = @\getCacheFilePath!

		file = io.open cacheFilePath, "r"

		unless file
			return

		content = file\read "*all"

		success, value = serpent.load content

		if success
			return value
		else
			return nil, value

	saveCache: =>
		cacheFilePath, cacheDirectoryPath = @\getCacheFilePath!

		os.execute "mkdir -p '#{cacheDirectoryPath}'"

		file = io.open cacheFilePath, "w"

		@cache.portNumbers = @portNumbers

		file\write serpent.dump @cache

		file\close!

	isBroken: =>
		for d in *@reference.depends
			-- Services not configured.
			if d.optional
				continue

			unless @depends[d.name]
				return "missing dependency"

		-- Services configured, but invalid IDs.
			depend = @\getServiceById @depends[d.name]

			unless depend
				return "invalid service id"

		false

	getServiceById: (id) =>
		@parent\getServiceById id

	getUsers: (provideId) =>
		users = {}
		parent = @parent

		for service in parent\getServices!
			for d in *@reference.depends
				dependsId = service.depends[d.name]

				unless dependsId
					continue

				if provideId and d.name != provideId
					continue

				s = service\getServiceById dependsId

				if s == self
					table.insert users, service

		users

	-- FIXME: Should return the high-level domain, but getConfigurationRoot?
	getRootDomain: =>
		parent = @parent or self

		while parent.parent
			parent = parent.parent

		return parent

	getConfigurationRoot: =>
		parent = @parent or self

		while parent.parent
			parent = parent.parent

		return parent

	print: (indent = 0) =>
		for _ = 1, indent
			io.write "  "

		io.write "#{@name}  "

		-- Printable domain indicator.
		domain = @\getDomain! or "---"

		for i = @name\len!, 20 - indent * 2
			io.write "-"

		broken = @\isBroken!
		if broken
			io.write "  #{broken\upper!}"
		else
			io.write "  #{domain}"

		io.write "\n"

		users = @\getUsers!

		for d in *@reference.depends
			for _ = 1, indent+1
				io.write "  "

			if d.optional and not @depends[d.name]
				io.write colors.magenta table.concat {"⊟ ", d.name, "  "}
			else
				io.write colors.yellow table.concat {"⊟ ", d.name, "  "}

			for i = d.name\len!, 16 - indent * 2
				io.write "·"

			for port in *@portNumbers[d.name]
				io.write "  :", port

			-- A mandatory option is missing.
			unless @depends[d.name]
				if d.optional
					io.write "  OPTION UNSET\n"
				else
					io.write "  UNSET\n"

				continue

			service = @\getServiceById @depends[d.name]

			if service
				io.write "  ", service.name
				io.write " "
				io.write "(#{service\getDomain! or "---"})"
			else
				io.write "  INVALID SERVICE ID"

			io.write "\n"

		-- This would have been a lot easier with à getUser(provider).
		if #@reference.provides > 0
			for _ = 1, indent
				io.write "  "

			for p in *@reference.provides
				io.write colors.green table.concat {"  ⊞ ", p.name}

				providesUsers = {}
				for user in *users
					id = user.depends[p.name]

					alreadyInUsers = false
					for u in *providesUsers
						if u == user\getDomain! or u == user.name
							alreadyInUsers = true
							break

					if id and user\getServiceById(id) == self and not alreadyInUsers
						table.insert providesUsers, user\getDomain! or user.name

				if #providesUsers > 0
					io.write " (", table.concat(providesUsers, ", "), ")"

				io.write "\n"

	getDomain: =>
		@parent\getDomain!

	generate: =>
		print "#{@\getDomain! or ''}/#{@name}"

		if @reference.configure
			@reference.configure self

		@\saveCache!

	isPublic: (service) =>
		return @depends[service] == nil

	getDefaultPortNumbers: (service) =>
		if @\isBroken!
			return ->

		if @\isPublic service -- not piped, using public, default ports
			coroutine.wrap ->
				if service
					for port in *@reference\getDepends(service).publicPorts
						coroutine.yield port
				else
					for provides in *@reference.provides
						for port in *provides.publicPorts
							coroutine.yield port
		else -- piped, using local, arbitrary port
			coroutine.wrap ->
				for port in *({@\getCachedPort! or @\getConfigurationRoot!\getFreeLocalPort self})
					coroutine.yield port

	getCachedPort: => -- FIXME: NOT IMPLEMENTED

	writeTemplate: (name, destination, templateEnvironment) =>
		destination = @\getConfigurationRoot!.rootDirectory .. "/" .. destination

		do
			m = destination\match("/[^/]+$")

			if m
				os.execute "mkdir -p '#{destination\sub 1, destination\len! - m\len!}'"

		print " ... writing #{destination}"

		templateFile = io.open name, "r"

		unless templateFile
			loader = loadkit.make_loader "ept", nil,
				"./data/services/#{@name}/?.lua;./data/services/?.lua"

			templateFileName = loader name

			templateFile = io.open templateFileName, "r"

		templateContent = templateFile\read "*all"
		templateFile\close!

		template = assert etlua.compile templateContent

		file = io.open destination, "w"
		file\write template templateEnvironment or {service: self}
		file\close!

	__tostring: =>
		"<Service: #{@name}, #{@\getDomain!}>"

_M.Service = Service
_M.Domain = Domain
_M.Root = Root

_M.fromFileName = (filename = "config.cfg", opt) ->
	func, reason = moonscript.loadfile "config.cfg"

	local root

	if func
		util.setfenv func, {
			root: Root
			domain: Domain
			service: Service
		}
		root = func!
	else
		error reason, 0

	unless root or root.__class == Root
		error "could not load configuration (returned item must be root object)", 0

	if opt
		if opt.cacheDirectoryPath
			root.cacheDirectoryPath = opt.cacheDirectoryPath

	root\finalize!

	root

_M

