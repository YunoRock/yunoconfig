
service "test-app", {
	depends "http", {
		optional: true
		publicPorts: {80}
	}
	depends "php", {}
	depends "ldap", {}
}

