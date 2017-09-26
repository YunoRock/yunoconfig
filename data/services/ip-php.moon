
service "ip-php", {
	consumes "php", {}

	configure: (context) =>
		originDirectory = "./data/services/"
		destinationDirectory = "/srv/http/#{@\getDomainName! or "@"}"

		@\createDirectory destinationDirectory
		@\copy "#{originDirectory}/ip.php", destinationDirectory
}

