
class
	new: (name, opt) =>
		@name = name

		@addresses = opt.addresses or nil

	__tostring: => "<configuration.host: #{@name}>"

