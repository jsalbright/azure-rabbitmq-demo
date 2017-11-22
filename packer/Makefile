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

.PHONY: init generate_version_number lint build

init:
	for var in $(REQUIRED_ENV_VARS); do \
		if [ -z "$${!var+x}" ]; \
		then \
			echo -e "ERROR: $$var is not defined. Please define it." >&2; \
			exit 1; \
		fi; \
	done;

generate_version_number:
	if [ ! -f .build_number ]; \
	then \
		echo 1 > .build_number; \
	else \
		last_build_number=$$(cat .build_number); \
		echo $$((last_build_number+1)) > .build_number; \
	fi;
	
lint: init packer_lint

build: init lint generate_version_number packer_build

.PHONY: packer_init packer_build

packer_init: do_packer_init

packer_lint: DOCKER_ARGS=rabbitmq-node/rhel-rabbitmq-x86_64.json
packer_lint: do_packer_validate

packer_build: DOCKER_ARGS=rabbitmq-node/rhel-rabbitmq-x86_64.json
packer_build: ADDITIONAL_DOCKER_ENV_VARS=-e IMAGE_VERSION=$(shell cat .build_number)
packer_build: do_packer_build

.PHONY: do_packer_%

do_packer_%:
	action=$$(echo "$@" | rev | cut -f1 -d '_' | rev); \
	this_image_version=$$(cat .build_number); \
	if [ "$$action" == "build" ]; \
	then \
		echo "INFO: Building version $$this_image_version of rhel-rabbitmq-x86_64 image."; \
	else \
		echo "INFO: Running Packer action: $$action"; \
	fi; \
	docker run -it -v $$PWD:/work -w /work $(DOCKER_BASE_ENV_VARS) $(ADDITIONAL_DOCKER_ENV_VARS) \
		hashicorp/packer $$action $(DOCKER_ARGS)
