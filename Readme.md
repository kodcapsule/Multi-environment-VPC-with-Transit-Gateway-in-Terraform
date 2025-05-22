# Hub-and-spoke network architecture using AWS Transit Gateway: Multi-environment VPC with Transit Gateway in Terraform


## Introduction
In this project we will be building  a Scalable and Secure Multi-VPC AWS Network Infrastructure using AWS Transit Gateway. 
### Project Overvirew

## Building a hub-and-spoke network in AWS 

### Step 1: Set Up Project Structure
The first step is to setup the overall project with all the neccessory files. 
```bash
multi-env-vpc/
├── main.tf         # Main configuration file
├── variables.tf    # Input variables
├── outputs.tf      # Output values
├── providers.tf    # Contains all the Provider configuration
├── .gitignore      # 
└── README.md       # Project documentation
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



## Additional Considerations

To enhance this project further, you could add NAT gateways for private subnets to access the internet
Consider implementing VPC flow logs for network monitoring
For a production setup, you might want to use separate AWS accounts for each environment, connected via Resource Access Manager (RAM)

This project demonstrates proper network isolation between environments while allowing controlled communication through a central Transit Gateway, all using Terraform's infrastructure as code approach.



<!-- #  validation {
#     condition     = anytrue([can(regex("10(?:\\.(?:[0-1]?[0-9]?[0-9])|(?:2[0-5]?[0-9])){3}\\/", var.prod_vpc_cidr)), can(regex("172\\.(?:3?[0-1])|(?:[0-2]?[0-9])(?:\\.[0-2]?[0-5]?[0-9]){2}\\/(?:1[6-9]|2[0-9]|3[0-2])", var.prod_vpc_cidr))])
#     error_message = "Must be a valid IPv4 CIDR block address."
#   }

#  validation {
#     condition = can(regex("^10\\.0\\.(\\d{1,3})\\.(\\d{1,3})/16$", var.prod_vpc_cidr))
#     error_message = "CIDR block must be within 10.0.0.0/16 range, e.g., 10.0.0.0/16 or 10.0.100.200/16"
#   } -->