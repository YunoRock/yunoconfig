port = 53

service "nsd", {
	-- bug with ports: port management should be redesigned

	service: (context) =>
		configDir = "/var/share/yunoconfig/#{@\getDomainName! or "@"}/"
		configFile = "#{configDir}/nsd.cfg"
		nsdControlSetup = "nsd-control-setup"
		daemon = "nsd-control"
		daemonFlags = "-c #{configFile}"

		{
			start: "#{daemon} #{daemonFlags} start"
			preStart: "
if [ -f #{configDir}/nsd_server.key ] || [ -f #{configDir}/nsd_server.pem ] || [ -f #{configDir}/nsd_control.key ] || [ -f #{configDir}/nsd_control.pem ]
then
	:
else
	#{nsdControlSetup} >/dev/null 2>&1
fi
				"
			reload: "#{daemon} #{daemonFlags} reconfig && #{daemon} #{daemonFlags} reload"
			-- Default handler.
			--stop: "signal:TERM"
			requiredFiles: {configFile}
			after: {"networking", "logger"}
		}

	configure: (context) =>
		-- 
		topLevelDomains = context.configuration.domains

		searchTLD = (node, callback) =>
			for domain in *node.domains
				callback domain
				searchTLD domain

		for domain in *topLevelDomains
			subDomains = {}
			searchTLD domain, (domain) -> table.insert subDomains, domain
			@\writeTemplate "dnszone", "/var/nsd/yunorock/master/#{domain\getDomainName!}.zone", {
				service: self
				-- subDomains: [ subDomain\getDomainName! for subDomain in *subDomains ]
				:subDomains
				topLevelDomain: domain
				serial: os.time!
			}

		configDir = "/var/share/yunoconfig/#{@\getDomainName! or "@"}/"
		configFile = "#{configDir}/nsd.cfg"
		@\writeTemplate "nsd", configFile, {
			:topLevelDomains
		}
}

