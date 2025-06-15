output ec2_private_ip {
    description = "EC2 private ip"
    value = aws_instance.web_server.private_ip
}

output ec2_public_dns {
    description = "EC2 public DNS"
    value = aws_instance.web_server.public_dns
}