variable ec2_ami {
    description = "AMI for AWS EC2"
    type = string
    default = "ami-0c02fb55956c7d316"
}

variable ec2_instance_type {
    description = "Instance Type for EC2"
    type = string
    default = "t2.micro"
}

variable ec2_instance_name {
    description = "EC2 instance name"
    type = string
    default = "ajeet_terra_instance"
}