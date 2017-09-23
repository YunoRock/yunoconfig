
service "test-app", {
	consumes "http", {
		optional: true
		publicPorts: {80}
	}
	consumes "php", {}
	consumes "ldap", {}
}

