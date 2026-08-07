module "networking" {
  source                = "../../modules/networking"
  environment            = var.environment
  vpc_cidr               = var.vpc_cidr
  public_subnet_cidrs    = var.public_subnet_cidrs
  private_subnet_cidrs   = var.private_subnet_cidrs
  azs                    = var.azs
  name_prefix            = var.name_prefix
}

module "security_groups" {
  source      = "../../modules/security-groups"
  environment = var.environment
  vpc_id      = module.networking.vpc_id
  name_prefix = var.name_prefix
}

module "launch_template" {
  source        = "../../modules/launch-template"
  environment   = var.environment
  instance_type = var.instance_type
  web_sg_id     = module.security_groups.web_sg_id
  bucket_name   = var.bucket_name
  image_key     = var.image_key
  name_prefix   = var.name_prefix
}

module "alb" {
  source            = "../../modules/alb"
  environment       = var.environment
  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  alb_sg_id         = module.security_groups.alb_sg_id
  name_prefix       = var.name_prefix
}

module "asg" {
  source              = "../../modules/asg"
  environment         = var.environment
  launch_template_id  = module.launch_template.launch_template_id
  target_group_arn    = module.alb.target_group_arn
  private_subnet_ids  = module.networking.private_subnet_ids
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  name_prefix         = var.name_prefix
}

output "website_url" {
  value = "http://${module.alb.alb_dns_name}"
}