#!/usr/bin/env bash

ansible-galaxy collection install --upgrade -r requirements.yml
ansible-playbook main.yml
