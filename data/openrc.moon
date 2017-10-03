
service "openrc", {
	configure: (context, service, data) =>
		destination = "etc/init.d/services-#{service\getDomainName! or '@'}.#{service.name}"

		service\writeTemplate "openrc", destination, {
			:data
			:service
		}

		os.execute "chmod +x '#{context.outputDirectory}'/#{destination}"

		service\createDirectory "/run/yunorock", nobackup: true
}


