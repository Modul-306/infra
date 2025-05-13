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

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.m306](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/db_instance) | resource |
| [aws_ecr_repository.backend_prod](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository.backend_staging](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository.frontend_prod](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository.frontend_staging](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/ecr_repository) | resource |
| [aws_eks_cluster.m306](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.m306](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/eks_node_group) | resource |
| [aws_s3_bucket.m306](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/s3_bucket) | resource |
| [aws_subnet.subnet_1](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/subnet) | resource |
| [aws_subnet.subnet_2](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/subnet) | resource |
| [aws_subnet.subnet_3](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/subnet) | resource |
| [aws_vpc.network](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/vpc) | resource |
| [aws_iam_role.labrole](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/data-sources/iam_role) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->
