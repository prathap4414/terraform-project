resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr

    tags = {
        Name = "${var.cluster_name}-vpc"
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    }
  
}

resource "aws_subnet" "private_subnet" {
  count= length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = local.azs[count.index]

    tags = {
        Name = "${var.cluster_name}-subnet"
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
        "kubernetes.io/role/internal-elb" = "1"
    }
  
}
resource "aws_subnet" "public_subnet" {
  count= length(var.public_subnet_cidr)
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.public_subnet_cidr[count.index]
  availability_zone = local.azs[count.index]
  map_public_ip_on_launch = true
    tags = {
        Name = "${var.cluster_name}-subnet"
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
        "kubernetes.io/role/elb" = "1"
    }
  
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

    tags = {
        Name = "${var.cluster_name}-igw"
    }
  
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
  count = length(local.azs)

    tags = {
        Name = "${var.cluster_name}-nat-eip"
    }
  
}

resource "aws_nat_gateway" "nat_gw" {
  count = length(local.azs)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id

    tags = {
        Name = "${var.cluster_name}-nat-gw"
    }
  
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
    tags = {
        Name = "${var.cluster_name}-public-rt"
    }
  
}

resource "aws_route_table_association" "public_rt_assoc" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.my_vpc.id
  count = length(local.azs)
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id =aws_nat_gateway.nat_gw[count.index].id 
  }
    tags = {
        Name = "${var.cluster_name}-private-rt"
    }
}
resource "aws_route_table_association" "private_rt_assoc" {
  count          = length(var.private_subnet_cidr)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt[count.index].id
}