# Infra Repository
In this repository our IaC for AWS is stored.

## File Naming
| Name        | Purpose                           |
| ----------- | --------------------------------- |
| main.tf     | Main terraform infrastructure     |
| provider.tf | Terraform provider initialisation |
| backend.tf  | HCP Terraform connection          |

## Quality-Pipeline
| Nr. | Step                           | Description                                               |
| --- | ------------------------------ | --------------------------------------------------------- |
| 1   | Setup                          | Preparing the runnner (install software, checkout PR ...) |
| 2   | Terraform Fmt                  | Formatting terraform code and commit to PR                |
| 3   | Terraform Docs                 | Update the terraform docs informations in the README      |
| 4   | Terraform Plan                 | Execute a speculative Terraform Plan                      |

# Terraform Docs
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.52.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.4.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.52.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_subnet_group.rds](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/db_subnet_group) | resource |
| [aws_ecr_repository.backend_helm_prod](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository.backend_helm_staging](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository.backend_prod](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository.backend_staging](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository.frontend_helm_prod](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository.frontend_helm_staging](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository.frontend_prod](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository.frontend_staging](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/ecr_repository) | resource |
| [aws_eks_cluster.m306](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/eks_cluster) | resource |
| [aws_eks_fargate_profile.m306](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/eks_fargate_profile) | resource |
| [aws_rds_cluster.m306](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster_instance.m306](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/rds_cluster_instance) | resource |
| [aws_s3_bucket.m306](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/s3_bucket) | resource |
| [aws_security_group.rds](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/security_group) | resource |
| [aws_subnet.subnet_1](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/subnet) | resource |
| [aws_subnet.subnet_2](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/subnet) | resource |
| [aws_subnet.subnet_3](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/subnet) | resource |
| [aws_vpc.network](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/vpc) | resource |
| [helm_release.prod-backend](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_service_account.sa](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |
| [aws_eks_cluster_auth.m306](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_role.labrole](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/data-sources/iam_role) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | The password for the RDS instance | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
