
describe "Configuration", ->
	serviceHelpers = require "yunoconfig.service_helpers"

	Configuration = require "yunoconfig.configuration"

	SERVICE_A = Configuration.Service.register "a", serviceHelpers.Service "a", {
		serviceHelpers.Provides "a", {}
	}
	SERVICE_A_CONSUMER = Configuration.Service.register "a-consumer", serviceHelpers.Service "a-consumer", {
		serviceHelpers.Consumes "a", {}
	}

	SERVICE_B = Configuration.Service.register "b", serviceHelpers.Service "b", {
		serviceHelpers.Provides "b", {}
		serviceHelpers.Consumes "b", {
			optional: true
		}
	}

	it "basic conf", ->
		c = Configuration.fromFunction -> root {
		}

	it "", ->
		c = Configuration.fromFunction -> root {
			domain "foo", {
			}
		}

		assert.are.same "foo", c.domains[1].name

	it "\\getServiceById", ->
		c = Configuration.fromFunction ->
			root {
				service "a", {}
				domain "top", {
					service "a", {}

					domain "sub", {
						service "a", {}
					}
				}
			}

		assert.are.same c.services[1], c.domains[1].domains[1].services[1]\getServiceById "/a"
		assert.are.same c.domains[1].services[1],
			c.domains[1].domains[1].services[1]\getServiceById "top/a"

	it "", ->
		c = Configuration.fromFunction -> root {
			service "a", {}

			domain "foo", {
				service "a", {
					a: "/a"
				}
			}
		}

		assert.are.same c.domains[1].services[1], c.services[1]\getConsumers("a")[1]

