variable "env_name" {

}

variable "is_public" {
  type    = bool
  default = false
}

variable "internet_gateway_id" {
  type    = string
  default = ""
}

variable "nat_gateway_id" {
  type    = string
  default = ""
}

variable "vpc_id" {

}
