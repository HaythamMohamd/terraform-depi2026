
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

# # # 14 create the ec2 using security group
# # resource "aws_instance" "haytham-terrafrom-ec2" {
# #   # ami = "ami-0aacbf72109c53c0c"
# #   ami = data.aws_ami.latest-amazon-linux-image.id
# #   instance_type = "t3.micro"
# #   user_data = <<-EOF

# #   #!/bin/bash
# # set -euxo pipefail

# # # Install Docker using whichever package manager is available.
# # if command -v apt-get >/dev/null 2>&1; then
# #   apt-get update -y
# #   apt-get install -y docker.io
# #   DEFAULT_USER=ubuntu
# # else
# #   yum update -y
# #   yum install -y docker
# #   DEFAULT_USER=ec2-user
# # fi

# # # Enable and start Docker, then grant the default user access.
# # systemctl enable docker
# # systemctl start docker
# # usermod -aG docker "$DEFAULT_USER"

# # # Start Nginx and publish it on port 8080.
# # docker run -d \
# #   --name nginx \
# #   --restart unless-stopped \
# #   -p 8080:80 \
# #   nginx:latest
# #   EOF
# #   subnet_id = aws_subnet.public-subnet-1.id
# #   vpc_security_group_ids = [aws_security_group.haytham-terraform-sg.id] #### Added 
# #   availability_zone = "us-east-1a"

# #   associate_public_ip_address = true
# #   key_name = "haytham-keypair2026"
# #   tags = {
# #     Name : "haytham-terrafrom-ec2"
# #   }
# # }


# # # 14 create the ec2 using user_data = file("docker.sh")
# # resource "aws_instance" "haytham-terrafrom-ec2" {
# #   # ami = "ami-0aacbf72109c53c0c"
# #   ami = data.aws_ami.latest-amazon-linux-image.id
# #   instance_type = "t3.micro"
# #   user_data = file("docker.sh")
# #   subnet_id = aws_subnet.public-subnet-1.id
# #   vpc_security_group_ids = [aws_security_group.haytham-terraform-sg.id] #### Added 
# #   availability_zone = "us-east-1a"

# #   associate_public_ip_address = true
# #   key_name = "haytham-keypair2026"
# #   tags = {
# #     Name : "haytham-terrafrom-ec2"
# #   }
# # }

# # # -----------------------------------------------------------------------------
# # # 15. EXTRA EBS VOLUME (1 GB) + ATTACHMENT
# # # -----------------------------------------------------------------------------
# # resource "aws_ebs_volume" "ebs-volume" {
# #   availability_zone =  "us-east-1a" # must match the instance's AZ
# #   size              = 1             # size in GB
# # }

# # resource "aws_volume_attachment" "ebs-volume-attachmement" {
# #   device_name = "/dev/sdf"
# #   instance_id = aws_instance.haytham-terrafrom-ec2.id
# #   volume_id   = aws_ebs_volume.ebs-volume.id
# # }


# # # 16 create the 3 ec2 using count
# # resource "aws_instance" "haytham-terrafrom-ec2" {
# #   # ami = "ami-0aacbf72109c53c0c"
# #   ami = data.aws_ami.latest-amazon-linux-image.id
# #   count = 3
# #   instance_type = "t3.micro"
# #   user_data = file("docker.sh")
# #   subnet_id = aws_subnet.public-subnet-1.id
# #   vpc_security_group_ids = [aws_security_group.haytham-terraform-sg.id] #### Added 
# #   availability_zone = "us-east-1a"

# #   associate_public_ip_address = true
# #   key_name = "haytham-keypair2026"
# #   tags = {
# #     Name : "haytham-terrafrom-ec2-number-${count.index + 1}"
# #   }
# # }

# # resource "aws_ebs_volume" "ebs-volume" {
# #   count             = 3
# #   availability_zone = "us-east-1a"
# #   size              = 1

# #   tags = {
# #     Name = "haytham-ebs-volume-${count.index + 1}"
# #   }
# # }

# # resource "aws_volume_attachment" "ebs-volume-attachment" {
# #   count       = 3
# #   device_name = "/dev/sdf"
# #   instance_id = aws_instance.haytham-terrafrom-ec2[count.index].id
# #   volume_id   = aws_ebs_volume.ebs-volume[count.index].id
# # }


## 17 create key pair using public key - create public and private keys using (ssh-keygen )
resource "aws_key_pair" "ssh-key" {
  key_name = "amr-keypair"
  public_key = file("/Users/haytham/.ssh/id_rsa.pub")
}

# resource "aws_instance" "haytham-terrafrom-ec2" {
#   # ami = "ami-0aacbf72109c53c0c"
#   ami = data.aws_ami.latest-amazon-linux-image.id
#   instance_type = "t3.micro"
#   user_data = file("docker.sh")
#   subnet_id = aws_subnet.public-subnet-1.id
#   vpc_security_group_ids = [aws_security_group.haytham-terraform-sg.id] #### Added 
#   availability_zone = "us-east-1a"

#   associate_public_ip_address = true
#   key_name = aws_key_pair.ssh-key.key_name
#   tags = {
#     Name : "haytham-terrafrom-ec2"
#   }
# }

# 18. Use local and remote provisioners.
resource "aws_instance" "haytham-terrafrom-ec2" {
  ami               = data.aws_ami.latest-amazon-linux-image.id
  instance_type     = "t3.micro"
  subnet_id         = aws_subnet.public-subnet-1.id
  vpc_security_group_ids = [
    aws_security_group.haytham-terraform-sg.id
  ]
  availability_zone           = "us-east-1a"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh-key.key_name

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file("/Users/haytham/.ssh/id_rsa")
  }

  provisioner "file" {
    source      = "docker.sh"
    destination = "/home/ec2-user/docker.sh"
  }
  # this should be done using sudo
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /home/ec2-user/docker.sh",
      "sudo /home/ec2-user/docker-on-ec2.sh",
    ]
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > output.txt"
  }

  tags = {
    Name = "haytham-terrafrom-ec2"
  }
}
