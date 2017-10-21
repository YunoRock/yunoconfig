
service "openrc", {
	generate: (context, service, data) =>
		destination = "etc/init.d/yunorock.#{service\getDomainName! or '@'}.#{service.name}"

		parseSignal = (string) ->
			if string\match "^signal:"
				"start-stop-daemon --signal #{string\gsub "^signal:", ""} --pidfile $pidfile"
			else
				string

		startStopDaemonArguments = {}
		if data.logStdout
			table.insert startStopDaemonArguments, "--stdout"
			table.insert startStopDaemonArguments, "/var/log/yunorock.#{service.name}.#{service\getDomainName! or "@"}.log"

		if data.logStderr
			table.insert startStopDaemonArguments, "--stderr"
			table.insert startStopDaemonArguments, "/var/log/yunorock.#{service.name}.#{service\getDomainName! or "@"}.err"

		if data.commandUser
			table.insert startStopDaemonArguments, "--user"
			table.insert startStopDaemonArguments, data.commandUser

		if data.commandEnvironment
			table.insert startStopDaemonArguments, "--env"
			table.insert startStopDaemonArguments, data.commandEnvironment

		if data.commandDirectory
			table.insert startStopDaemonArguments, "--chdir"
			table.insert startStopDaemonArguments, data.commandDirectory

		startStopDaemonArguments = table.concat startStopDaemonArguments, " "

		service\writeTemplate "openrc", destination, {
			:data
			:service

			-- Basic definition.
			command: data.command
			commandArguments: data.commandArguments

			-- OpenRC specific values.
			pidfile: data.pidfile or "/run/yunorock/#{service\getDomainName! or "@"}.#{service.name}.pid"
			:startStopDaemonArguments

			-- Dependencies
			use: data.use
			need: data.need
			after: data.after
			before: data.before

			-- Dæmons behavior description.
			-- Well written daemons don’t background themselves.
			needsBackground: data.needsBackground or true

			-- Options.
			reload: data.reload and parseSignal(data.reload) or nil
		}

		os.execute "chmod +x '#{context.outputDirectory}'/#{destination}"

		service\createDirectory "/run/yunorock", nobackup: true
}


