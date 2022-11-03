# shellcheck disable=SC2148,SC2215,SC2168,SC2154
name: run
alias: r
help: Run the PHP binary or a PHP script
dependencies:
- docker

flags:
- long: --php
  arg: php
  required: false
  allowed: ["AUTO", "5.6", "7.3", "7.4", "8.0", "8.1"]
  default: AUTO
  help: |-
        PHP version to use. If not provided, uses the default.
- long: --expose-port
  arg: port
  required: false
  help: |-
        A port for the container to expose. Use this option if you are
        starting a web server -- e.g. using the -S option, or starting an
        async server via Mezzio or ReactPHP -- or your script will listen
        on a socket. The argument should be provided in a format that
        "docker run --publish" supports.

catch_all: 
  label: arguments
  help: Arguments to pass to the PHP binary
  required: true

examples:
- zphp run -v
- zphp run -m
- zphp run -a
- zphp run vendor/bin/laminas
- zphp run --php 8.1 -v
- zphp run --php 5.6 -m
- zphp run --php 7.3 -a
- zphp run --php 8.0 vendor/bin/laminas
---
local php

if [[ "${args[--php]}" == "AUTO" ]]; then
    if ! config_has_key "default"; then
        red "You do not have a default PHP version set yet!"
        exit 1
    fi
    php=$(config_get "default")
else
    php="${args[--php]}"
fi

if [[ -n "${args[--expose-port]}" ]]; then
    docker run -it --rm -v "$(pwd):/app" -w /app -p "${args[--expose-port]}" "zendphp:${php}" "${other_args[@]}"
else
    docker run -it --rm -v "$(pwd):/app" -w /app "zendphp:${php}" "${other_args[@]}"
fi
