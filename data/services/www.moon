
service "www", {
	consumes "www", {}

	configure: =>
		os.execute "mkdir -p #{@\getConfigurationRoot!.rootDirectory}/srv/www/#{self\getDomain! or "@"}"
}

