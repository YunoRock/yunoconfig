
Domain = require "yunoconfig.configuration.domain"

Root = class extends Domain
	new: (opt) =>
		super "@", opt

	getDomainName: =>

	getServiceById: (id) =>
		for service in *@services
			if service\getId! == id
				return service

		for domain in *@domains
			service = Root.getServiceById domain, id

			if service
				return service

	__tostring: =>
		"<configuration.root>"

Root

