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
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tfe_team.developers](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/team) | resource |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->