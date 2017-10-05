
---

# DISCLAIMER

At the moment, this project is still very much a WIP.
Most of the data are there for testing and demonstration purposes.

Both tool, template and other scripts in this repository are still far from being completely ready for practical usage.
Data formats and available APIs may change at any time.

If you are interested in Yunorock, the operating system, [check this][yunorock].

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
moon yunoconf.moon print
```

Because each service requirement can be misconfigured for a different reason, they are all printed with their respective status as well.

## Actual generation

The `generate` command (from the tool’s CLI) will generate the configuration.

```sh
moon yunoconf.moon generate
```

[yunorock]: https://github.com/YunoRock/yunorock-doc
