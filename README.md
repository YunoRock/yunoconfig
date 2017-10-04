
---

# DISCLAIMER

At the moment, this project is still very much a WIP.
Most of the data are there for testing and demonstration purposes.

Both tool, template and other scripts in this repository are still far from being completely ready for practical usage.
Data formats and available APIs may change at any time.

---

# Yunoconfig

This tool is designed to be a common configuration interface for dæmons or applications that depend on each other.
Its intended goal is to make administrating a server easier for non-power-users, even for servers that serve multiple domains and applications.

## How it works

Services are configured as a tree of producers and consumers of services.
A service will produce a tag that will be consumed by another.
For example: mariadb provides a tag "sql" that will be consumed by every program that needs to perform SQL operations.

Here the different steps to get the job done:

1. install the configuration tool and its dependencies (described below)
2. install the programs you need, and their configuration templates (ex: mariadb-yunorock)
3. create a configuration file that describes the interaction between services on your computer
4. generate configuration files for all your services with it
5. start your services
6. ...
7. profit!

## Dependencies

```sh
luarocks install moonscript
luarocks install etlua
luarocks install loadkit
luarocks install argparse
luarocks install luafilesystem
luarocks install lua-term
luarocks install serpent
```

## Configuration example

The configuration file (`config.cfg`) is written in Moonscript syntax.

This file describes a tree of services and domains, each of which must be named.

```moon
root {
	service "nginx", {
		-- ...
	}
	service "ssh", {
		-- ...
	}

	domain "test.example", {
		-- ...
	}
	domain "othertest.example", {
		-- ...
	}
}
```

Domains and services can (and probably should) be declared within other domains.

```moon
root {
	service "nginx", {}

	domain "test.example", {
		domain "subtest", {
			-- subtest.test.example configuration here.
		}
	}
}
```

Most services will depend on another service in one way or another.
`services print` will indicate the missing requirements.
To configure them, just add a field that has the name of the requirement in the service definition.

```moon
root {
	service nginx, {}

	domain "test.example", {
		service "some-php-app", {
			php: "/nginx"
		}
	}
}
```

The syntax that describes other services is the following: `domain/service`.
If the service is configured at the root of the tree (and therefor not in any domain), the `domain` part can simply be left blank.

## Service files

Service files are files that describe… a service.

They mostly define what tokens they provide or depend on and the code to run in order to generate the service’s configuration.

```moon
service "nginx", {
	-- Generated tokens.
	provides "http", {}
	provides "php", {}

	-- Required tokens.
	depends "http", {
		-- Not configuring a source may not be an issue if “optional”.
		optional: true

		-- What ports to request if the token is not provided.
		-- Typically, public services will use ports if not “piped” through
		-- another dæmon.
		publicPorts: {80, 443}
	}

	-- Configuration generation comes here.
	-- You may import any Lua libraries you wish, but you’ll get errors
	-- and crashes if they are missing.
	configure: =>
		os.execute "mkdir -p /etc/nginx"

		-- First parameter is the template to load. Second one is the file
		-- that will be generated using that template.
		-- Templates are .ept files (plain etlua files), usually stored next
		-- to the service files.
		@\writeTemplate "nginx", "/etc/nginx/#{@\getDomain! or "@"}-config"
}
```

## Configuration troubleshooting

A `print` command is available from the tool’s CLI.
This command prints the tree of domains and services, as well as their status and possible reason for failing.

```sh
moon services.moon print
```

Because each service requirement can be misconfigured for a different reason, they are all printed with their respective status as well.

## Actual generation

The `generate` command (from the tool’s CLI) will generate the configuration.

```sh
moon services.moon generate
```

---

# Yunorock project

Yunoconfig is part of a bigger project: Yunorock.

The goal is to help you hosting your services at home, without requiring an engineer degree.

Here what we do for you:

* abstract the configuration, configuration files are technical details
* configure complex setups with a simple tool
* … and everything is in a simple, readable text file!

> You only need to know the services you want and the interaction between them.
The general idea of your final setup and sane defaults are enough to get you started.

The project is currently tested on the Alpine Linux distribution, but every part is distribution-agnostic.

### Core system

The whole system relies on several programs:

- configuration generation and templates: yunoconfig
- packet manager: apk
- service manager: openrc
- backups: borg

