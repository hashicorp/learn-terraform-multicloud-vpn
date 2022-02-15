provider "aws" {
  region  = "us-east-2"

}

### Network
resource "aws_vpc" "vpc" {
  cidr_block = "192.168.0.0/16"

  tags = {
    Name = "vpc"
  }
}

resource "aws_subnet" "subnet_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "192.168.1.0/24"

  tags = {
    Name = "subnet_1"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "internet_gateway"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "route_table"
  }
}

resource "aws_route" "subnet_1_exit_route" {
  route_table_id         = aws_route_table.route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

resource "aws_route_table_association" "route_table_association" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.route_table.id
}

### EC2 Instance
resource "aws_security_group" "ssh" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "security_group_ssh"
  }
}

data "aws_ami" "latest-ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "template_file" "frontend_hashicups" {
  template = file("./scripts/frontend_hashicups.yaml")
}


resource "aws_instance" "vm" {
  ami           = data.aws_ami.latest-ubuntu.id
  instance_type = "t2.micro"

  vpc_security_group_ids      = [aws_security_group.ssh.id]
  subnet_id                   = aws_subnet.subnet_1.id
  associate_public_ip_address = true


  user_data = data.template_file.frontend_hashicups.rendered

}

### Outputs

output "aws_vm_public_ip" {
  value = aws_instance.vm.public_ip
}

output "aws_vm_private_ip" {
  value = aws_instance.vm.private_ip
}