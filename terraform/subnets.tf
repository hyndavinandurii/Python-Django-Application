# Define the data source for availability zones
data "aws_availability_zones" "available" {}

# Define a public subnet
resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${count.index}"
  }
}

# Define a private subnet
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  tags = {
    Name = "private-subnet-${count.index}"
  }
}
