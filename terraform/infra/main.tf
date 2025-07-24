


#private ec2 with no public ip
resource "aws_instance" "my-private-ec2" {
  ami           = var.ami
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.my-private-subnet.id

  tags = {
    Name = "my-private-ec2"
  }

  # Ensure the instance is launched in the private subnet
  associate_public_ip_address = false
  vpc_security_group_ids = [data.aws_security_group.allow-ssh-sg.id ]

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
    delete_on_termination = true
  }

  #install SSM agent
  user_data = <<-EOF
              #!/bin/bash
              sudo snap install amazon-ssm-agent --classic
              sudo snap start amazon-ssm-agent
              EOF

  #instance iam role "AllowEC2AccessSessionManagerToSSH"
  iam_instance_profile = "AllowEC2AccessSessionManagerToSSH"
}

