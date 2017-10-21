
service "nginx", {
	provides "http", {}
	provides "www", {}
	provides "php", {}
	consumes "http", {
		optional: true
	--	publicPorts: {80, 443}
	}
	consumes "certificate", {
		optional: true
	}

	configure: =>
		if @tagProviders.http
			@\requestInternalPorts "http"
		else
			@\requestPublicPorts "http",  {80}
			@\requestPublicPorts "https", {443}

	service: (context) =>
		configFile = "/etc/yunorock/#{@\getDomainName! or "@"}/nginx.cfg"
		need = {"networking"}
		use = {"dns", "logger", "netmount"}

		if #@\getConsumers("php") > 0
			table.insert need, "php-fpm"

		{
			command: "nginx"
			commandArguments: {"-c", configFile}
			preStart: "nginx -t -c #{configFile}"
			reload: "signal:HUP"
			requiredFiles: {configFile}
			:need, :after, :use
		}

	generate: =>
		configFile = "/etc/yunorock/#{@\getDomainName! or "@"}/nginx.cfg"
		@\writeTemplate "nginx", configFile
}

