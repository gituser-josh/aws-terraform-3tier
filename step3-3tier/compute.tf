# == AMI:最新の Amazon Linux 2023 を動的取得 ===

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

# === App tier EC2 (private subnet・python3 簡易 HTTP サーバー) ===

resource "aws_instance" "app" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_app.id
  vpc_security_group_ids = [aws_security_group.app.id]

  user_data = <<-EOF
        #!/bin/bash
        set -euo pipefail
        echo "<h1>Hello from APP tier</h1><p>Host: $(hostname -f)</p>" > /tmp/index.html
        cd /tmp
        nohup python3 -m http.server 80 > /var/log/simple-http.log 2>&1 &
    EOF

  tags = {
    Name = "${var.project_name}-app-server"
  }
}

# === Web tier EC2（public subnet・nginx + app へのリバースプロキシ）===

resource "aws_instance" "web" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web.id]

  user_data = <<-EOF
    #!/bin/bash
    set -euo pipefail
    dnf install -y nginx
    echo "<h1>Hello from WEB tier</h1><p>Host: $(hostname -f)</p>" > /usr/share/nginx/html/index.html
    cat > /etc/nginx/default.d/app-proxy.conf <<'NGINXCONF'
    location /app/ {
        proxy_pass http://${aws_instance.app.private_ip}/;
    }
    NGINXCONF
    systemctl enable --now nginx
  EOF

  tags = {
    Name = "${var.project_name}-web-server"
  }
}