That's it. Everything else is optional, and these programs could be changed if you want to (protip: you don't).
These software, including the operating system itself, were chosen based on their usability.
A good rationale is needed to change them.

### Repository

> A new repository for the Alpine Linux distribution is foreseen for this project.

__Rationale__: the project aims at providing a sane operating system, with easy-to-install services for a simple home hosting.
This includes network services (such as DNS, mail, instant messaging), and also web applications, such as blogs or wikis.
These applications are not always available in your OS repositories.
Also, they have to be configured by our configuration tool, which implies configuration templates.
Finally, to avoid negative side effects of multiple packet managers (pip, npm, …), **all dependencies** including language libraries must be provided in the same repository.

> Why the hell you want to package everything? Why is the packaging of libraries your job? Can't the developers or the bare OS do it for you?

__Rationale__: developers cannot provide packets for every OS. Simple.
If your OS wants an application, maintainers have to package it themselves.
Alpine Linux does not provide every available library, nor other Linux distributions, and it's not their job.
OS tend to provide just enough tools to get you start do whatever you want, they probably won't maintain web applications for instance.
Yunorock aims at providing ***everything*** you need for hosting your services, including the services and their updates.

Different goals, different people, different repositories, same packaging system.

> Is Docker (or FlatPak, or snap, or whatever) the real solution™?

The goal of these programs may differ, but either way you end up with a "simple to install applications" argument.

__Rationale__: first, there is no silver bullet. Don't fool yourself.
For the rest:

* Docker implies the developers to control what's going on on your system: they control the configuration, installation and provide a "somewhat usable" interface to use their applications.
Instead of giving a clear way to install things, this tool gives developers a way to push their own environment into your system.
This encourages not to care about security, good development practices and documentation.
Also, this is a hell of more complex than just starting an application.
We do not deny any positive points, but Docker is not the way we want to achieve our goal.
* Flatpak helps you follow bleeding-edge versions of applications, stability may vary.
* SNAP is like Flatpak: another packaging system in addition to your OS one.

Finally, most of the problems these applications try to solve come from bad packaging system or management.
We just don't want to support legacy systems, your OS will be updated regularly.
Do not worry about having the latest versions of your programs.

> Sane principle: rely on the fewest components. They have to be simple.
A kernel, a simple init, a simple service management that almost only keeps track of the PID of your service, services that only read their configuration files, work on few defined directories, write simple logs in text files and may have a database.
That is simplicity.

Here a table with our reasons not to use these programs:

Software | reason not to use
-------- | ----------------------------------
Docker   | complex mechanism to abstract configuration, apps managed by their developers, Linux-centric
Flatpak  | not oriented towards server applications, apps managed by their developers, Linux-centric
SNAP     | apps managed by their developers, Linux-centric

## Yunorock sane principles

> **Packet management**: every service should be installed using your operating system packaging system, so its dependencies.

__Rationale__: once you introduce new libraries, you introduce new bugs.
Every time you use a packet manager that is not the one of your operating system (such as npm, pip, cpan, …) you may install new libraries and programs, which are not tested by the maintainers of the OS.
There is ***no stability at all***. You will end with non reproducible bugs, different bugs from one system to another, and a massive headache.
Keep it simple: one operating system, one packet manager, one way to install things.

> **Learn how everything works**

__Rationale__: basic components of your system deserve your attention.
Take your time understanding your OS (packet and service managers, packet content, the different conventions, …) before trying to change it.

> **There is no rush**: building an operating system is a long process, basic blocks and tests come before new features.

__Rationale__: broken templates, or services not following conventions will end-up taking maintainers time.
So, once you want to push a new packet, you have to test it as much as possible.
Take. Your. Time. And remember to ask for help if you need it.
Hard work for the template creation = good user experience.

> **Portability should be taken into account**: write portable templates.

__Rationale__: portability helps to change OS if necessary (one day Alpine may become bloated) or to adapt our project on another OS (hello BSD guys) if people are interested in doing so.
Also, at some point we may want to manage many servers with our tool, and we do not want to require a specific OS.

---

# Packaging: PKG++

[Here the recipes of Yunorock][recipes]

### Conventions and principles

