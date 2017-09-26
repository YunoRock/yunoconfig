
class
	new: (name, opt) =>
		@name = name

		@consumedTags = {}
		@providedTags = {}

		for i = 1, #opt
			child = opt[i]

			switch child.type
				when "consumes"
					table.insert @consumedTags, child
				when "provides"
					table.insert @providedTags, child

		@configure = opt.configure
		@service = opt.service

	__tostring: => "<definition.service: #{@name}>"

