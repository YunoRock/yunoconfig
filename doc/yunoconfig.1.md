% YUNOCONFIG(1) 2017-11-04 | YunoRock User Manuals

# NAME

yunoconfig - generate interdependent application configuration

# SYNOPSIS

yunoconfig [OPTIONS] <COMMAND>

# DESCRIPTION

yunoconfig generate is a tool that generates configuration files for a wide array of services or applications.
The generated configuration is immediately runnable and the configured services should be able to depend on each other as well.

# COMMANDS

## yunoconfig print

Prints the current configuration.

Misconfigured services are displayed as well as the reason they are considered to be misconfigured.

The requested resources (ie. port numbers, tokens, ...) are also displayed in `print`.

## yunoconfig generate

Generates the configuration files for all services.

## yunoconfig print-services

Prints the services yunoconfig knows about.
Those services can safely be added to the configuration.

# OPTIONS

-r *DIRECTORY*, \--root *DIRECTORY*

:	Changes the directory in which the new configuration will be generated.

	Use this if you want to test your configuration before deploying it.

-C *DIRECTORY*, \--cache *DIRECTORY*

:	Sets the directory in which the cache is stored.

-c *FILE*, \--config *FILE*

:	Sets the file from which to import the system’s configuration.

-S *DIRECTORY*, \--services-dir *DIRECTORY*

:	Sets the directory from which the definitions of services will be imported.

	Services are currently loaded from a single source, and setting this arbitrarily can lead to crashes on an otherwise correct configuration.

# EXIT STATUS

0

:	Successful program execution.

Other values

:	An unexpected error occured while importing service definition, importing configuration, or generating configuration files.

# FILES

/etc/yunoconfig.cfg

:	Centralized configuration file.

	The configuration of all services is defined here.

# SEE ALSO

`yunoconfig.cfg` (5).

# HISTORY

