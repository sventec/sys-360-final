# network configuration

resource "aws_vpc" "lamp-vpc" {
  cidr_block = "10.10.0.0/16"
  tags       = { Name = "lamp-vpc" }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.lamp-vpc.id
  cidr_block = "10.10.15.0/24"
  tags       = { Name = "lamp-private" }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.lamp-vpc.id
  cidr_block              = "10.10.10.0/24"
  tags                    = { Name = "lamp-public" }
  map_public_ip_on_launch = true # map public IPs on launch
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.lamp-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "public-route-table" }
}

resource "aws_main_route_table_association" "public-route-table-assoc" {
  vpc_id         = aws_vpc.lamp-vpc.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_nat_gateway" "public-natgw" {
  subnet_id         = aws_subnet.public.id
  connectivity_type = "public"
  allocation_id     = aws_eip.public-natgw-eip.id
  depends_on        = [aws_internet_gateway.igw]
  tags              = { Name = "public-natgw" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.lamp-vpc.id
  tags   = { Name = "lamp-igw" }
}

resource "aws_eip" "public-natgw-eip" {
  depends_on = [aws_internet_gateway.igw]
  tags       = { Name = "natgw-eip" }
}

resource "aws_eip" "webserver-eip" {
  depends_on = [aws_internet_gateway.igw]
  instance   = module.webserver.webserver_id
  tags       = { Name = "webserver-eip" }
}

resource "aws_eip" "jumpbox-eip" {
  depends_on = [aws_internet_gateway.igw]
  instance   = module.jumpbox.jumpbox_id
  tags       = { Name = "jumpbox-eip" }
}
