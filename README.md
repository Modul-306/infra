# Infra Repository
In this repository our IaC for AWS is stored.

## File Naming
| Name        | Purpose                           |
| ----------- | --------------------------------- |
| main.tf     | Main terraform infrastructure     |
| provider.tf | Terraform provider initialisation |

## Pipeline
| Nr. | Step                           | Description                                 |
| --- | ------------------------------ | ------------------------------------------- |
| 1   | x                              | x                                           |

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
| [aws_instance.web](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/instance) | resource |
| [aws_security_group.web-sg](https://registry.terraform.io/providers/hashicorp/aws/4.52.0/docs/resources/security_group) | resource |
| [random_pet.sg](https://registry.terraform.io/providers/hashicorp/random/3.4.3/docs/resources/pet) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_web-address"></a> [web-address](#output\_web-address) | n/a |
<!-- END_TF_DOCS -->