
---
-- Data structures for service files.
--
-- This module will be used as environment for each service file.
--
-- The caller is responsible for setting “registeredServices” before each call.
---

_M = {}

Provides = class
	new: (name, opt) =>
		@name = name

	__tostring: => "<Provides, #{@name}>"

Depends = class
	new: (name, opt) =>
		@name = name

		@optional = opt.optional or false

	__tostring: => "<Depends, #{@name}>"

Service = class
	new: (name, opt) =>
		@name = name

		@depends = {}
		@provides = {}

		for e in *opt
			if e.__class == Depends
				table.insert @depends, e
			elseif e.__class == Provides
				table.insert @provides, e

	__tostring: => "<Service (reference), #{@name}>"

_M.provides =  (...) -> Provides ...
_M.depends =   (...) -> Depends ...
_M.service =   (...) ->
	s = Service ...

	table.insert _M.registeredServices, s

return _M

