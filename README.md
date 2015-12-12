# Welcome to AnsibleScratch!

## Ansible Setup

**NOTE**: Assumes that the local user's SSH key is authorized on `your_remote_host`.

### Shell Script

**NOTE**: The shell script supports Ubuntu Server 14.04 LTS and CentOS 7.

SCP `setup.sh` to the home directory of the admin user (needs passwordless sudo) or the root user, then: `./setup.sh`.

### Manual

**NOTE**: This is taken from the [Ansible source installation documentation](http://docs.ansible.com/ansible/intro_installation.html#running-from-source). Refer back to the documentation if you run into issues.

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

```bash
your_remote_host | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

## [Ansible Hosts](http://docs.ansible.com/ansible/intro_inventory.html)

To use this project, you **must** write a host file for Ansible to use stored in the project's root directory (assuming Ansible was installed/setup using the Bash script.). Note that hosts can be listed in more than one group, and that variables for a given host will be pulled from all groups. This file is ignored by Git because it is environment-dependent, but here is an example:

```bash
[storage]
node1 ansible_user=ubuntu ansible_host=192.168.0.13 base_os=ubuntu14
node2 ansible_user=root   ansible_host=192.168.0.15 base_os=cent7
```

**NOTE**: The Ansible configuration specified by this project expects the inventory to be configured in `AnsibleScratch/ansible_hosts`.

### Host Groups

#### `docker`

These are the hosts that will be running Docker, which will probably be at least most hosts.

#### The `base_os` Variable

In order to support multiple operating systems, each host in the Ansile hosts file **must** have a value set for the base OS variable. Exaples:

* Ubuntu Server 14.04 LTS: `ubuntu14`
* CentOS 7: `cent7`

#### `logstash`

These are hosts running Docker that will also be running [Logstash](https://hub.docker.com/r/pblittle/docker-logstash/) containers.