File hierarchy:

  - **/var/yunorock/domain-service**: generated configuration files
  - **/srv/yunorock/domain-service**: service data directory
  - **/usr/share/yunoconfig**: description files for yunorock services
    + /templates
  - **/etc/yunoconfig**: user configuration directory (ex: for template edition)
    + /templates
  - **/usr/share/www**: web yunorock appliances directory
  - **/run/yunorock/domain-service**: openrc runtime, dedicated yunorock files
  - **/var/cache/yunorock/domain-service**: service runtime cache
  - **/var/log/yunorock/domain-service**: service logs
  - **/var/backups/yunorock/domain-service**: backups directory

---

## Current implementation, available services

- nginx (provides: http, www, php)
- mariadb (provides: sql, mysql)
- gitea (consumes: http, sql)

## Approach limitations

Configuring services this way may imply hard to read configuration templates.
This could be circumvented in different ways, but this is not even a near problem in the current implementation.

## Future

In a near future, here the configuration file you could use:
```moon
root {

    -- HERE BEGIN THE NETWORK CONFIGURATION: IP, Firewall, DNS, DHCP, VPN, NAT

    ip: {
        addresses: { 192.0.2.1/24, 2001:db8::1/64 }
        gateway: 192.168.0.1
    }

    -- this example file is very much a work-in-progress
    -- and should only be seen as a goal in a far distant future

    -- first, let's configure the DNS
    -- nsd will build a zone file based on its user domain names, IP and mail servers
    service nsd, {}

    -- the DHCP can be processed as this
    -- unbound provides the tag "resolver" and you can add several resolvers
    service dhcpd, { 
        -- put IP addresses directly is simpler, but we want to statically
        -- check if unbound should be configured for these systems
        resolver: { "example.com/unbound", "test.example.com/unbound" }
        range: { 192.0.2.50, 192.0.2.100 }
        -- default gateway is the same as the root domain
    }

    -- radvd is a program to autoconfigure IPv6 in the LAN
    service radvd, {
        -- information here cannot be deduced from elsewhere in the configuration
        iface: "vio0"
        network: "2001:db8:0:1::/64"
    }

    service openvpn, {
        iface: "tun0"

        -- user, certificate and password are not to be generated since it is provided by the VPN service provider
        user: "me"
        cert: "/etc/openvpn/certificate.crt"
        -- this also could have been "password: 'abcdef'"
    }

    -- nat service automatically configures IP forwarding, too
    service nat, {
        iface: "/openvpn"
    }

    -- iptables service deduces ports to open and redirect from the rest of the configuration file
    service iptables, {}

    -- END OF THE NETWORK CONFIGURATION ON THE ROOT SYSTEM

    service certificate, {}

    service nginx, {}
    service mariadb, {}

    service slapd, {}

    -- here is the configuration for the host1 machine
    -- in an heterogeneous network, the configuration generation should be performed on the target host
    -- rationale: the environement (and thus directories and OS programs) may be different
    -- example: root system has apk and openrc, host1 may have apt and systemd

    domain "example.com:host1", {
        ip: {
            addresses: { 192.0.2.10/24, 2001:db8::10/64 }
            -- if not defined, default gateway is the same as the root domain
        }

        service unbound, {}

        service "some-php-app", {
                php: "/nginx"
        }

        service prosody, {
            ldap: "/slapd"
            certificate: "/certificate"
        }

        -- here is the configuration for the host2 machine
        -- same as host1, if the target system is not the same as the root system, the configuration should be generated directly on the target host
        domain "test:host2", {
            ip: {
                addresses: { 192.0.2.20/24, 2001:db8::20/64 }
                -- if not defined, default gateway is the same as the root domain
            }

            service "some-php-app", {
                    php: "/nginx"
                    sql: "/mariadb"
                    certificate: "/certificate"
            }
        }

        -- if the host is not defined, this is the same as the parent
        domain "blog", {
            service "wordpress", {
                ldap: "/slapd"
                php: "/nginx"
                sql: "/mariadb"
                certificate: "/certificate"
            }
        }

        domain "git", {
            service "gitea", {
                ldap: "/slapd"
                php: "/nginx"
                sql: "/mariadb"
                certificate: "/certificate"
            }
        }
    }
}
```

[recipes]: https://github.com/YunoRock/yunorock-recipes
