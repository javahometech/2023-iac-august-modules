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
    "app1" = {
      port            = 3306
      protocol        = "tcp"
      cidr_blocks     = []
      description     = "allow ssh within organization"
      security_groups = [module.webapp.security_group_id]
    }
  }
}
# Launch Instance into public subnet
module "webapp" {
  source     = "./modules/ec2"
  ec2_count  = 2
  ami        = "ami-051f7e7f6c2f40dc1"
  key_name   = "hari-iac"
  subnet_ids = module.jhc_vpc.pub_sub_ids
  vpc_id     = module.jhc_vpc.vpc_id
  web_ingress_rules = {
    "22" = {
      port        = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "allow ssh within organization"
    },
    "80" = {
      port        = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "allow 80 everywhere"
    }
  }
}
module "myappalb" {
  source     = "./modules/alb"
  vpc_id     = module.jhc_vpc.vpc_id
  subnet_ids = module.jhc_vpc.pub_sub_ids
  alb_ingress_rules = {
    "80" = {
      port        = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "allow 80 everywhere"
    }
  }
  instance_ids = module.webapp.instance_ids
}
