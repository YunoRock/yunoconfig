
service "www", {
	consumes "www", {}

	configure: (context) =>
		@\createDirectory "/srv/www/#{@\getDomainName! or "@"}"
		--os.execute "mkdir -p #{context.outputDirectory}/srv/www/#{self\getDomain! or "@"}"
}

