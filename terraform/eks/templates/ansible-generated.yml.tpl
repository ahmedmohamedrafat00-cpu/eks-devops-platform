aws_region: "${aws_region}"
eks_cluster_name: "${cluster_name}"

ecr:
  account_id: "${account_id}"
  region: "${aws_region}"
  registry: "${account_id}.dkr.ecr.${aws_region}.amazonaws.com"

# If you create repos in Terraform, you can output them too
