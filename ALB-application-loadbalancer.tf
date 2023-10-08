# Terraform AWS Application Load Balancer (ALB)
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "5.16.0"

  name = "${local.name}-alb"
  load_balancer_type = "application"
  vpc_id = module.vpc.vpc_id
  subnets = [
    module.vpc.public_subnets[0],
    module.vpc.public_subnets[1]
  ]
  security_groups = [module.loadbalancer_sg.this_security_group_id]
  # Listeners
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0 # web TG associated to this listener
    }
  ]  
  # Target Groups
  target_groups = [
    # web Target Group - TG Index = 0
    {
      name_prefix          = "web-"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/web/index.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
      # web Target Group - Targets
      targets = {
        my_web_vm1 = {
          target_id = module.ec2_private.id[0]
          port      = 80
        },
        my_web_vm2 = {
          target_id = module.ec2_private.id[1]
          port      = 80
        }
      }
      tags =local.common_tags # Target Group Tags
    }  
  ]
  tags = local.common_tags # ALB Tags
}
