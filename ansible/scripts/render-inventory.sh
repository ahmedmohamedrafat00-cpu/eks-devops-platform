#!/usr/bin/env bash
set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

TF_DIR="$ROOT_DIR/../terraform/servers-setup"
OUT_FILE="$ROOT_DIR/inventory/hosts.generated.ini"

BASTION_IP=$(terraform -chdir="$TF_DIR" output -raw bastion_public_ip)
ANSIBLE_IP=$(terraform -chdir="$TF_DIR" output -raw ansible_private_ip)

cat > "$OUT_FILE" <<EOF
[bastion]
bastion ansible_host=${BASTION_IP}

[ansible_servers]
ansible ansible_host=${ANSIBLE_IP}

[all:vars]
ansible_user=ec2-user
ansible_ssh_private_key_file=~/.ssh/eks-devops-key
ansible_become=true
ansible_become_method=sudo
ansible_ssh_common_args='-o ForwardAgent=yes -o ProxyJump=ec2-user@${BASTION_IP} -o StrictHostKeyChecking=no'
EOF

echo "Inventory generated at $OUT_FILE"
