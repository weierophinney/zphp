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
