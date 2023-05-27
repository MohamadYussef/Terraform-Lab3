variable "env_name" {

}

variable "vpc_id" {

}

variable "subnets" {
  type = map(object({
    name              = string
    type              = string
    cidr_block        = string
    availability_zone = string
  }))
  default = {
    subnet1 = {
      name              = "Subnet1"
      type              = "public"
      cidr_block        = "10.0.0.0/24"
      availability_zone = "us-east-1a"
    }
    subnet2 = {
      name              = "Subnet2"
      type              = "public"
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1b"
    }
    subnet3 = {
      name              = "Subnet3"
      type              = "private"
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-1c"
    }
    subnet4 = {
      name              = "Subnet4"
      type              = "private"
      cidr_block        = "10.0.3.0/24"
      availability_zone = "us-east-1d"
    }
  }
}

variable "public_rtb_id" {

}

variable "private_rtb_id" {

}
