data "aws_ami" "latest_ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["*ubuntu/images/hvm-ssd/ubuntu-jammy-*"]
  }
  owners = ["099720109477"]
}

output "latest_ubuntu_ami_id" {
  value = data.aws_ami.latest_ubuntu.id
}

resource "aws_instance" "server" {
  count                  = length(var.subnet_id)
  ami                    = data.aws_ami.latest_ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id[count.index]
  vpc_security_group_ids = [var.security_groups]
  key_name               = "terra"
  tags = {
    Name = var.instance_name
  }

  user_data = var.config
}

