
service "www", {
	consumes "www", {}

	configure: (context) =>
		directory = "/srv/www/#{@\getDomainName! or "@"}"
		@\createDirectory directory
		os.execute "chown -R nginx:nginx #{context.outputDirectory}#{directory}" -- FIXME: www-data, anyone?
}

