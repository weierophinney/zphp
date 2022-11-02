#!make
########################## Variables #####################
HERE := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
##########################################################

ifneq (,$(wildcard ./.env))
	include .env
	export
endif

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

php80: ## Build PHP 8.0 container
	@printf "\n\033[92mBuilding PHP 8.0 image...\033[0m\n"
	docker buildx build -f php-8.0.Dockerfile -o type=docker -t "zendphp:8.0" --no-cache .
	@printf "\n\033[92m[DONE]\033[0m\n"

php74: ## Build PHP 7.4 container
	@printf "\n\033[92mBuilding PHP 7.4 image...\033[0m\n"
	docker buildx build -f php-7.4.Dockerfile -o type=docker -t "zendphp:7.4" --no-cache .
	@printf "\n\033[92m[DONE]\033[0m\n"

php73: .env  ## Build PHP 7.3 container
	@printf "\n\033[92mBuilding PHP 7.3 image...\033[0m\n"
	docker buildx build -f php-7.3.Dockerfile -o type=docker -t "zendphp:7.3" --build-arg "ZENDPHP_REPO_USERNAME=${ZENDPHP_REPO_USERNAME}" --build-arg "ZENDPHP_REPO_PASSWORD=${ZENDPHP_REPO_PASSWORD}" --no-cache .
	@printf "\n\033[92m[DONE]\033[0m\n"

php56: .env  ## Build PHP 5.6 container
	@printf "\n\033[92mBuilding PHP 5.6 image...\033[0m\n"
	docker buildx build -f php-5.6.Dockerfile -o type=docker -t "zendphp:5.6" --build-arg "ZENDPHP_REPO_USERNAME=${ZENDPHP_REPO_USERNAME}" --build-arg "ZENDPHP_REPO_PASSWORD=${ZENDPHP_REPO_PASSWORD}" --no-cache .
	@printf "\n\033[92m[DONE]\033[0m\n"

all: php81 php80 php74 php73 php56  ## Build all containers
