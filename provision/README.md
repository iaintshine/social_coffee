# Provision 

Ansible playbook for deploying Social Coffee Thrift server on a Virtual Machine using Vagrant. 

What gets installed:

* Common packages i.e. fail2ban, unattended-upgrades, logwatch, checkrootkit etc ... (see 'common' role)
* Python, Pip and VirtualEnv
* Supervisord
* Redis master server
* Redis commander - redis dashboard
* Node.js
* The latest version of Social Coffee server

## Requirements 

1. Install sshpass (OSX Mavericks or above). This step is required only if you are going to use `mkpasswd` python utility. 
    
        $ cd ~/Downloads
        $ curl -O -L http://downloads.sourceforge.net/project/sshpass/sshpass/1.05/sshpass-1.05.tar.gz
        $ tar xvzf sshpass-1.05.tar.gz
        $ cd sshpass-1.05
        $ ./configure
        $ make
        $ sudo make install

2. Install [Oracle VirtualBox](https://www.virtualbox.org/wiki/Downloads). Required by Vagrant.
3. Install [Vagrant](https://www.vagrantup.com/downloads)
4. Install Ansible
    
        $ pip install ansible 

5. If you are running local development mode using vagrant execute `scripts/bootstrap` python script to prepare your local environment

        $ sudo scripts/bootstrap

6. If you are going to use `mkpasswd` python utility, please ensure that the Passlib password hashing library is installed. Exceute:

        $ pip install passlib

## Installation

Create and configure local virtual machines using vagrant

    $ vagrant up

Run for **the first time** (user 'deploy' doesn't exist) and bootstrap the os common configuration
    
    $ ansible-playbook -i development site.yml --user vagrant --private-key=~/.vagrant.d/insecure_private_key --sudo --tags=common -vvvvv

Second run don't need passwords
    
    $ ansible-playbook -i development playbooks/bootstrap.yml --user deploy --private-key=~/.vagrant.d/insecure_private_key --sudo

To deploy whole site

    $ ansible-playbook -i development site.yml --user deploy --private-key=~/.vagrant.d/insecure_private_key --sudo

To deploy only part of the site using specified tags

    $ ansible-playbook -i development site.yml --user deploy --private-key=~/.vagrant.d/insecure_private_key --sudo --tags={{ comma_seperated_tags }}

## Applications

All installed applications are accessible under `srv01.platform.com` domain: 

* port `6379` - redis server. Authorization password `supersecret`
* port `9001` - supervisord http interface. Authorization with useranme `secret` and password `supersecret`.
* port `9002` - redis commander. Authorization with username `secret` and password `supersecret`.
* port `9090` - social coffee thrift server.

## Notice

For now one should replace local copy od `id_rsa.pub` file under `roles/common/files` directory with his own 
locally generated public RSA key.

    $ ssh-keygen -t rsa   
    $ cp ~/.ssh/id_rsa.pub $PROVISION_HOME/roles/common/files/

So thanks to this change one can provision without specifying private key path explicitly. On the other hand if you won't perform 
this task please explicitly specify path to vagrants insecure private key see e.g.

With ssh key generated per host

    $ ansible-playbook -i development site.yml --user deploy --sudo

With default vagrant's key

    $ ansible-playbook -i development site.yml --user deploy --private-key=~/.vagrant.d/insecure_private_key --sudo