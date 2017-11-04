
package=yunoconfig
version=0.1

variables=(LUA_VERSION 5.1)

targets=(yunoconfig.moon)

type[yunoconfig.moon]="script"
sources[yunoconfig.moon]="yunoconfig.moon.in"
filename[yunoconfig.moon]="yunoconfig"

for i in yunoconfig/**/*.moon; do
	targets+=($i)
	type[$i]="script"
	install[$i]='$(SHAREDIR)/lua/$(LUA_VERSION)/'"${i%/*}"
	auto[$i]=true # Hidden from `make help`
done

for i in data/*.moon; do
	targets+=($i)
	type[$i]="script"
	install[$i]='$(SHAREDIR)/yunoconfig'
	auto[$i]=true # Hidden from `make help`
done

for i in data/templates/*.ept; do
	targets+=($i)
	type[$i]="script"
	install[$i]='$(SHAREDIR)/yunoconfig/templates'
	auto[$i]=true # Hidden from `make help`
done

for i in doc/*.[0-9].md; do
	targets+=(${i%.md})
	type[${i%.md}]="man"
	sources[${i%.md}]="${i}"
done

dist=(
	# Code
	yunoconfig/**/*.moon
	data/**/*.moon
	data/templates/**/*.ept
	# Build system.
	project.zsh Makefile
	# Documentation
	README.md
)


