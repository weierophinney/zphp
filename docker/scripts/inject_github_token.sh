#!/bin/bash

set -e

if [[ $# -lt 2 ]]; then
    exit 0;
fi

user=$1
token=$2

if [[ -z $user || -z $token ]]; then
    exit 0;
fi

mkdir -p "${HOME}/.config/git"

printf "[github]\n    user = %s\n    token = %s\n" "${user}" "${token}" >> "${HOME}/.config/git/config"
