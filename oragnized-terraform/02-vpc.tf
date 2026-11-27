# 01 create vpc
resource "aws_vpc" "haytham-vpc-terrafrom" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "depi-vpc-terrafrom"
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
