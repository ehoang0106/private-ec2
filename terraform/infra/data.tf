#get data from network/main.tf

data "aws_vpc" "my-vpc" {
  filter {
    name   = "tag:Name"
    values = ["my-vpc"]
  }
}

data "aws_subnet" "my-public-subnet" {
  filter {
    name   = "tag:Name"
    values = ["my-public-subnet"]
  }
}

data "aws_subnet" "my-private-subnet" {
  filter {
    name   = "tag:Name"
    values = ["my-private-subnet"]
  }
}

data "aws_security_group" "allow-ssh-sg" {
  filter {
    name   = "tag:Name"
    values = ["allow-ssh-sg"]
  }
}
