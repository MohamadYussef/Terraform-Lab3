variable "env_name" {

}

variable "subnet_id" {


}

variable "security_groups" {

}

variable "vpc_id" {

}

variable "load_balancer_name" {

}

variable "target_group_name" {

}


variable "load_balancer_type" {
  type    = string
  default = "application"
}

variable "internal" {
  type = bool

}

variable "port" {
  type    = number
  default = 80
}

variable "protocol" {
  default = "HTTP"

}

variable "default_action_type" {
  default = "forward"
}

variable "target_ids" {

}
