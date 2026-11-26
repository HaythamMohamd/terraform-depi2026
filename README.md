# terraform-depi2026

```yaml
# 00 provider => aws
# 01 create vpc
# 02 create public-subnet-1
# 03 create private-subnet-1
# 04 create internet gw  => haytham-igw and attach it to your vpc "haytham-vpc-terrafrom"
# 05 creat public route table ==> 0.0.0.0 ==> internet gw 
# 06 assosiate the route table with the subnet id
# 07 create private route table
# 08 assosiate the private route table with the private subnet

# 09 create ec2 with public subnet 

# 00 provider => aws
provider "aws" {
    region = "us-east-1"
}

# 01 create vpc
resource "aws_vpc" "haytham-vpc-terrafrom" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "haytham-vpc-terrafrom"
  }
}

# 02 create public-subnet-1
resource "aws_subnet" "public-subnet-1" {
  vpc_id            = aws_vpc.haytham-vpc-terrafrom.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name : "public-subnet-1"
  }
}

# 03 create private-subnet-1
resource "aws_subnet" "private-subnet-1" {
  vpc_id            = aws_vpc.haytham-vpc-terrafrom.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name : "private-subnet-1"
  }
}


# 04 create internet gw  => haytham-igw and attach it to your vpc "haytham-vpc-terrafrom"
resource "aws_internet_gateway" "haytham-igw" {
  vpc_id = aws_vpc.haytham-vpc-terrafrom.id
  tags = {
    Name : "haytham-igw"
  }

}


# 05 crreat public route table ==> 0.0.0.0 ==> internet gw 
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.haytham-vpc-terrafrom.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.haytham-igw.id
  }
  tags = {
    Name : "public-rtb"
  }
}


# 06  assosiate the public routetable   with the publicsubnet id
resource "aws_route_table_association" "public-route-table-association" {
  subnet_id = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-route-table.id
}

# 07 create private route table
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.haytham-vpc-terrafrom.id
  tags = {
    Name : "private-rtb"
  }
}

# 08 assosiate the private route table with the private subnet
resource "aws_route_table_association" "private-route-table-association" {
  subnet_id = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private-route-table.id
}

# # 9 create the ec2 using the data source 
# resource "aws_instance" "haytham-terrafrom-ec2" {
#   ami = "ami-0aacbf72109c53c0c"
#   instance_type = "t3.micro"

#   subnet_id = aws_subnet.public-subnet-1.id
#   # vpc_security_group_ids = [aws_security_group.myapp-sg.id]
#   availability_zone = "us-east-1a"

#   associate_public_ip_address = true
#   key_name = "haytham-keypair2026"
#   tags = {
#     Name : "haytham-terrafrom-ec2"
#   }
# }

# -----------------------------------------------------------------------------
# 10. SECURITY GROUP
#    NOTE: Fully open (all traffic in/out) for LAB USE ONLY.
#    See the restricted version below for a safer setup.
# -----------------------------------------------------------------------------
resource "aws_security_group" "haytham-terraform-sg" {
  name   = "haytham-terraform-sg"
  vpc_id = aws_vpc.haytham-vpc-terrafrom.id

  # Inbound: allow everything
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  # Outbound: allow everything
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "haytham-terraform-sg"
  }
}

# # 11 create the ec2 using security group
# resource "aws_instance" "haytham-terrafrom-ec2" {
#   ami = "ami-0aacbf72109c53c0c"
#   instance_type = "t3.micro"

#   subnet_id = aws_subnet.public-subnet-1.id
#   vpc_security_group_ids = [aws_security_group.haytham-terraform-sg.id] #### Added 
#   availability_zone = "us-east-1a"

#   associate_public_ip_address = true
#   key_name = "haytham-keypair2026"
#   tags = {
#     Name : "haytham-terrafrom-ec2"
#   }
# }

# # -----------------------------------------------------------------------------
# # 12. EXTRA EBS VOLUME (1 GB) + ATTACHMENT
# # -----------------------------------------------------------------------------
# resource "aws_ebs_volume" "ebs-volume" {
#   availability_zone =  "us-east-1a" # must match the instance's AZ
#   size              = 1             # size in GB
# }

# resource "aws_volume_attachment" "ebs-volume-attachmement" {
#   device_name = "/dev/sdf"
#   instance_id = aws_instance.haytham-terrafrom-ec2.id
#   volume_id   = aws_ebs_volume.ebs-volume.id
# }




# 13 AMI (data source)
#    Look up the most recent Amazon Linux 2 image instead of hard-coding an ID.
# -----------------------------------------------------------------------------
data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    # Other option: ["amzn2-ami-kernel-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# # 14 create the ec2 using security group
# resource "aws_instance" "haytham-terrafrom-ec2" {
#   # ami = "ami-0aacbf72109c53c0c"
#   ami = data.aws_ami.latest-amazon-linux-image.id
#   instance_type = "t3.micro"
#   user_data = <<-EOF

#   #!/bin/bash
# set -euxo pipefail

# # Install Docker using whichever package manager is available.
# if command -v apt-get >/dev/null 2>&1; then
#   apt-get update -y
#   apt-get install -y docker.io
#   DEFAULT_USER=ubuntu
# else
#   yum update -y
#   yum install -y docker
#   DEFAULT_USER=ec2-user
# fi

# # Enable and start Docker, then grant the default user access.
# systemctl enable docker
# systemctl start docker
# usermod -aG docker "$DEFAULT_USER"

# # Start Nginx and publish it on port 8080.
# docker run -d \
#   --name nginx \
#   --restart unless-stopped \
#   -p 8080:80 \
#   nginx:latest
#   EOF
#   subnet_id = aws_subnet.public-subnet-1.id
#   vpc_security_group_ids = [aws_security_group.haytham-terraform-sg.id] #### Added 
#   availability_zone = "us-east-1a"

#   associate_public_ip_address = true
#   key_name = "haytham-keypair2026"
#   tags = {
#     Name : "haytham-terrafrom-ec2"
#   }
# }


# 14 create the ec2 using security group
resource "aws_instance" "haytham-terrafrom-ec2" {
  # ami = "ami-0aacbf72109c53c0c"
  ami = data.aws_ami.latest-amazon-linux-image.id
  instance_type = "t3.micro"
  user_data = file("docker.sh")
  subnet_id = aws_subnet.public-subnet-1.id
  vpc_security_group_ids = [aws_security_group.haytham-terraform-sg.id] #### Added 
  availability_zone = "us-east-1a"

  associate_public_ip_address = true
  key_name = "haytham-keypair2026"
  tags = {
    Name : "haytham-terrafrom-ec2"
  }
}

# -----------------------------------------------------------------------------
# 15. EXTRA EBS VOLUME (1 GB) + ATTACHMENT
# -----------------------------------------------------------------------------
resource "aws_ebs_volume" "ebs-volume" {
  availability_zone =  "us-east-1a" # must match the instance's AZ
  size              = 1             # size in GB
}

resource "aws_volume_attachment" "ebs-volume-attachmement" {
  device_name = "/dev/sdf"
  instance_id = aws_instance.haytham-terrafrom-ec2.id
  volume_id   = aws_ebs_volume.ebs-volume.id
}


```
