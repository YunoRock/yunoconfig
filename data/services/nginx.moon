
service "nginx", {
	provides "http", {}
	provides "www", {}
	provides "php", {}
	depends "http", {
		optional: true
	}

	configure: =>
		os.execute "mkdir -p test-cfg"

		@\writeTemplate "nginx", "test-cfg/nginx.cfg"

		for service in *@\getUsers!
			print "Generating configuration specific to #{service}."

			with io.open "test-cfg/nginx-#{service\getDomain! or ""}-#{service.name}.cfg", "w"
				\write "Configuration for service #{service.name} here."
				\close!
}

