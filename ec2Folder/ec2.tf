#Create a key-pair
resource aws_key_pair my_key_pair {
	key_name = "key_pair"
	public_key= file("ec2_key.pub")
}

# Create a VPC (Virtual Private Cloud)
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Create a public subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

# Create a route table for public subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Associate the route table with the public subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Create a security group that allows SSH and HTTP traffic
resource "aws_security_group" "web" {
  name        = "web-security-group"
  description = "Security group for web server"
  vpc_id      = aws_vpc.main.id

  # Allow SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-security-group"
  }
}

# Create an EC2 instance
resource "aws_instance" "web_server" {
  #count = 2
  for_each = tomap({
    terra_t2_micro = "t2.micro"
    terra_t2_medium = "t2.medium"
  })
  ami                    = var.ec2_ami  
  instance_type          = each.value            
  key_name               = aws_key_pair.my_key_pair.key_name          
  vpc_security_group_ids = [aws_security_group.web.id]
  subnet_id              = aws_subnet.public.id

  # User data script to install Apache web server
  user_data = file("install_apache.sh") 
  
  root_block_device {
    volume_size = var.env == "prod" ? 20 : var.def_vol_size
    volume_type = "gp3"
  }

  tags = {
    Name = each.key
  }
}