#!/bin/bash

PROJECT_NAME="AnsibleScratch"
PROJECT_OWNER="GiorgioRegni"

function ansible_source {
  if [ -d ~/ansible ]; then
    echo "ANSIBLE ALREADY CLONED. UPDATING..."
    cd ~/ansible && git pull --rebase && git submodule update --init --recursive && cd ~/
  else
    echo "CLONING ANSIBLE SOURCE..."
    git clone https://github.com/ansible/ansible.git --recursive
  fi
}

function bash_config {
  if [ `grep -q "profile" ~/.bashrc && echo $?` ]; then
    echo "BASH ALREADY CONFIGURED..."
  else
    echo "CONFIGURING BASH..."
    echo -e "source ~/.profile" >> ~/.bashrc
  fi
}

function env_config {
  if [ `grep -q "hacking" ~/.profile && echo $?` ]; then
    echo "ENVIRONMENT ALREADY CONFIGURED..."
  else
    echo "CONFIGURING ENVIRONMENT..."
    echo -e "source ~/ansible/hacking/env-setup -q" >> ~/.profile
  fi
  if [ `grep -q "ANSIBLE_CONFIG" ~/.profile && echo $?` ]; then
    echo "ANSIBLE ALREADY CONFIGURED..."
  else
    echo "CONFIGURING ANSIBLE..."
    echo -e "export ANSIBLE_CONFIG=~/$PROJECT_NAME/ansible.cfg" >> ~/.profile
  fi
  if [ `grep -q "ANSIBLE_INVENTORY" ~/.profile && echo $?` ]; then
    echo "INVENTORY ALREADY SET..."
  else
    echo "SETTING INVENTORY..."
    echo -e "export ANSIBLE_INVENTORY=~/$PROJECT_NAME/ansible_hosts" >> ~/.profile
  fi
}

function project_source {
  if [ -d ~/$PROJECT_NAME ]; then
    echo "$PROJECT_NAME ALREADY CLONED. UPDATING..."
    cd ~/$PROJECT_NAME && git pull --rebase && cd ~/
  else
    echo "CLONING $PROJECT_NAME SOURCE..."
    git clone https://github.com/$PROJECT_OWNER/$PROJECT_NAME.git
  fi
}

function ssh_config {
  if [ `grep -q "github.com" ~/.ssh/config && echo $?` ]; then
    echo "SSH CLIENT ALREADY CONFIGURED..."
  else
    echo "CONFIGURING LOCAL SSH CLIENT..."
    touch ~/.ssh/config
    echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config
  fi
}

if [ `python -mplatform | grep Ubuntu-14.04` ]; then
  echo "RUNNING ON UBUNTU 14.04..."
  echo "VERIFYING APT DEPENDENCIES..."
  sudo apt-get install git python-dev python-setuptools -y
  ssh_config
  ansible_source
  echo "VERIFYING PIP INSTALL..."
  sudo easy_install pip -y
  echo "VERIFYING PIP DEPENDENCIES..."
  sudo pip install paramiko PyYAML Jinja2 httplib2 six
  project_source
  env_config
elif [ `python -mplatform | grep centos-7` ]; then
  echo "RUNNING ON CENTOS 7..."
  echo "ENABLING EPEL..."
  rpm -iUvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
  echo "VERIFYING YUM DEPENDENCIES..."
  yum install git python-pip python-crypto -y
  ssh_config
  ansible_source
  echo "VERIFYING PIP DEPENDENCIES..."
  pip install paramiko PyYAML Jinja2 httplib2 six
  project_source
  env_config
  bash_config
fi

echo '...DONE! PLEASE RELOAD PROFILE, "source ~/.profile".'
