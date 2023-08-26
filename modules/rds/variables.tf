variable "sub_ids" {
}

variable "storage" {
  default = 20
}
variable "db_name" {
  default = "jhcdb"
}
variable "username" {
  default = "javahome"
}
variable "password" {
  default = "JavaHome3214"
}
variable "vpc_id" {
}
variable "rds_ingress_rules" {
  type = map(object({
    port        = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
}
