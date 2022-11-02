#!make
########################## Variables #####################
HERE := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
##########################################################

##### Makefile related #####
.PHONY: 

default: help

##@ Help

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[0-9a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-40s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Build PHP images

php81: ## Build PHP 8.1 container
	@printf "\n\033[92mBuilding PHP 8.1 image...\033[0m\n"
	docker buildx build -f php-8.1.Dockerfile -o type=docker -t "zendphp:8.1" --no-cache .
	@printf "\n\033[92m[DONE]\033[0m\n"
