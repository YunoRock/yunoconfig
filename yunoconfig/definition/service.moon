
class
	new: (name, opt) =>
		for k,v in pairs opt
			if type(k) == "number"
				continue

			self[k] = v

		@name = name

		@consumedTags = {}
		@providedTags = {}

		@exports = opt.exports or nil

		for i = 1, #opt
			child = opt[i]

			switch child.type
				when "consumes"
					table.insert @consumedTags, child
				when "provides"
					table.insert @providedTags, child

	__tostring: => "<definition.service: #{@name}>"

