# shellcheck disable=SC2148,SC2215,SC2168,SC2154
name: switch
alias: s
help: Switch the default version of PHP selected
args:
- name: php
  required: true
  help: PHP version to use as default
  allowed: ["5.6", "7.3", "7.4", "8.0", "8.1"]

examples:
- zphp switch 8.1
---
local php="${args[php]}"
local config_dir

config_dir="$(dirname "${CONFIG_FILE}")"
if [[ ! -d "${config_dir}" ]]; then
    green "Creating config directory ${config_dir}..."
    mkdir -p "${config_dir}"
fi

config_set "default" "${php}"
green "Set default PHP version to ${php}"
