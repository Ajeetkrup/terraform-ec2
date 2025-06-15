# Terraform Infrastructure with Remote State Management

This repository contains Terraform configurations for setting up AWS infrastructure with remote state management using S3 and DynamoDB for state locking.

## Project Structure

```
.
├── backup_backend/          # Backend infrastructure setup
│   ├── dynamoDb.tf
│   ├── s3.tf
│   ├── providers.tf
│   └── terraform.tf
├── ec2Folder/              # EC2 instance configuration
│   ├── ec2.tf
│   ├── variables.tf
│   ├── providers.tf
│   ├── outputs.tf
│   └── terraform.tf
└── README.md
```

## Overview

### backup_backend
Contains the foundational infrastructure for Terraform state management:
- **S3 Bucket**: Stores Terraform state files remotely
- **DynamoDB Table**: Provides state locking mechanism to prevent concurrent modifications
- **IAM Policies**: Manages permissions for state file access

### ec2Folder
Contains the main infrastructure deployment:
- **EC2 Instances**: Virtual machines configuration
- **Security Groups**: Network access controls
- **Key Pairs**: SSH access management
- **Backend Configuration**: Connects to the remote state backend

## Prerequisites

Before you begin, ensure you have:

1. **AWS CLI** installed and configured
   ```bash
   aws configure
   ```

2. **Terraform** installed (version >= 1.0)
   ```bash
   terraform --version
   ```

3. **AWS Credentials** with appropriate permissions:
   - S3 full access
   - DynamoDB full access
   - EC2 full access
   - IAM policy management

## Deployment Steps

### Step 1: Deploy Backend Infrastructure

First, set up the S3 bucket and DynamoDB table for state management:

```bash
cd backup_backend/
terraform init
terraform plan
terraform apply
```

**Important**: Note the outputs from this step (S3 bucket name and DynamoDB table name) as they'll be needed for the EC2 configuration.

### Step 2: Configure Backend for EC2 Deployment

Update the backend configuration in `ec2Folder/terraform.tf` with the values from Step 1:

```hcl
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "ec2/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "your-terraform-lock-table"
    encrypt        = true
  }
}
```

### Step 3: Deploy EC2 Infrastructure

```bash
cd ../ec2Folder/
terraform init
terraform plan
terraform apply
```

## State Management

### Remote State Benefits
- **Collaboration**: Multiple team members can work on the same infrastructure
- **State Locking**: Prevents concurrent modifications that could corrupt state
- **Security**: State files are encrypted and stored securely in S3
- **Backup**: Automatic versioning and backup of state files

### State Locking Mechanism
- DynamoDB table uses the state file path as the primary key
- Lock is acquired before any state-modifying operation
- Lock is automatically released after operation completion
- Manual lock breaking available if needed

## Common Commands

### Initialize Terraform
```bash
terraform init
```

### Plan Changes
```bash
terraform plan
```

### Apply Changes
```bash
terraform apply
```

### Destroy Infrastructure
```bash
terraform destroy
```

### Check State
```bash
terraform state list
terraform state show <resource>
```

### Force Unlock (if needed)
```bash
terraform force-unlock <lock-id>
```

## Configuration Variables

### Backend Variables
- `region`: AWS region for backend resources
- `bucket_name`: S3 bucket name for state storage
- `dynamodb_table_name`: DynamoDB table name for locking

### EC2 Variables
- `instance_type`: EC2 instance type (default: t3.micro)
- `ami_id`: AMI ID for EC2 instances
- `key_name`: SSH key pair name
- `vpc_id`: VPC ID for deployment
- `subnet_id`: Subnet ID for instance placement

## Security Considerations

1. **State File Encryption**: Always enable encryption for S3 bucket
2. **Access Control**: Use IAM policies to restrict access to state files
3. **Network Security**: Configure security groups with minimal required access
4. **Key Management**: Store SSH keys securely, never commit to version control

## Troubleshooting

### Common Issues

1. **State Lock Error**
   ```
   Error: Error acquiring the state lock
   ```
   Solution: Check if another process is running or use `terraform force-unlock`

2. **Backend Initialization Error**
   ```
   Error: Failed to get existing workspaces
   ```
   Solution: Verify S3 bucket and DynamoDB table exist and are accessible

3. **Permission Denied**
   ```
   Error: Access Denied
   ```
   Solution: Check AWS credentials and IAM permissions

### Debugging Commands
```bash
# Enable detailed logging
export TF_LOG=DEBUG
terraform apply

# Validate configuration
terraform validate

# Check configuration formatting
terraform fmt -check
```

## Best Practices

1. **Version Control**: Never commit `terraform.tfstate` files to git
2. **Environment Separation**: Use different backends for different environments (dev/staging/prod)
3. **Resource Tagging**: Always tag resources for better management and cost tracking
4. **State File Backup**: Enable versioning on S3 bucket for state file backup
5. **Regular Updates**: Keep Terraform and provider versions up to date

## Cleanup

To completely remove all infrastructure:

1. Destroy EC2 resources first:
   ```bash
   cd ec2Folder/
   terraform destroy
   ```

2. Then destroy backend infrastructure:
   ```bash
   cd ../backup_backend/
   terraform destroy
   ```

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review Terraform and AWS documentation
3. Check AWS CloudTrail logs for detailed error information

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly in a development environment
5. Submit a pull request

---

**Note**: Always test infrastructure changes in a development environment before applying to production.