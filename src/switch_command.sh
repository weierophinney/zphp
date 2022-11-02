local php="${args[php]}"
local config_dir

config_dir="$(dirname "${CONFIG_FILE}")"
if [[ ! -d "${config_dir}" ]]; then
    green "Creating config directory ${config_dir}..."
    mkdir -p "${config_dir}"
fi

config_set "default" "${php}"
green "Set default PHP version to ${php}"
