variable "vpc_cidr" {
  default = "10.20.0.0/16"
}
variable "vpc_tags" {
  default = {
    Name = "app-vpc"
  }
}
variable "subnet_count" {
  default = 2
}

variable "pub_cidrs" {
  default = ["10.20.0.0/24", "10.20.1.0/24"]
}
variable "pri_cidrs" {
  default = ["10.20.2.0/24", "10.20.3.0/24"]
}


