module "mysql_sg" {
    source = "git::https://github.com/soumya816-us/terraform-aws-security-group.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    sg_name = "mysql"
    sg_description = "created for Mysql instances in dev"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags

}
#created for backend purpose in dev
module "backend_sg" {
    source = "git::https://github.com/soumya816-us/terraform-aws-security-group.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    sg_name = "backend"
    sg_description = "created for backend instances in expense dev"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags

}
#created for frontend purpose in dev
module "frontend_sg" {
    source = "git::https://github.com/soumya816-us/terraform-aws-security-group.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    sg_name = "frontend"
    sg_description = "created for frontend instances in expense dev"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags

}
#created for bastion purpose in dev
module "bastion_sg" {
    source = "git::https://github.com/soumya816-us/terraform-aws-security-group.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    sg_name = "bastion"
    sg_description = "created for bastion instances in expense dev"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags

}
#open vpn ports are 22,443,1194,943
module "vpn_sg" {
    source = "git::https://github.com/soumya816-us/terraform-aws-security-group.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    sg_name = "vpn"
    sg_description = "created for bastion instances in expense dev"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags

}

#created for application load balancer security group
module "app_alb_sg" {
    source = "git::https://github.com/soumya816-us/terraform-aws-security-group.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    sg_name = "app_alb"
    sg_description = "created for application load balancer sg"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = var.common_tags

}

resource "aws_security_group_rule" "app-alb-bastion" {
  type              = "ingress"
  from_port         = 0
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id = module.app_alb_sg.sg_id
}

resource "aws_security_group_rule" "bastion-public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.bastion_sg.sg_id
}

#to manage vpn port no : 22
resource "aws_security_group_rule" "vpn-ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn_sg.sg_id
}
resource "aws_security_group_rule" "vpn-443" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn_sg.sg_id
}

resource "aws_security_group_rule" "vpn-943" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn_sg.sg_id
}
resource "aws_security_group_rule" "vpn-1194" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn_sg.sg_id
}
#app alb accepting traffic from vpn
resource "aws_security_group_rule" "app_alb_vpn" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.app_alb_sg.sg_id
}

#accepting traffic from mysql to bastion
resource "aws_security_group_rule" "mysql_bastion" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.sg_id
  security_group_id = module.mysql_sg.sg_id
}

# resource "aws_security_group_rule" "mysql_vpn" {
#   type              = "ingress"
#   from_port         = 3306
#   to_port           = 3306
#   protocol          = "tcp"
#   source_security_group_id = module.vpn_sg.sg_id
#   security_group_id = module.mysql_sg.sg_id
# }


