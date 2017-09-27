
class
	new: (name, opt) =>
		for k,v in pairs opt
			self[k] = v

		@name = name
		@type = "provides"

