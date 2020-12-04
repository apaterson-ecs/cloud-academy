variable "access_key" {}
variable "secret_key" {}

variable "region" {
  default = "eu-west-1"
}

variable "vpc_cidr" {
  default = "10.1.0.0/20"
}

variable "subnet_cidr_web" {
  default = "10.1.1.0/24"
}

variable "subnet_cidr_app" {
  default = "10.1.2.0/24"
}

variable "subnet_cidr_data" {
  default = "10.1.3.0/24"
}

variable "subnet_cidr_data_b" {
  default = "10.1.4.0/24"
}

variable "subnet_az" {
  default = "eu-west-1a"
}

variable "subnet_az_b" {
  default = "eu-west-1b"
}

variable "internet_cidr" {
  default = "0.0.0.0/0"
}

variable "instance_type" {
  default = "t2.micro"
}