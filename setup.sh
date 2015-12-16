#!/bin/bash

set -eo pipefail

PROJECT_NAME="AnsibleScratch"
PROJECT_OWNER="GiorgioRegni"

function supress() {
  eval $1 > /dev/null 2>&1
}

function ubuntu_14_install() {
  echo "...running on Ubuntu 14.04"
  echo "...verifying pip install"
  supress "sudo apt-get install git python-dev python-setuptools python-pip -y"
  echo "...verifying pip dependencies"
  supress "sudo pip install paramiko PyYAML Jinja2 httplib2 six"
}

function cent_7_install() {
  echo "...running on CentOS 7"
  echo "...verifying pip install"
  supress "rpm -iUvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm"
  supress "yum install git python-pip python-crypto -y"
  echo "...verifying pip dependencies"
  supress "pip install paramiko PyYAML Jinja2 httplib2 six"
}

function project_source() {
  if [ -d ~/$PROJECT_NAME ]; then
    echo "...$PROJECT_NAME source present; updating"
    supress "cd ~/$PROJECT_NAME && git pull --rebase"
  else
    echo "...cloning $PROJECT_NAME"
    supress "git clone https://github.com/$PROJECT_OWNER/$PROJECT_NAME.git"
  fi
}

function ansible_source() {
  if [ -d ~/$PROJECT_NAME/.ansible ]; then
    echo "...Ansible source present; updating"
    supress "cd ~/$PROJECT_NAME/.ansible && git pull --rebase"
    supress "cd ~/$PROJECT_NAME/.ansible && git submodule update --init --recursive"
  else
    echo "...cloning Ansible source"
    supress "git clone https://github.com/ansible/ansible.git ~/$PROJECT_NAME/.ansible"
    supress "cd ~/$PROJECT_NAME/.ansible/ && git submodule update --init --recursive"
  fi
}

# NOTE: Heredoc indent is inconsistent because of Bash conventions.
function next_steps() {
  cat << NEXT_STEPS
  Next Steps:
    * Configure your shell environment by running "source ~/AnsibleScratch/env_config.sh"
    * Create an Ansible inventory file at ~/AnsibleScratch/ansible_hosts to suit your network environment.

    Examples:
      ansible_hosts file:'
        [storage]'
        node1 ansible_user=ubuntu ansible_host=192.168.0.13 base_os=ubuntu14
        node2 ansible_user=root   ansible_host=192.168.0.15 base_os=cent7
      To get all storage nodes to runlevel 0:
        $ ansible-playbook ~/AnsibleScratch/playbooks/runlevel_0.yml

  Refer to the AnsibleScratch README, as well as the Ansible documentation, for more details.
NEXT_STEPS
}

function main() {
  echo "Starting $PROJECT_NAME setup..."
  if [ `python -mplatform | grep Ubuntu-14.04` ]; then
    ubuntu_14_install
  elif [ `python -mplatform | grep centos-7` ]; then
    cent_7_install
  fi
  project_source
  ansible_source
  echo "...Done!"
  next_steps
}

main "$@"
