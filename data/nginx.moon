
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
		after = {"networking", "dns", "logger", "netmount"}

		if #@\getConsumers("php") > 0
			table.insert after, "php-fpm"

		{
			start: "nginx -c #{configFile}"
			preStart: "nginx -t -c #{configFile}"
			reload: "signal:HUP"
			-- Default handler.
			--stop: "signal:TERM"
			requiredFiles: {configFile}
			:after
		}

	generate: =>
		configFile = "/etc/yunorock/#{@\getDomainName! or "@"}/nginx.cfg"
		@\writeTemplate "nginx", configFile
}

