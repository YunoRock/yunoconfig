
service "mariadb", {
	provides "sql", { }
	provides "mysql", { }

	--service: =>
	--	preStartOpts = ""
	--	for consumer in *@\getConsumers!
	--		-- user | password
	--		name = consumer\getDomainName!\gsub "%.", "_"
	--		preStartOpts ..= " '#{name}' '#{@cache.passwords[tostring(consumer)]}' '#{name}'"

	--	print preStartOpts
	--	{
	--		preStart: "/usr/local/bin/db-handle.sh check-or-create #{@cache.rootPassword} #{preStartOpts}"
	--		start: "mysqld"
	--		use: {"net"}
	--		need: {"localmount"}
	--	}

	configure: =>
		unless @cache.rootPassword
			p = io.popen "cat /dev/urandom | base64 | head -c 40", "r"
			rootPassword = p\read "*line"
			p\close!

			@cache.rootPassword = rootPassword

		@cache.passwords or= {}

		for consumer in *@\getConsumers!
			unless @cache.passwords[tostring(consumer)]
				p = io.popen "cat /dev/urandom | base64 | head -c 40", "r"
				password = p\read "*line"
				p\close!

				@cache.passwords[tostring(consumer)] = password

		@\writeTemplate "mariadb_openrc", "etc/init.d/services-#{@\getDomainName! or "@"}.mariadb"
}

