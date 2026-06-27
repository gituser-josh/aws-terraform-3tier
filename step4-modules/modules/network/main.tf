# === VPC ===

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# === Subnets (Phase 1 と同じ 4 つ構成) ===

# Public subnet(web tier)
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.az_primary
  map_public_ip_on_launch = true # ここで起動する EC2 に自動でパブリック IP

  tags = {
    Name = "${var.project_name}-public-subnet"
  }
}

# Private subnet (app tier)
resource "aws_subnet" "private_app" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_app_cidr
  availability_zone = var.az_primary

  tags = {
    Name = "${var.project_name}-private-subnet-app"
  }
}

# Private subnet ( db tier ・ AZ-a)
resource "aws_subnet" "private_db" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_db_cidr
  availability_zone = var.az_primary

  tags = {
    Name = "${var.project_name}-private-subnet-db"
  }
}

# Private subnet (db tier ・ AZ-c: RDS サブネットグループは 2 AZ 必須)
resource "aws_subnet" "private_db2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_db2_cidr
  availability_zone = var.az_secondary

  tags = {
    Name = "${var.project_name}-private-subnet-db2"
  }
}

# === Internaet Gateway ===

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# === Route Tables ===

# Public RT : IGW へのデフォルトルート付き
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# Private RT: ローカルルートのみ(外向きルートなし)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-private-rt"
  }
}

# === RT とサブネットの紐づけ ===

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_app" {
  subnet_id      = aws_subnet.private_app.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_db" {
  subnet_id      = aws_subnet.private_db.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_db2" {
  subnet_id      = aws_subnet.private_db2.id
  route_table_id = aws_route_table.private.id
} # === Web tier SG: インターネットからHTTPを受ける ===

resource "aws_security_group" "web" {
  name        = "${var.project_name}-web-sg"
  description = "Web tier: HTTP from internet"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "ALL outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-web-sg"
  }
}

# === App tier SG: web-sg からのみ受ける ===

resource "aws_security_group" "app" {
  name        = "${var.project_name}-app-sg"
  description = "App tier: HTTP from web tier only"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "HTTP from web-sg"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id] # CIDR でなく SG 参照！
  }

  ingress {
    description     = "ICMP from web-sg (connectivity test)"
    from_port       = -1
    to_port         = -1
    protocol        = "icmp"
    security_groups = [aws_security_group.web.id]
  }

  egress {
    description = "ALL outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-app-sg"
  }
}

# === DB tier SG: app-sg からのみ PostgreSQL を受ける ===

resource "aws_security_group" "db" {
  name        = "${var.project_name}-db-sg"
  description = "DB tier: PostgreSQL from app tier only"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "PostgreSQL from app-sg"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  egress {
    description = "ALL outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-db-sg"
  }
}