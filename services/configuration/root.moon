
Domain = require "services.configuration.domain"

class extends Domain
	new: (opt) =>
		super "@", opt

	getDomainName: =>

	__tostring: =>
		"<configuration.root>"

