
service "ip-php", {
	consumes "php", {}

	generate: (context) =>
		originDirectory = "./data"
		destinationDirectory = "/srv/www/#{@\getDomainName! or "@"}"

		@\createDirectory destinationDirectory
		@\copy "#{originDirectory}/ip.php", destinationDirectory
}

