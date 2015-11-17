# Welcome to AnsibleScratch!

## Ansible Setup

**NOTE**: Assumes that the local user's SSH key is authorized on `your_remote_host`.

### Shell Script

SCP `setup.sh` to the home directory of the admin user (needs passwordless sudo) or the root user, then: `./setup.sh`.

### Manual

**NOTE**: This is taken from the [Ansible source installation documentation](http://docs.ansible.com/ansible/intro_installation.html#running-from-source) and tested on Ubuntu 14.04. Refer back to the documentation if you run into issues.

#### Ubuntu 14.04

##### Clone Ansible

```bash
$ git clone git://github.com/ansible/ansible.git --recursive
$ cd ./ansible
$ source ./hacking/env-setup -q # It's a good idea to add this to your ~/.bashrc.
```

##### Install `pip` and Python Modules

```bash
$ sudo apt-get install python-dev python-setuptools
$ sudo easy_install pip
$ sudo pip install paramiko PyYAML Jinja2 httplib2 six
```

##### Configure Local Ansible Hosts File

```bash
$ export ANSIBLE_INVENTORY=~/ansible_hosts # Another good thing to keep in your ~/.bashrc.
```

##### Ansible Hosts Template

Make sure your hosts are listed properly in `~/ansible_hosts`. Take a look at the excellent Ansible [inventory file documentation](http://docs.ansible.com/ansible/intro_inventory.html) for details.

##### Updating Ansible

```bash
$ cd ~/path/to/your/checkout/ansible/
$ git pull --rebase
$ git submodule update --init --recursive
```

### Verify Ansible is Installed Properly


```bash
$ ansible localhost -m ping
```

#### Expected Result:
>>```bash
your_remote_host | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```
