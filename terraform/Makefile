#!/usr/bin/make
MAKEFLAGS += --silent
SHELL := /bin/bash
$(shell if [ ! -f .env ]; then touch .env; fi)
include .env
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
											 -e ARM_ENVIRONMENT=$(ARM_ENVIRONMENT)

.PHONY: init lint plan apply test

init:
	for var in $(REQUIRED_ENV_VARS); do \
		if [ -z "$${!var+x}" ]; \
		then \
			echo -e "ERROR: $$var is not defined. Please define it." >&2; \
			exit 1; \
		fi; \
	done;
	if [ ! -f 'terraform.tfvars' ]; \
	then \
		echo -e "ERROR: terraform.tfvars is missing. Please create it." >&2; \
		exit 1; \
	fi; \
	
lint: init terraform_lint

plan: init terraform_plan

apply: init lint plan terraform_apply

.PHONY: terraform_init terraform_get terraform_plan terraform_apply

terraform_init: do_terraform_init

terraform_lint: do_terraform_validate

terraform_get: do_terraform_get

terraform_plan: do_terraform_plan

terraform_apply: do_terraform_apply

terraform_destroy: do_terraform_destroy

.PHONY: do_terraform_%

do_terraform_%:
	action=$$(echo "$@" | rev | cut -f1 -d '_' | rev); \
	docker run -it -v $$PWD:/work -w /work $(DOCKER_BASE_ENV_VARS) $(DOCKER_ENV_VARS) \
		hashicorp/terraform $$action $(DOCKER_ARGS)
