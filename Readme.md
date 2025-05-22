# Hub-and-spoke network architecture using AWS Transit Gateway: Multi-environment VPC with Transit Gateway in Terraform

## Introduction
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

## Additional Considerations

To enhance this project further, you could add NAT gateways for private subnets to access the internet
Consider implementing VPC flow logs for network monitoring
For a production setup, you might want to use separate AWS accounts for each environment, connected via Resource Access Manager (RAM)

This project demonstrates proper network isolation between environments while allowing controlled communication through a central Transit Gateway, all using Terraform's infrastructure as code approach.