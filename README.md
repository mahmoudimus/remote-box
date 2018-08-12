# REMOTE-BOX

my attempt at a remote development environment

## Install

- `ansible-galaxy install -r ansible-requirements.yml -p $(pwd)/roles --force`

## Run

- `vagrant up`

**OR**

- `ansible-playbook site.yml -i '${PUBLIC_IP_HOSTNAME},' -vvv -b --ask-become-pass --become-method=sudo`
