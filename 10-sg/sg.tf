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
