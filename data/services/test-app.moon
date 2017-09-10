
service "test-app", {
	depends "http", {
		portNumber: 6666
	}
	depends "php", {}
	depends "ldap", {}
}

