#!make
##################### Variables ##########################
HERE := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
# List of LTS versions we can build
LTS = 5.6 7.3
# Use bash as the shell (gives us better conditionals)
SHELL = /bin/bash
##########################################################

####################### Colors ###########################
# These can be used inside of strings passed to printf
BLUE="\\033[34m"
GREEN="\\033[32m"
RED="\\033[31m"
# Closing sequence
END="\\033[0m"
##########################################################

###################### Conditions ########################
# If a .env file is present, include it and export all
# env variables it contains
ifneq (,$(wildcard ./.env))
	include .env
	export
endif
##########################################################

##### Makefile related #####
.PHONY: 

default: help

cmd-exists-%:
	@hash $(*) > /dev/null 2>&1 || \
		(printf "$(RED)ERROR:$(END) '$(*)' must be installed and available on your PATH.\n"; exit 1)

##@ Help

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\n\033[1mUsage:\033[0m\n  make \033[32m<target>\033[0m\n"} /^[0-9a-zA-Z_-]+:.*?##/ { printf "  \033[32m%-40s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
	@printf "  $(GREEN)%-40s$(END)  Build a specific PHP version\n" "php-*"

##@ Build PHP images

php-%: cmd-exists-docker  ## Build PHP container, where % is a PHP version
	@if [[ ! -f "docker/php-$(*).Dockerfile" ]]; then printf "$(RED)Unknown/unsupported PHP version$(END)\n" ; exit 1; fi
	@if [[ " $(LTS) " == *"$(*)"* ]]; then \
			if [[ ! -f .env ]]; then printf "$(RED)ERROR: Missing .env file with credentials$(END)\n" ; exit 1 ; fi ; \
			printf "$(GREEN)Building PHP $(*) image...$(END)\n" ; \
			docker buildx build -f "docker/php-$(*).Dockerfile" -o type=docker -t "zendphp:$(*)" --build-arg "ZENDPHP_REPO_USERNAME=${ZENDPHP_REPO_USERNAME}" --build-arg "ZENDPHP_REPO_PASSWORD=${ZENDPHP_REPO_PASSWORD}" --no-cache . ; \
		else \
			printf "$(GREEN)Building PHP $(*) image...$(END)\n" ; \
			docker buildx build -f "docker/php-$(*).Dockerfile" -o type=docker -t "zendphp:$(*)" --no-cache . ; \
		fi
	@printf "\n$(GREEN)[DONE]$(END)\n"
	@printf "$(GREEN)Built zendphp:$(*)$(END)\n"

all: php-8.1 php-8.0 php-7.4 php-7.3 php-5.6  ## Build all containers
