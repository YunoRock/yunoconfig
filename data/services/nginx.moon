
service "nginx", {
	provides "http", {}
	provides "www", {}
	provides "php", {}
	depends "http", {
		optional: true
		portNumber: 80
	}

	configure: =>
		os.execute "mkdir -p test-cfg"

		@\writeTemplate "nginx", "test-cfg/nginx.cfg"
}

