#for count
#output ec2_private_ip {
#    description = "EC2 private ip"
#    value = aws_instance.web_server[*].private_ip
#}

#output ec2_public_dns {
#    description = "EC2 public DNS"
#    value = aws_instance.web_server[*].public_dns
#}

#for loops
output ec2_private_ip {
    description = "EC2 private ip"
    value = [
        for pvt_ip in aws_instance.web_server : pvt_ip.private_ip
    ]
}

output ec2_public_dns {
    description = "EC2 public DNS"
    value = [
        for dns in aws_instance.web_server : dns.public_dns
    ]
}