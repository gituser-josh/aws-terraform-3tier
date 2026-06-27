# === DB サブネットグループ(RDS は 2AZ 分のサブネットが必須) ===

resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.db_subnet_ids

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

# === RDS PostgreSQL ===

resource "aws_db_instance" "main" {
  identifier     = "${var.project_name}-postgres"
  engine         = "postgres"
  engine_version = "16"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_encrypted = true

  db_name  = "mydb"
  username = var.db_username
  password = var.db_password #sensitive 変数　→ terraform.tfvars から注入

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.db_sg_id]

  publicly_accessible = false #private subnet 内のみ
  multi_az            = false # 学習用(本番は true が定石)
  skip_final_snapshot = true  #学習用：destroy 時のスナップショット省略

  tags = {
    Name = "${var.project_name}-postgres"
  }
}