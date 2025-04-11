resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc.cidr_block
  enable_dns_support   = var.vpc.enable_dns_support
  enable_dns_hostnames = var.vpc.enable_dns_hostnames

  tags = {
    Name = local.tag-name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw-${local.tag-name}"
  }
}

# Subnets públicas
resource "aws_subnet" "public" {
  count = 2

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "172.16.${count.index}.0/24"
  availability_zone       = element(["us-east-1a", "us-east-1b"], count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.tag-name}-public-subnet-${count.index + 1}"
  }
}

# Subnets privadas
resource "aws_subnet" "private" {
  count = 2

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "172.16.${count.index + 2}.0/24"
  availability_zone = element(["us-east-1a", "us-east-1b"], count.index)

  tags = {
    Name = "${local.tag-name}-private-subnet-${count.index + 1}"
  }
}

# Tabela de rotas pública
resource "aws_route_table" "rtb_publica" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${local.tag-name}-rtb-publica"
  }
}

# Tabela de rotas privada
resource "aws_route_table" "rtb_privada" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${local.tag-name}-rtb-privada"
  }
}

# Associação da route table pública com subnets públicas
resource "aws_route_table_association" "rta_publica" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.rtb_publica.id
}

# Associação da route table privada com subnets privadas
resource "aws_route_table_association" "rta_privada" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.rtb_privada.id
}

# Elastic IP para o NAT Gateway
resource "aws_eip" "nat_eip" {
  tags = {
    Name = "${local.tag-name}-nat-eip"
  }
}

# NAT Gateway em subnet pública
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${local.tag-name}-nat-gw"
  }

  depends_on = [aws_internet_gateway.igw]
}

# Rota privada apontando para o NAT Gateway
resource "aws_route" "rtb_privada_nat" {
  route_table_id         = aws_route_table.rtb_privada.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# Security Group para liberar HTTP (e opcionalmente HTTPS)
resource "aws_security_group" "security_group" {
  name        = "${local.tag-name}-security-group"
  description = "libera porta http (e opcionalmente https)"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
