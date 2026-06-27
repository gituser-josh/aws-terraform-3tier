resource "aws_vpc" "imported" {
  cidr_block = "10.99.0.0/16"

  tags = {
    Name      = "imported-vpc"
    CreatedBy = "manual-cli"
  }
}