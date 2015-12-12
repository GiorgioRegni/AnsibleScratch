#!/bin/bash

PROJECT_NAME="AnsibleScratch"
PROJECT_OWNER="GiorgioRegni"

function ansible_source {
  if [ -d ~/ansible ]; then
    echo "ANSIBLE ALREADY CLONED. UPDATING..."
    cd ~/.ansible && git pull --rebase && git submodule update --init --recursive && cd ~/
  else
    echo "CLONING ANSIBLE SOURCE..."
    git clone https://github.com/ansible/ansible.git --recursive ~/.ansible
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

if [ `python -mplatform | grep Ubuntu-14.04` ]; then
  echo "RUNNING ON UBUNTU 14.04..."
  echo "VERIFYING APT DEPENDENCIES..."
  sudo apt-get install git python-dev python-setuptools -y
  ansible_source
  echo "VERIFYING PIP INSTALL..."
  sudo easy_install pip -y
  echo "VERIFYING PIP DEPENDENCIES..."
  sudo pip install paramiko PyYAML Jinja2 httplib2 six
  project_source
elif [ `python -mplatform | grep centos-7` ]; then
  echo "RUNNING ON CENTOS 7..."
  echo "ENABLING EPEL..."
  rpm -iUvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
  echo "VERIFYING YUM DEPENDENCIES..."
  yum install git python-pip python-crypto -y
  ansible_source
  echo "VERIFYING PIP DEPENDENCIES..."
  pip install paramiko PyYAML Jinja2 httplib2 six
  project_source
fi

echo '...DONE!'
echo ''
echo 'Next Steps:'
echo '  * Configure your shell environment by running "source ~/AnsibleScratch/env_config.sh"'
echo '  * Create an Ansible inventory file at ~/AnsibleScratch/ansible_hosts to suit your network environment.'
echo ''
echo '  Examples:'
echo '    ansible_hosts file:'
echo '      [storage]'
echo '      node1 ansible_user=ubuntu ansible_host=192.168.0.13 base_os=ubuntu14'
echo '      node2 ansible_user=root   ansible_host=192.168.0.15 base_os=cent7'
echo '    To get all storage nodes to runlevel 0:'
echo '      $ ansible-playbook ~/AnsibleScratch/playbooks/runlevel_0.yml'
echo ''
echo 'Refer to the AnsibleScratch README, as well as the Ansible documentation, for more details.'
