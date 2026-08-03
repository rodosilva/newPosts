+++
date = '2026-08-02T12:00:52-05:00'
title = 'Terragrunt'
+++

## INTRODUCTION
Complements `Terraform`
Managing multiple environments
Thin wrapper when dealing with a large scale setup

## BASIC CONCEPTS
### Key Features
- Hierarchical configuration
- Remote Management
- Modular variable definitions
- Dry approach (Don't repeat yourself)

### Use Cases
- Complex infrastructure
- Managing deployments

### What Problem Does Terragrunt Solve?
- Configuration complexity
- State management challenges
- Code duplication
- Consistency across platforms
- Collaboration and versioning

### The DRY Principle
- Modular configuration
- Variable abstraction
- Hierarchical configuration
- Simplified maintenance

### Install Terragrunt
- [Install](https://docs.terragrunt.com/getting-started/install/)

## GOOD TO KNOW

![](Pasted%20image%2020260802124304.png)

### Terragrunt Cache
`.terragrunt-cache`
To reclaim space
```bash
# To find it
find . -type d -name ".terragrunt-cache"
# To delete it
find . -type d -name ".terragrunt-cache" -prune -exec rm -rf {} \;
```

To store in a centralice location use:
- `TERRAGRUNT_DOWNLOAD`

### Terragrunt with AWS
- AWS integration
- AWS provider configuration
- Terragrunt configuration for AWS
- Identity Access Management (IAM)
- S3 Backend for remote state
- Variable configuration
- Best practices for AWS with Terragrunt

### Terragrunt Configuration Files
- `Terragrunt.hcl`: Control center `HCL` Declarative
- Inheritance Model. Using Blocks
	- Locals
	- remote_state
	- include
- Module configuration
	- Source
	- version
	- Variables
- Variable Definition
	- var3
	- var2
	- var1
- Remote State Configuration
	- Backend: Where to store files and how to access them

### Directory Structure
- Root `terragrunt.hcl`
- Module directory
- Organized module structure
- Environment-specific configuration (fine tuning)
- Common variable definition
- Example directory structure

![](Pasted%20image%2020260802145143.png)
![](Pasted%20image%2020260802145425.png)
### Supporting Files
- `account.hcl`
- `region.hcl`
- `env.hcl`
- `common.hcl`

### Global Resources
Services do not fall in the traditional region category
Deployed once per account
Isolate Global services from region sub directories
Maintain clear hierarchy and structure

Examples:
- IAM, Route53, WAF, CloudFront, ACM

## TERRAGRUNT COMMANDS

- `terragrunt init`: Plugins and Module dependencies
- `terragrunt validate`: Semantics and sintaxis. Include it on CI/CD pipelines
- `terragrunt plan`: Generate a detailed execution plan. Resources created, edited or deleted (Across config hierarchy)
- `terragrunt apply`: Initiate the application of the `terraform` 
- `terragrunt destroy`: Initiate the destruction of resources provided by `terraform`
- `terragrunt run-all`: Execute specified `terragrunt commands` Bulk execution

```bash
# On a parent directory of your modules
terragrunt run-all init
```

- `terragrunt hclfmt`: Used to format `HCL` files

## TERRAGRUNT FUNCTIONS

- `read_terragrunt_config`: Enable to read `terragrunt` configuration values
- `find_in_parent_folders`: Search for specific files within parent folders
- `path_relative_to_include`: Calculate the relative path from the current `terragrunt` config file
- `get_terragrunt_dir`: Retrieve the directory path where the current `terragrunt` config files resides
- `get_parent_terragrunt_dir`: Obtain the directory path of the parent `terragrunt` 
- `run_cmd`: Execute shell commands directly within your `terragrunt` configurations

**Terraform + Terragrunt**
`basename(get_terragrunt_dir())`

### read_terragrunt_config

Considering:
```bash
vpc/
│  └── terragrunt.hcl
├── common.hcl
```

where `common.hcl`:
```json
inputs = {
  project     = "kodekloud"
  environment = "dev"
}
```

Where `terragrunt.hcl`:
```json
terraform {
  source = "..."
}
Locals {
  common_vars = read_terragrunt_config("../common.hcl")
}
inputs = {
  name = "${local.common_vars.inputs.project}-${local.common_vars.inputs.environment}-VPC"
}
```

### find_in_parent_folders
With this we don't need to rely on a relative path
Same example as before
```json
terraform {
  source = "..."
}
Locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}
inputs = {
  name = "${local.common_vars.inputs.project}-${local.common_vars.inputs.environment}-VPC"
}
```

### path_relative_to_include
Calculate the relative path between two directories

```json
terraform {
  source = "..."
}
Locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

include "common" {
  path = find_in_parent_folders("common.hcl")
}

inputs = {
  name = "${local.common_vars.inputs.project}-${local.common_vars.inputs.environment}-VPC"
  tags = {
    Path = path_relative_to_include()
  }
}
```
This output: `vpc`
### get_terragrunt_dir
Retrieves the path to the directory where the current `terragrunt` config file is
Dynamic adaptation

```bash
vpc/
│  └── terragrunt.hcl
├── common.tfvars
```

`terragrunt.hcl`
```json
terraform {
  source = "..."
  
  extra_arguments "custom_vars" {
    commands = [
      "plan"
    ]
    
    arguments = [
      // "-var-file=../common.tfvsrs" # This won't work
      "-var-file=${get_terragrunt_dir()}/../common.tfvars"
    ]
  }
}
```

`common.tfvars`
```json
name = "kodecloud-vpc"
cidr = "10.100.0.0/24"
```

### get_parent_terragrunt_dir
Similar to the previous one
Retrieves the path
Useful with remote `terraform` configuration

### run_cmd
Run as many commands as you want

```json
terraform {
  source = "..."
}

inputs = {
  name = "kodecloud-VPC"
  
  tags = {
    CreatedBy = run_cmd("whoami")
  }
}
```

### Other Terragrunt Functions
[Built In Functions](https://docs.terragrunt.com/reference/hcl/functions/)

## TERRAGRUNT BLOCKS
- `terraform block`
- `remote_state block`
- `include block`
- `locals block`
- `dependency block`
- `dependencies block`
- `generate block`

### terraform block
How `terragrunt` will interact with `terraform`
- `source attribute`
- `version parameter`
- `extra args attribute`
- `other`

```json
terraform {
  source = "tfr:///terraform-aws-modules/vpc/aws//?version=5.8.1"
  source = "github.com/terraform-aws-modules/terraform-aws-vpc"
  source = "git@github.com:terraform-aws-modules/terraform-aws-vpc?ref=v5.8.1"
  source = "../modules/vpc-module"
}
```

### remote_state Block
Where `terraform` state files are stored
- `backend`
- `config`
- `generate`

```json
remote_state {
  backend = "s3"
  config = {
    encrypt = true
    bucket = "kodecloud-terragrunt-remote-state"
    key = "${path_relative_to_include()}/terraform.tfstate"
    region = "eu-west-1"
    dynamodb_table = "terraform-locks"
  }
  generate = {
    path = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
```

### Include Block
From external files into the `terragrunt` setup
- `path`
- `find_in_parent`

```bash
vpc/
└── terragrunt.hcl
│
vpc2/
└── terragrunt.hcl
│
common.hcl
terragrunt.hcl
```

`./terragrunt.hcl`
```json
remote_state {
  backend = "s3"
  config = {
    encrypt = true
    bucket = "kodecloud-terragrunt-remote-state"
    key = "${path_relative_to_include()}/terraform.tfstate"
    region = "eu-west-1"
    dynamodb_table = "terraform-locks"
  }
  generate = {
    path = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
```

`vpc/terragrunt.hcl`
```json
terraform {
  source = "..."
}

include "root" {
  path = find_in_parent_folder()
  expose = true
}
```

`vpc2/terragrunt.hcl`
```json
terraform {
  source = "..."
}

include "root" {
  path = find_in_parent_folder()
  expose = true
}

include "common" {
  path = find_in_parent_folder("common.hcl")
  expose = true
}
```

`common.hcl`
```json
locals {
  project = "kodecloud"
}
```

### Locals Block
Define local variables and expressions

- Defines variables
- Can be reused 
- Limited to the scope

`common.hcl`
```json
locals {
  project = "kodecloud"
}
```

`vpc2/terragrunt.hcl`
```json
terraform {
  source = "..."
}

include "root" {
  path = find_in_parent_folder()
  expose = true
}

include "common" {
  path = find_in_parent_folder("common.hcl")
  expose = true
}

// Only for this one
Locals {
  cidr = "10.100.0.0/16"
}

inputs = {
  name = include.common.locals.project
}
```

### Dependency Block
Configure module dependencies
Allowing modules to depend on the outputs of other modules
- `name`
- `config_path`
- `enabled`
- `skip_outputs`
- `mock outputs`
- `allowed terraform commands`
- `Merge_strategy_with_state`

```bash
ec2/
└── terragrunt.hcl
│
vpc/
└── terragrunt.hcl
│
common.hcl
terragrunt.hcl
```

`ec2/terragrunt.hcl`
```json
terraform {
  source = "trf:///terraform-aws-modules/ec2-instance/aws//?version=5.6.1"
}

include "root" {
  path = find_in_parent_folder()
  expose = true
}

include "common" {
  path = find_in_parent_folder("common.hcl")
  expose = true
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  name = include.common.locals.project
  subnet_id = dependency.vpc.outputs.public_subnets[0]
}
```
Only be created once the `vpc`is created first

`vpc/terragrunt.hcl`
```json
terraform {
  source = "trf:///terraform-aws-modules/vpc/aws//?version=5.8.1"
}

include "root" {
  path = find_in_parent_folder()
  expose = true
}
```

### Dependencies Block
Modules that must be applied for a specific module 
- `list of path as attribute`

```bash
ec2/
└── terragrunt.hcl
│
vpc/
└── terragrunt.hcl
│
s3-bucket/
└── terragrunt.hcl
│
common.hcl
terragrunt.hcl
```

`s3-bucket/terragrunt.hcl`
```json
terraform {
  source = "trf:///terraform-aws-modules/s3-bucket/aws//?version=4.1.2"
}

include "root" {
  path = find_in_parent_folder()
  expose = true
}

include "common" {
  path = find_in_parent_folder("common.hcl")
  expose = true
}

dependencies {
  paths = ["../ec2"]
}

inputs = {
  bucket = include.common.locals.project
}
```

Purely for ordering the operations  when using the `run-all command`
We don't want it to be created before the `EC2 Instance`

### Generate Block
Generate files
- `Name attribute`
- `path attribute`
- `if_exists attribute`
- `comment prefix attribute`
- `disable signature attribute`
- `contents attribute`
- `disable attribute`

`./terragrunt.hcl`
```json
remote_state {
  backend = "s3"
  config = {
    encrypt = true
    bucket = "kodecloud-terragrunt-remote-state"
    key = "${path_relative_to_include()}/terraform.tfstate"
    region = "eu-west-1"
    dynamodb_table = "terraform-locks"
  }
  generate = {
    path = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

generate "providers" {
  path = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = "eu-west-1"
}
EOF
}

generate "provider_version" {
  path = "versions.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
required_providers {
  aws = {
    source = "hashicorp/aws"
    version = "~>5.0"
  }
}
}
EOF
}
```

Generate any kind of configuration it doesn't have to be necessarily `Terraform files`

