resource "aws_db_subnet_group" "db" {
  name       = "rds-subnet-group"
  subnet_ids = var.sub_ids

  tags = {
    Name = "rds-subnet-group"
  }
}
# Create RDS Instance 
resource "aws_db_instance" "default" {
  allocated_storage      = var.storage
  db_name                = var.db_name
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  username               = var.username
  password               = var.password
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.db.name
  vpc_security_group_ids = [aws_security_group.rds.id]
}
# Security Group
resource "aws_security_group" "rds" {
  name        = "allow traffic for RDS"
  description = "Allow inbound traffic"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.rds_ingress_rules
    content {
      description     = "some description"
      from_port       = ingress.value.port
      to_port         = ingress.value.port
      protocol        = ingress.value.protocol
      cidr_blocks     = ingress.value.cidr_blocks
      security_groups = ingress.value.security_groups
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "rds_security_rules"
  }
}
