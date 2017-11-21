#!/usr/bin/make
MAKEFLAGS += --silent
SHELL := /bin/bash
$(shell if [ ! -f .env ]; then touch .env; fi)
include .env

# This will read the environment variables defined in .env
# and import them into Make.
export $(shell sed 's/=.*//' .env)

REQUIRED_ENV_VARS = ARM_SUBSCRIPTION_ID \
										ARM_CLIENT_ID \
										ARM_CLIENT_SECRET \
										ARM_TENANT_ID \
										ARM_ENVIRONMENT
DOCKER_BASE_ENV_VARS = -e ARM_SUBSCRIPTION_ID=$(ARM_SUBSCRIPTION_ID) \
											 -e ARM_CLIENT_ID=$(ARM_CLIENT_ID) \
											 -e ARM_CLIENT_SECRET=$(ARM_CLIENT_SECRET) \
											 -e ARM_TENANT_ID=$(ARM_TENANT_ID) \
											 -e ARM_ENVIRONMENT=$(ARM_ENVIRONMENT) \
											 -e ARM_RESOURCE_GROUP=$(ARM_RESOURCE_GROUP)

.PHONY: init lint plan apply test

init:
	for var in $(REQUIRED_ENV_VARS); do \
		if [ -z "$${!var+x}" ]; \
		then \
			echo -e "ERROR: $$var is not defined. Please define it." >&2; \
			exit 1; \
		fi; \
	done;
	
lint: init packer_lint

build: init lint plan packer_build

.PHONY: packer_init packer_build

packer_init: do_packer_init

packer_lint: DOCKER_ARGS=rabbitmq-node/rhel-rabbitmq-x86_64.json
packer_lint: do_packer_validate

packer_lint: DOCKER_ARGS=rabbitmq-node/rhel-rabbitmq-x86_64.json
packer_build: do_packer_build

.PHONY: do_packer_%

do_packer_%:
	action=$$(echo "$@" | rev | cut -f1 -d '_' | rev); \
	docker run -it -v $$PWD:/work -w /work $(DOCKER_BASE_ENV_VARS) $(DOCKER_ENV_VARS) \
		hashicorp/packer $$action $(DOCKER_ARGS)
