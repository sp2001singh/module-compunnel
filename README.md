# Usage Example
# This needs to put in main.tf file (Required)

```hcl
locals {
  tags = {
    managed_by          = "compunnel" # validate can(regex())?
    cost_center         = ""          # TODO set not null
    project             = "project"
    project_owner       = ""    # TODO set not null
    project_owner_email = ""    # TODO verify email and domain
    ENV                 = "dev" # TODO set limited options dev|stage|prod?
    customer            = ""    # TODO set not null
    # tags for automation, access control
    # TODO tag standardization
  }
}

module "base_infra" {
  source = "git::https://github.com/CD-TeraformModules/aws-vpc.git"
  name = "${local.tags.managed_by}-${local.tags.project}"

  tags = merge({
    # key = "value"
  }, local.tags)
}

```

# This needs to be put in provider.tf file (Required)

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.33.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6.0"
    }
  }
  required_version = ">= 1.6.4"
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Terraform = true # set in nested too, make immutable
      company   = "compunnel"
    }
  }
}

```
# This needs to be put in output.tf file (Optional)
```hcl
output "vpc_all_ouputs" {
  description = "All outputs"
  value       = module.base_infra
}
```

# Compliant & Secure VPC

A wrapper for Hashicorps's VPC module to enhance security and cater to regulatory compliances.

## Requirements

No requirements.

## Providers

The following providers are used by this module:

- aws

## Modules

The following Modules are called:

### limited\_vpc

Source: terraform-aws-modules/vpc/aws

Version: 4.0.1

## Resources

The following resources are used by this module:

- [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) (data source)

## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### cidr\_block

Description: CIDR block

Type: `string`

Default: `"10.0.0.0/20"`

### enable\_dns\_hostnames

Description: DNS hostnames

Type: `bool`

Default: `true`

### enable\_dns\_support

Description: DNS support

Type: `bool`

Default: `true`

### name

Description: VPC name

Type: `string`

Default: `"compunnel-project-vpc-pub-az1"`

### region

Description: Region to deploy into...

Type: `string`

Default: `"us-east-2"`

### subnets

Description: Number of subnets to be created for each public & private.

Type: `number`

Default: `2`

## Outputs

The following outputs are exported:

### azs

Description: List of available AZs in the given region

### dhcp\_options\_id

Description: The ID of the DHCP options

### egress\_only\_internet\_gateway\_id

Description: The ID of the egress only Internet Gateway

### igw\_arn

Description: The ARN of the Internet Gateway

### igw\_id

Description: The ID of the Internet Gateway

### nat\_ids

Description: List of allocation ID of Elastic IPs created for AWS NAT Gateway

### nat\_public\_ips

Description: List of public Elastic IPs created for AWS NAT Gateway

### natgw\_ids

Description: List of NAT Gateway IDs

### private\_nat\_gateway\_route\_ids

Description: List of IDs of the private nat gateway route

### private\_network\_acl\_arn

Description: ARN of the private network ACL

### private\_network\_acl\_id

Description: ID of the private network ACL

### private\_route\_table\_association\_ids

Description: List of IDs of the private route table association

### private\_route\_table\_ids

Description: List of IDs of private route tables

### private\_subnet\_arns

Description: List of ARNs of private subnets

### private\_subnets

Description: List of IDs of private subnets

### private\_subnets\_cidr\_blocks

Description: List of cidr\_blocks of private subnets

### public\_internet\_gateway\_route\_id

Description: ID of the internet gateway route

### public\_network\_acl\_arn

Description: ARN of the public network ACL

### public\_network\_acl\_id

Description: ID of the public network ACL

### public\_route\_table\_ids

Description: List of IDs of public route tables

### public\_subnet\_arns

Description: List of ARNs of public subnets

### public\_subnets

Description: List of IDs of public subnets

### public\_subnets\_cidr\_blocks

Description: List of cidr\_blocks of public subnets

### vpc\_arn

Description: The ARN of the VPC

### vpc\_cidr\_block

Description: The CIDR block of the VPC

### vpc\_enable\_dns\_hostnames

Description: Whether or not the VPC has DNS hostname support

### vpc\_enable\_dns\_support

Description: Whether or not the VPC has DNS support

### vpc\_flow\_log\_cloudwatch\_iam\_role\_arn

Description: The ARN of the IAM role used when pushing logs to Cloudwatch log group

### vpc\_flow\_log\_destination\_arn

Description: The ARN of the destination for VPC Flow Logs

### vpc\_flow\_log\_destination\_type

Description: The type of the destination for VPC Flow Logs

### vpc\_flow\_log\_id

Description: The ID of the Flow Log resource

### vpc\_id

Description: The ID of the VPC

### vpc\_instance\_tenancy

Description: Tenancy of instances spin up within VPC

### vpc\_main\_route\_table\_id

Description: The ID of the main route table associated with this VPC

### vpc\_owner\_id

Description: The ID of the AWS account that owns the VPC

### vpc\_secondary\_cidr\_blocks

Description: List of secondary CIDR blocks of the VPC
