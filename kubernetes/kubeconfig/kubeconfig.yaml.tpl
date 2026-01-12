apiVersion: v1
kind: Config
clusters:
- name: eks-devops
  cluster:
    server: ${cluster_endpoint}
    certificate-authority-data: ${cluster_ca}

contexts:
- name: ansible@eks-devops
  context:
    cluster: eks-devops
    user: ansible

current-context: ansible@eks-devops

users:
- name: ansible
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: aws
      args:
        - eks
        - get-token
        - --cluster-name
        - ${cluster_name}
        - --region
        - us-east-1
        - --role-arn
        - ${ansible_role_arn}
