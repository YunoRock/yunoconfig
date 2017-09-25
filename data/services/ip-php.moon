
service "ip-php", {
	provides "php", {}

	configure: =>
		originDirectory = "./data/services/"
		destinationDirectory = "#{@\getConfigurationRoot!.rootDirectory}/srv/http/#{@\getDomain! or "@"}"

		os.execute "mkdir -p '#{destinationDirectory}'"
		os.execute "cp '#{originDirectory}/ip.php' '#{destinationDirectory}/'"
}

