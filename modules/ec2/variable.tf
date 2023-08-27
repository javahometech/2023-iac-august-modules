variable "ec2_count" {
  default = 1
}

variable "ami" {
}
variable "public_ip" {
  default = true
}
variable "instance_type" {
  default = "t2.micro"
}
variable "subnet_ids" {
}
variable "key_name" {

}
variable "web_ingress_rules" {
  type = map(object({
    port        = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
}
variable "vpc_id" {

}
