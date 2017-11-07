
Context = require "yunoconfig.context"

describe "Context", ->
	local context
	local tmpdir

	-- FIXME: define file-related assertions here.

	setup ->
		context = Context!

		tmpdir = do
			p = io.popen "mktemp -d"
			s = p\read "*line"
			p\close!
			s

		context.outputDirectory = tmpdir
		context.cacheDirectory = tmpdir

	teardown ->
		os.execute "rm -rf '#{tmpdir}'"

	it "throws 'undefined configuration' errors", ->
		-- FIXME: Catch an error. Or test its return. Dunno.
		assert.has.errors (-> context\generate!), "tried to generate before setting configuration"

	it "generates", ->
		-- FIXME: We shouldn’t put the configuration in separate directories.
		context\importConfiguration "spec/data/example.conf"

		context\generate!

