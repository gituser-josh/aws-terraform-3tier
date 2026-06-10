# === Web tier SG: インターネットからHTTPを受ける ===

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