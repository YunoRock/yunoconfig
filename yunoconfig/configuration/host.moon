
Object = require "yunoconfig.configuration.object"

class extends Object
	new: (name, opt) =>
		@name = name

		@domainName = opt.domain or nil
		@addresses = opt.addresses or nil
		@gateway = opt.gateway or nil

	__tostring: => "<configuration.host: #{@name}>"

	print: =>
		print @\__tostring!

		if @domainName
			@\printIndent 1
			print "domain: ", @domainName

		if @gateway
			@\printIndent 1
			print "gateway: ", @gateway

		if @addresses
			@\printIndent 1
			print "addresses: ", table.concat @addresses, ", "

