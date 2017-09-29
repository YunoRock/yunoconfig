
service "gitea", {
	consumes "http", {
		publicPorts: {6666}
	}
	consumes "mysql", {}

	configure: =>
		domainName = @\getDomainName! or "@"
		configFile = "/etc/yunorock/#{domainName}/gitea.ini"

		@\writeTemplate "gitea", configFile
		@\writeTemplate "gitea_openrc", "/etc/init.d/services-#{domainName}.gitea"

		@\createDirectory "/srv/gitea/#{domainName}/repositories"
		@\createDirectory "/srv/gitea/#{domainName}/data"
		@\createDirectory "/srv/gitea/#{domainName}/avatars"
		@\createDirectory "/srv/gitea/#{domainName}/attachements"
		@\createDirectory "/var/log/gitea-#{domainName}"

		os.execute "chown -R gitea:www-data '#{@context.outputDirectory}/srv/gitea/#{domainName}'"
		os.execute "chown -R gitea:www-data '#{@context.outputDirectory}/var/log/gitea-#{domainName}'"
}

