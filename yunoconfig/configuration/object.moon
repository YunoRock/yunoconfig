
class
	new: (name, opt) =>
		opt or= {}

		@name = name

		@children = {}

		for i = 1, #opt
			child = opt[i]

			table.insert @children, child

			child.parent = self

	finalize: (context) =>
		for child in *@children
			child\finalize context

	printIndent: (level) =>
		for i = 1, level
			io.write "  "
	print: (indentLevel = 0) =>
		@\printIndent indentLevel

		print "<#{@type}: #{@name}>"

		for child in *@children
			child\print indentLevel + 1

	generate: (context) =>
		for child in *@children
			child\generate context

	__tostring: => "<configuration.object>"

