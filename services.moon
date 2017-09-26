
argparse = require "argparse"

Context = require "services.context"

arg = do
	parser = with argparse "services", "Centralized configuiration management tool."
		\command "print",    "Prints the current configuration tree."
		\command "generate", "Generates the configuration files for all the registered services."
		\command "print-services", "Prints a list of available and configurable services."

		with \option "-r --root",  "Sets the root of the configuration tree.", "/"
			\count 1
		with \option "-c --cache", "Sets the path to the cache used to generate the configuration.", "/var/cache/services"
			\count 1
		with \option "-S --services-dir", "Sets the path to the directory containing the service definition files.", "/usr/share/services"
			\count 1

	parser\parse!

with Context!
	.outputDirectory = arg.root
	.cacheDirectory = arg.cache
	.servicesDirectory = arg.services_dir

	\importServices!

	if arg["print-services"]
		for service in *.definedServices
			print service
		os.exit 0

	\importConfiguration!

	if arg.print
		\print!
	elseif arg.generate
		\generate!

