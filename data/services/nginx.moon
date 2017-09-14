
service "nginx", {
	provides "http", {}
	provides "www", {}
	provides "php", {}
	depends "http", {
		optional: true
		publicPorts: {80, 443}
	}

	configure: =>
		os.execute "mkdir -p test-cfg"

		@\writeTemplate "nginx", "test-cfg/nginx.cfg"
}

