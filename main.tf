module "vpc" {
  source   = "./vpc"
  env_name = var.env_name
  vpc_cidr = "10.0.0.0/16"
}

module "public_route_table" {
  source              = "./route-table"
  vpc_id              = module.vpc.vpc_id
  env_name            = var.env_name
  is_public           = true
  internet_gateway_id = module.vpc.internet_gateway_id
}
module "nat" {
  source    = "./nat"
  subnet_id = module.subnet.public_subnet_ids[0]
}
module "private_route_table" {
  source         = "./route-table"
  vpc_id         = module.vpc.vpc_id
  env_name       = var.env_name
  is_public      = false
  nat_gateway_id = module.nat.nat_id
  #internet_gateway_id = module.vpc.internet_gateway_id
}

module "subnet" {
  source   = "./subnet"
  env_name = var.env_name
  vpc_id   = module.vpc.vpc_id
  subnets = {
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
      availability_zone = "us-east-1a"
    }
    subnet4 = {
      name              = "Subnet4"
      type              = "private"
      cidr_block        = "10.0.3.0/24"
      availability_zone = "us-east-1b"
    }
  }
  public_rtb_id  = module.public_route_table.route_table_id
  private_rtb_id = module.private_route_table.route_table_id
}

module "proxy" {
  source           = "./proxy"
  env_name         = var.env_name
  instance_name    = "${var.env_name}-proxy"
  instance_type    = "t2.micro"
  subnet_id        = module.subnet.public_subnet_ids
  security_groups  = module.vpc.default_sg_id
  private_key_path = "./terra.pem"
  vpc_id           = module.vpc.vpc_id
  config = [
    "sudo apt-get update",
    "sudo apt-get install -y nginx",
    "sudo sed -i '52iproxy_pass http://${module.private_load_balancer.dns_name}/;' /etc/nginx/sites-available/default",
    "sudo systemctl reload nginx"
  ]

}

module "backend" {
  source           = "./backend"
  instance_name    = "${var.env_name}-server"
  env_name         = var.env_name
  instance_type    = "t2.micro"
  subnet_id        = module.subnet.private_subnet_ids
  security_groups  = module.vpc.default_sg_id
  private_key_path = "./terra.pem"
  vpc_id           = module.vpc.vpc_id
  config           = <<-EOF
    #!/bin/bash
    apt update -y && apt install apache2 -y
    systemctl start apache2
  EOF
}

module "private_load_balancer" {
  source              = "./loadbalacer"
  env_name            = var.env_name
  subnet_id           = module.subnet.public_subnet_ids
  security_groups     = module.vpc.default_sg_id
  vpc_id              = module.vpc.vpc_id
  load_balancer_type  = "application"
  internal            = true
  port                = 80
  protocol            = "HTTP"
  default_action_type = "forward"
  target_ids          = module.backend.server_ids
  target_group_name   = "${var.env_name}-private-tg"
  load_balancer_name  = "${var.env_name}-private-lb"

}

module "public_load_balancer" {
  source              = "./loadbalacer"
  env_name            = var.env_name
  subnet_id           = module.subnet.public_subnet_ids
  security_groups     = module.vpc.default_sg_id
  vpc_id              = module.vpc.vpc_id
  load_balancer_type  = "application"
  internal            = false
  port                = 80
  protocol            = "HTTP"
  default_action_type = "forward"
  target_ids          = module.proxy.server_ids
  target_group_name   = "${var.env_name}-public-tg"
  load_balancer_name  = "${var.env_name}-public-lb"


}


resource "null_resource" "local_exec" {
  count = length(module.proxy.server_ips)
  provisioner "local-exec" {

    command = "echo public-ip${count.index + 1} ${module.proxy.server_ips[count.index]} > all-ips.txt"
  }
}
