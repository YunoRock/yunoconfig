
lfs = require "lfs"

service "certificates", {
	provides "certificate", {}

	generateCertificate: (domain) =>
		out = @context.outputDirectory

		domainName = domain\getDomainName!

		unless domainName
			return

		basedir = "/etc/yunorock/ssl"

		@\createDirectory basedir

		privkey = "#{basedir}/#{domainName}.key"
		pubkey = "#{basedir}/#{domainName}.pub"
		csr = "#{basedir}/#{domainName}.csr"
		certificate = "#{basedir}/#{domainName}.cert"

		unless lfs.attributes "#{out}#{privkey}"
			@\message "Generating private key..."
			os.execute "openssl genrsa -out '#{out}#{privkey}' 4096"

		unless lfs.attributes "#{out}#{pubkey}"
			@\message "Generating public key..."
			os.execute "openssl rsa -in '#{out}#{privkey}' -pubout -out '#{out}#{pubkey}'"

		unless lfs.attributes "#{out}#{csr}"
			-- FIXME: Store the ACTUAL configuration when doing the setup-* madness. And reuse it. Citylol doez not exist, bro
			os.execute "openssl req -new -key '#{out}#{privkey}' -out '#{out}#{csr}' -subj '/C=FR/ST=NTM/L=Citylol/O=Yunorock/OU=Administrator/CN=#{domainName}/emailAddress=root@#{domainName}'"

		unless lfs.attributes "#{out}#{certificate}"
			os.execute "openssl x509 -req -days 365 -in '#{out}#{csr}' -signkey '#{out}#{privkey}' -out '#{out}#{certificate}'"
}

