# shellcheck disable=SC2148,SC2215,SC2168
name: composer
alias: c
help: Run a composer command using the given PHP version

flags:
- long: --php
  arg: php
  required: false
  allowed: ["AUTO", "5.6", "7.3", "7.4", "8.0", "8.1"]
  default: AUTO
  help: |-
        PHP version to use. If not provided, uses the default.

catch_all: 
  label: arguments
  help: Arguments to pass to the PHP binary
  required: true

examples:
- zphp composer
- zphp composer install
- zphp composer update
- zphp composer --php 8.1
- zphp composer --php 7.4 install
- zphp composer --php 5.6 update
---
local php

# shellcheck disable=2154
if [[ "${args[--php]}" == "AUTO" ]]; then
    if ! config_has_key "default"; then
        red "You do not have a default PHP version set yet!"
        exit 1
    fi
    php=$(config_get "default")
else
    php="${args[--php]}"
fi

# shellcheck disable=2154
docker run -it --rm -v "$(pwd):/app" -w /app --entrypoint /usr/local/sbin/composer "zendphp:${php}" "${other_args[@]}"
