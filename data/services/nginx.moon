
service "nginx", {
	provides "http", {}
	provides "www", {}
	provides "php", {}
	consumes "http", {
		optional: true
		publicPorts: {80, 443}
	}

	configure: =>
		@\writeTemplate "nginx", "etc/nginx.cfg"
}

