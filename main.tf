module "jhc_vpc" {
  source       = "./modules/networking"
  subnet_count = 3
  pub_cidrs    = ["10.20.0.0/24", "10.20.1.0/24", "10.20.2.0/24"]
  pri_cidrs    = ["10.20.3.0/24", "10.20.4.0/24", "10.20.5.0/24"]
  vpc_tags = {
    Name     = "jhc-app"
    Location = "Banglore"
  }
}
# Create RDS
module "jhc_rds" {
  source  = "./modules/rds"
  sub_ids = module.jhc_vpc.pri_sub_ids
  vpc_id  = module.jhc_vpc.vpc_id
  rds_ingress_rules = {
    "3306" = {
      port        = 3306
      protocol    = "tcp"
      cidr_blocks = ["10.20.0.0/16"]
      description = "allow ssh within organization"
    }
  }
}
