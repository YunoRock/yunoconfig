
service "test-app", {
	depends "http", {}
	depends "php", {}
	depends "ldap", {}
}

