module "vpc" {

  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  create_vpc             = var.create_vpc
  name                   = var.vpc_name
  cidr                   = var.vpc_cidr
  azs                    = local.azs
  private_subnets        = var.private_subnets
  public_subnets         = var.public_subnets
  private_subnet_suffix  = var.private_subnet_suffix
  public_subnet_suffix   = var.public_subnet_suffix
  enable_dns_hostnames   = var.enable_dns_hostnames
  enable_dns_support     = var.enable_dns_support
  tags                   = var.tags
  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az

  enable_flow_log                      = var.enable_flow_log
  create_flow_log_cloudwatch_log_group = var.create_flow_log_cloudwatch_log_group
  create_flow_log_cloudwatch_iam_role  = var.create_flow_log_cloudwatch_iam_role
  flow_log_max_aggregation_interval    = var.flow_log_max_aggregation_interval
  vpc_flow_log_tags                    = var.vpc_flow_log_tags

  public_dedicated_network_acl  = var.enable_public_dedicated_network_acl
  private_dedicated_network_acl = var.enable_private_dedicated_network_acl
  public_inbound_acl_rules      = var.public_inbound_acl_rules
  public_outbound_acl_rules     = var.public_outbound_acl_rules
  private_inbound_acl_rules     = var.private_inbound_acl_rules
  private_outbound_acl_rules    = var.private_outbound_acl_rules

}

module "vpc_endpoints" {

  source = "./modules/vpc-endpoints-module"

  count = var.create_vpc_endpoints == true ? 1 : 0

  vpc_id = module.vpc.vpc_id

  endpoints = { for config in try(local.endpoint_config, []) : config.name => {
    service             = config.service
    service_type        = config.service_type
    create              = config.create
    private_dns_enabled = try(config.private_dns_enabled, null)
    subnet_ids          = config.service_type == "Interface" || config.service_type == "GatewayLoadBalancer" ? try(config.subnet_ids, var.endpoint_subnet == "private" ? module.vpc.private_subnets : module.vpc.public_subnets) : null
    route_table_ids     = config.service_type == "Gateway" ? flatten([module.vpc.private_route_table_ids, module.vpc.public_route_table_ids]) : null
    tags                = try(config.tags, null)
    security_group_ids  = config.service_type == "Interface" ? config.attach_generic_security_group == true ? [aws_security_group.generic[0].id] : [] : []
    policy              = config.attach_generic_policy == true ? data.aws_iam_policy_document.generic_endpoint_policy[0].json : null

    }
  }

  depends_on = [module.vpc]

}
