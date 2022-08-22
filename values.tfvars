create_vpc = true

region = "ap-south-1"

number_of_azs = 3

vpc_name = "supernovaone"

vpc_cidr = "10.7.0.0/16"

private_subnets = ["10.7.0.0/19", "10.7.64.0/19", "10.7.128.0/19"]

public_subnets = ["10.7.32.0/19", "10.7.96.0/19", "10.7.160.0/19"]

enable_nat_gateway = false

single_nat_gateway = false

tags = {
    Owner = "Burhan"
    terraform = true
}


enable_flow_log = false

create_flow_log_cloudwatch_iam_role = true

create_flow_log_cloudwatch_log_group = true

flow_log_max_aggregation_interval = 60

vpc_flow_log_tags = {
  Name = "vpc-flow-logs-cloudwatch-logs-default"
}