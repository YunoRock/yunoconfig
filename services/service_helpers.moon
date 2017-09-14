
---
-- Data structures for service files.
--
-- This module will be used as environment for each service file.
--
-- The caller is responsible for setting “registeredServices” before each call.
---

Provides = class
	new: (name, opt) =>
		@name = name

	__tostring: => "<Provides, #{@name}>"

Depends = class
	new: (name, opt) =>
		@name = name

		@optional = opt.optional or false

		@publicPorts = opt.publicPorts or {}

	__tostring: => "<Depends, #{@name}>"

Service = class
	new: (name, opt) =>
		@name = name

		@depends = {}
		@provides = {}

		-- Custom configuration code, that can be used in @\generate.
		-- Can be used to create configuration files from templates or other things like that.
		@configure = opt.configure

		for e in *opt
			if e.__class == Depends
				table.insert @depends, e
			elseif e.__class == Provides
				table.insert @provides, e

	getDepends: (name) =>
		for d in *@depends
			if d.name == name
				return d

	getProvides: (name) =>
		for p in *@provides
			if p.name == name
				return p

	__tostring: => "<Service (reference), #{@name}>"

{
	:Service
	:Provides
	:Depends
}

