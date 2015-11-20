#!/bin/bash

PROJECT_NAME="AnsibleScratch"

source ~/ansible/hacking/env-setup -q
export ANSIBLE_CONFIG=~/$PROJECT_NAME/config/ansible.cfg
export ANSIBLE_INVENTORY=~/$PROJECT_NAME/ansible_hosts
