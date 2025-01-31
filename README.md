# Infra Repository
In this repository our IaC for AWS is stored.

## File Naming
| Name        | Purpose                           |
| ----------- | --------------------------------- |
| main.tf     | Main terraform infrastructure     |
| provider.tf | Terraform provider initialisation |

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
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.web](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/instance) | resource |
| [aws_security_group.web-sg](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/security_group) | resource |
| [random_pet.sg](https://registry.terraform.io/providers/hashicorp/random/3.4.3/docs/resources/pet) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/data-sources/ami) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->