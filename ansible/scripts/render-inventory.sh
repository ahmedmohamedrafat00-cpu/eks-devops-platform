#!/bin/bash

BASTION_IP=$(terraform -chdir=../terraform/servers-setup output -raw bastion_public_ip)
ANSIBLE_PRIVATE_IP=$(terraform -chdir=../terraform/servers-setup output -raw ansible_private_ip)

sed \
  -e "s|\${BASTION_IP}|$BASTION_IP|g" \
  -e "s|\${ANSIBLE_PRIVATE_IP}|$ANSIBLE_PRIVATE_IP|g" \
  inventory/hosts.ini > inventory/hosts.generated.ini
