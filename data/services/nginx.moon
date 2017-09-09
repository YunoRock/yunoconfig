
service "nginx", {
	provides "http", {}
	provides "www", {}
	provides "php", {}
	depends "http", {
		optional: true
	}
}

