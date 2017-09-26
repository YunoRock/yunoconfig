
service "openrc", {
	configure: (context, service, data) =>
		service\writeTemplate "openrc",
			"etc/init.d/services-#{service\getDomainName! or '@'}.#{service.name}",
			{
				:data
				:service
			}
}


