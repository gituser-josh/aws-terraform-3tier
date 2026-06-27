# === Network : VPC + サブネット + SGチェーン ===

module "network" {
  source = "../../modules/network"

  project_name            = var.project_name
  vpc_cidr                = var.vpc_cidr
  public_subnet_cidr      = var.public_subnet_cidr
  private_subnet_app_cidr = var.private_subnet_app_cidr
  private_subnet_db_cidr  = var.private_subnet_db_cidr
  private_subnet_db2_cidr = var.private_subnet_db2_cidr
  az_primary              = var.az_primary
  az_secondary            = var.az_secondary
}

# === Compute: EC2 web / app ===

module "compute" {
  source = "../../modules/compute"

  project_name  = var.project_name
  instance_type = var.instance_type

  public_subnet_id      = module.network.public_subnet_id
  private_app_subnet_id = module.network.private_app_subnet_id
  web_sg_id             = module.network.web_sg_id
  app_sg_id             = module.network.app_sg_id
}

# === Database: RDS PostgreSQL ===

module "database" {
  source = "../../modules/database"

  project_name = var.project_name
  db_username  = var.db_username
  db_password  = var.db_password

  db_subnet_ids = module.network.private_db_subnet_ids
  db_sg_id      = module.network.db_sg_id
}