# Hub-and-spoke network architecture using AWS Transit Gateway: Multi-environment VPC with Transit Gateway in Terraform


## Introduction
In this project we will be building  a Scalable and Secure Multi environment VPC in AWS Network Infrastructure using AWS Transit Gateway. 
### Project Overvirew

## Building a hub-and-spoke network in AWS 

### Step 1: Set Up Project Structure
The first step is to setup the overall project with all the neccessory files. 

```bash
terraform-infrastructure/
├── main.tf                           # Main configuration using modules
├── variables.tf  
├── terraform.tfvars                     # Root variables
├── outputs.tf  
├── Readme.md
├── .gitignore       
├── modules/
│   ├── vpc/
│   │   ├── main.tf                   # VPC resources
│   │   ├── variables.tf              # VPC module variables
│   │   └── outputs.tf                # VPC module outputs
│   ├── transit-gateway/
│   │   ├── main.tf                   # Transit Gateway resources
│   │   ├── variables.tf              # TGW module variables
│   │   └── outputs.tf                # TGW module outputs
│   └── security/
│       ├── main.tf                   # Security Groups & NACLs
│       ├── locals.tf                 # Local transformations
│       ├── variables.tf              # Security module variables
│       └── outputs.tf                # Security module outputs
└── images/                          # contains diagrams and other related images 
   
```

### Step 2: Configure Providers and Variables

Step 3: Create the Main Terraform Configuration

Step 4: Set Up Transit Gateway Attachments
Step 5: Configure Route Tables

Step 6: Implement Network ACLs with Least-Privilege Access

Step 7: Create Security Groups with Least-Privilege Access

Step 8: Define Outputs

Step 9: Deploy the Infrastructure

Step 10: Verify Your Deployment

Cleanup Instructions

## ERRORS and Troubleshooting

**1. Error: Invalid value for variable**

code causing error:
```bash
validation {
    condition     = can(regex("^10\\.1\\.((25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d))\\.((25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d))$", var.dev_vpc_cidr))
    error_message = "The CIDR block must be a valid private IP range."
  }
```
description:  
```bash
on variables.tf line 33:
│   33: variable "dev_vpc_cidr" {
│     ├────────────────
│     │ var.dev_vpc_cidr is "10.1.0.0/16"
│
│ The CIDR block must be a valid private IP range.
│
│ This was checked by the validation rule at variables.tf:36,3-13.
```
Solution:
combining `anytrue` function with `can` functions

```bash
validation {
    condition     = anytrue([can(regex("10(?:\\.(?:[0-1]?[0-9]?[0-9])|(?:2[0-5]?[0-9])){3}\\/", var.dev_vpc_cidr)), can(regex("172\\.(?:3?[0-1])|(?:[0-2]?[0-9])(?:\\.[0-2]?[0-5]?[0-9]){2}\\/(?:1[6-9]|2[0-9]|3[0-2])", var.dev_vpc_cidr))])
    error_message = "Must be a valid IPv4 CIDR block address."
  }
```

**2. Error: Invalid value for variable**

```bash
│ Error: Invalid value for variable
│ 
│   on main.tf line 482, in module "prod_vpc":
│  482:   tags = {
│  483:     Environment = "production"
│  484:     Project     = var.environment
│  485:   }
│     ├────────────────
│     │ var.tags is map of string with 2 elements
```

**code causing error:**

```bash
   validation {
    condition = alltrue([for k, v in var.tags : can(regex("^[a-zA-Z0-9_-]+$", k)) && can(regex("^[a-zA-Z0-9_\\s-]+$", v)) ])
    error_message = "Tags can only contain alphanumeric characters, underscores, and hyphens."
  }
```


**Solution:**
```bash
 validation {
    condition = alltrue([for k, v in var.tags : can(regex("^[a-zA-Z0-9_-]+$", k)) && can(regex("^[a-zA-Z0-9_\\s-]+$", v)) ])
    error_message = "Tags can only contain alphanumeric characters, underscores, and hyphens."
  }
```

**3. Error: api error NetworkAclEntryAlreadyExists**
```bash
│ Error: api error NetworkAclEntryAlreadyExists: EC2 Network ACL (acl-07ff779bf652f56c6) Rule (egress: false)(110) already exists
│
│   with module.security.aws_network_acl_rule.ingress["dev_private-ingress-internal"],
│   on modules\security\main.tf line 52, in resource "aws_network_acl_rule" "ingress":
│   52: resource "aws_network_acl_rule" "ingress" {

```
**4. Error: Error: Error loading state:**
```bash
│ Error: Error loading state:
│     Unable to access object "multi-env/terraform.tfstate" in S3 bucket "multi-env-hub-spoke-terraform-state": operation error S3: HeadObject, https response error StatusCode: 403, RequestID: 8BDXRAT0PPCQ4EZQ, HostID: 7jML04CBlhOC91fqrDc4W0sZUqrO2nWE8RnJ7COrDwGh9XMo8yI+EXLphvXuJG4bYR5p18kjv7FKa99xLkW/DWIYhI1VAIs022v2AUpbxsg=, api error Forbidden: Forbidden
│
│ Terraform failed to load the default state from the "s3" backend.
│ State migration cannot occur unless the state can be loaded. Backend
│ modification and state migration has been aborted. The state in both the
│ source and the destination remain unmodified. Please resolve the
│ above error and try again.
```

**Solution:**
The authentication for the S3 backend is handled separately from the authentication of the provider. The S3 backend uses the default profile for authentication  if you do not provide any profile. If you have two different AWS profiles configured in `~/.aws/credentials`, the S3 backend will use the default profile. You will get this error if the default credentials does not have the  permissions to access your s3 bucket. You can specify the profile in the backend config like seen bellow.

```bash
terraform {
  backend "s3" {
    bucket         = "multi-env-hub-spoke-terraform-state"
    key            = "multi-env-terraform.tfstate"
    region         = "us-east-1"
    profile        = "wewoli"
    dynamodb_table = "multi-env-terraform-state-lock"
    encrypt        = true
  }

}
```

you can also use partial configuration as shown bellow.  To specify a file, use the -backend-config=PATH option when running terraform init. 

```bash
terraform init -backend-config="./state.config"
```

**partial configuration**
```bash
# state.tf
terraform {
  backend "s3" {
    bucket = "" 
    key    = ""
    region = ""
    profile = ""
  }
}
```

```bash
# state.config
bucket = "your-bucket" 
key    = "your-state.tfstate"
region = "eu-central-1"
profile= "Your_Profile"

```

```bash
Error: validating provider credentials: retrieving caller identity from STS: operation error STS: GetCallerIdentity, https response error StatusCode: 0, RequestID: , request send failed, Post "https://sts.us-east-1.amazonaws.com/": dial tcp: lookup sts.us-east-1.amazonaws.com: no such host
```
## Additional Considerations

To enhance this project further, you could add NAT gateways for private subnets to access the internet
Consider implementing VPC flow logs for network monitoring
For a production setup, you might want to use separate AWS accounts for each environment, connected via Resource Access Manager (RAM)

This project demonstrates proper network isolation between environments while allowing controlled communication through a central Transit Gateway, all using Terraform's infrastructure as code approach.



