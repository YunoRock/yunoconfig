
colors = require "term.colors"
lfs = require "lfs"
serpent = require "serpent"
loadkit = require "loadkit"
etlua = require "etlua"

Object = require "yunoconfig.configuration.object"

dirname = (filepath) ->
	name = filepath\gsub "/[^/]*$", ""

	if name == filepath
		name = "."

	return name

class extends Object
	new: (name, opt) =>
		super name, opt

		@type = "service"

		@definition = opt.definition

		-- Errors storage.
		@brokenness = {}

		---
		-- Stores the ids of the services that provide the tags we consume.
		-- Keys are tag names.
		@tagProviders = {}

		for tag in *@definition.consumedTags
			@tagProviders[tag.name] = opt[tag.name]

		@portNumbers = {}

		for tagName, value in pairs(opt.portNumbers or {})
			switch type(value)
				when "table"
					@portNumbers[tagName] = value
				when "number"
					@portNumbers[tagName] = {value}
				else
					print "warning: '#{self.name}' has invalid portNumbers for tag '#{tagName}'"
					print "warning: default ports will be used for service '#{self.name}' and tag '#{tagName}'"

		@createdFiles = {}

	finalize: (context) =>
		@context = context

		unless @definition
			error "#{self} has no .definition field."

		@cache = @\loadCache(context) or {
			portNumbers: {}
		}

		if @definition.configure
			@definition.configure self

		if not @\isBroken!
			for tag, providerId in pairs @tagProviders
				provider = @\getServiceById providerId

				unless provider
					table.insert @brokenness, "provider '#{providerId}' does not exist"
				else if provider\isBroken!
					table.insert @brokenness, "provider '#{providerId}' is broken"

	requestInternalPorts: (portsName, amount = 1) =>
		@portNumbers[portsName] or= {}

		cachedPorts = @cache.portNumbers[portsName] or {}

		for i = 1, amount
			-- User-configured value.
			configurationNumber = @portNumbers[portsName][i]
			cachedNumber = cachedPorts[i]

			port = configurationNumber or cachedNumber or @context\getFreeLocalPortNumber!

			unless @context\registerPort port, self
				table.insert @brokenness, "port '#{port}' is already used"
				return false

			@portNumbers[portsName][i] = port

		true

	requestPublicPorts: (portsName, numbers) =>
		@portNumbers[portsName] or= {}

		for index, number in ipairs numbers
			-- Already cached or user-defined.
			oldNumber = @portNumbers[portsName][index]
			if oldNumber
				if not @context\registerPort oldNumber, self
					table.insert @brokenness, "port '#{port}' is already used"
					return false
				else
					continue

			unless @context\registerPort number, self
				table.insert @brokenness,
					"port '#{number}' is already used"
				return false

			@portNumbers[portsName][index] = number

			true

	getCacheFilePath: (context) =>
		table.concat {
			context.cacheDirectory,
			"#{@\getDomainName! or "@"}.#{@name}.serpent"
		}, "/"

	loadCache: (context) =>
		cacheFilePath = @\getCacheFilePath context

		file = io.open cacheFilePath, "r"

		-- FIXME: print errors other than “no such file or directory”
		unless file
			return

		content = file\read "*all"

		success, value = serpent.load content

		if success
			value
		else
			nil, value

	saveCache: (context) =>
		cacheFilePath = @\getCacheFilePath context

		os.execute "mkdir -p '#{context.cacheDirectory}'"

		file, reason = io.open cacheFilePath, "w"

		unless file
			print "warning: could not open cache file '#{cacheFilePath}' of service '#{@\getId!}'"
			print "         ... reason: #{reason}"
			return

		@cache.portNumbers = @portNumbers

		file\write serpent.dump @cache

		file\close!

	generate: (context) =>
		if @\isBroken!
			print "<#{colors.red @\getId!}> -- BROKEN"
			return

		print "<#{colors.cyan @\getId!}>"

		if @definition.generate
			@definition.generate self, context

		if @definition.service
			serviceData = @definition.service self, context

			context.definedServices[context.servicesManager]\generate context, self, serviceData

		@\saveCache context

		@\writeYunoBackupFile!

	writeYunoBackupFile: =>
		os.execute "mkdir -p '#{@context.outputDirectory}/etc/yunobackup'"
		file = io.open "#{@context.outputDirectory}/etc/yunobackup/yunorock-#{@\getDomainName! or "@"}-#{@name}.moon", "w"

		file\write "{\n"
		file\write "\tname: 'yunorock-#{@\getDomainName! or "@"}-#{@name}'\n"
		file\write "\tfiles: {\n"
		for filepath in *@createdFiles
			file\write "\t\t'#{filepath}'\n"
		file\write "\t}\n"

		if @definition.exports
			file\write "\tscripts: {\n"
			for script in *@definition.exports self, @context
				file\write "\t\t\"#{script}\"\n"
			file\write "\t}\n"

		file\write "}\n"

		file\close!

	registerCreatedFile: (path, options) =>
		options or= {}

		unless options.nobackup
			unless path\match "^/"
				path = "/" .. path

			for oldEntry in *@createdFiles
				if path == oldEntry
					-- duplicate, ignoring.
					return true

			table.insert @createdFiles, path

	writeTemplate: (name, destination, environment, options) =>
		@\registerCreatedFile destination, options

		destinationPath = @context.outputDirectory .. "/" .. destination

		do -- Creating the necessary directories.
			m = destinationPath\match "/[^/]+$"

			if m
				os.execute "mkdir -p '#{destinationPath\sub 1, destinationPath\len! - m\len!}'"

		-- We try to open it by filename before using loadkit.
		-- Users may not understand the lua load path, so this makes a safe fallback for them.
		templateFile = io.open name, "r"

		unless templateFile
			loader = loadkit.make_loader "ept", nil,
				@context.templatesLoadPath ..
				";./data/templates/?.lua" ..
				";/usr/share/yunoconfig/templates/#{@name}/?.lua" ..
				";/usr/share/yunoconfig/templates/?.lua"

			templateFileName = loader name

			unless templateFileName
				print colors.red "   template: '#{name}' (template file could not be found)"
				return

			templateFile = io.open templateFileName, "r"

		templateContent = templateFile\read "*all"
		templateFile\close!

		template = etlua.compile templateContent

		unless template
			print colors.red "   template: '#{name}' (template file could not be opened)"
			return

		destinationFile = io.open destinationPath, "w"

		unless destinationFile
			print colors.red "   template: '#{name}' (could not open destination file '#{destinationPath}')"
			return

		success, string = pcall -> template environment or {service: self, :context}
		if success
			destinationFile\write string
		else
			print colors.red "   template: '#{name}' (error while rendering template)"
			print "  ... #{string}"

		io.write "   template: '#{colors.green name}' -> '#{colors.white destination}'", "\n"

		destinationFile\close!

	createDirectory: (relativePath, options) =>
		@\registerCreatedFile ((relativePath .. "/")\gsub "//$", "/"), options

		io.write "   directory: '#{colors.magenta relativePath}'", "\n"

		os.execute "mkdir -p '#{@context.outputDirectory}/#{relativePath}'"

	copy: (source, destination, options) =>
		originalAttributes = lfs.attributes @context.outputDirectory .. "/" .. destination
		if originalAttributes and originalAttributes.mode == "directory"
			@\registerCreatedFile (destination .. "/" .. source\gsub ".*/", ""), options
		else
			os.execute "mkdir -p '#{@context.outputDirectory}/#{dirname destination}'"

			@\registerCreatedFile destination, options

		io.write "   copy: '#{colors.blue source}' -> '#{colors.white destination}'", "\n"
		os.execute "cp -r '#{source}' #{@context.outputDirectory}/#{destination}"

	message: (...) =>
		io.write "   ", ..., "\n"

	getDomainName: =>
		@parent\getDomainName!

	getId: =>
		(@\getDomainName! or "") .. "/" .. self.name

	getConsumers: (tagName) =>
		consumers = {}

		tagNames = if tagName
			{tagName}
		else
			[tag.name for tag in *@definition.providedTags]

		for name in *tagNames
			for domain in @parent\subdomains!
				for service in *domain.services
					if service.tagProviders[name] == @\getId!
						if service\isBroken!
							continue

						table.insert consumers, service

		consumers

	getRecursiveConsumers: (tagName) =>
		consumers = {}

		for consumer in *@\getConsumers tagName
			table.insert consumers, consumer

			for c in *consumer\getRecursiveConsumers tagName
				table.insert consumers, c

		consumers

	print: (indentLevel = 0) =>
		@\printIndent indentLevel
		io.write "service: ", (colors.bright colors.white self.name)

		if @\isBroken!
			io.write "  -- BROKEN: "

			io.write table.concat @brokenness, ", "

		io.write "\n"

		for tag in *@definition.consumedTags
			@\printIndent indentLevel

			if not @tagProviders[tag.name]
				if tag.optional
					io.write colors.blue "  [-] #{tag.name}"
				else
					io.write colors.red "  [-] #{tag.name}"
			else
				io.write colors.yellow "  [-] #{tag.name}"

			if @tagProviders[tag.name]
				io.write "  provided by  ", colors.cyan "#{@tagProviders[tag.name]}"
			else
				io.write "  not provided, not needed"

			io.write "\n"

		for tag in *@definition.providedTags
			@\printIndent indentLevel
			io.write colors.green "  [+] #{tag.name}"

			consumers = [colors.cyan consumer\getId! for consumer in *@\getConsumers tag.name]

			if #consumers > 0
				io.write "  consumed by  ", table.concat(consumers, ", ")
			else
				io.write "  not consumed"

			io.write "\n"


		ports = [{:name, :numbers} for name, numbers in pairs @portNumbers]
		table.sort ports, (a, b) -> a.name < b.name

		for port in *ports
			@\printIndent indentLevel
			io.write "  #{port.name} port(s): "
			io.write table.concat(port.numbers, ", ")
			io.write "\n"

	providesTag: (name) =>
		for tag in *@definition.providedTags
			if tag.name == name
				return tag

	getConfigurationRoot: =>
		root = @parent
		while root.parent
			root = root.parent
		root

	getServiceById: (id) =>
		@\getConfigurationRoot!\getServiceById id

	isBroken: => #@brokenness > 0

	__tostring: =>
		"<configuration.service: #{@name} on #{@\getDomainName! or "@"}>"

