variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  type = bool
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "region" {
  description = "Region in which the VPC is to be created"
  type        = string
}

variable "number_of_azs" {
  description = "Number of Availability Zones"
  type = number
  default = 3
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = null
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}

variable "one_nat_gateway_per_az" {
  description = "Should be true if you want only one NAT Gateway per availability zone. Requires `var.azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.azs`"
  type        = bool
  default     = false
}

variable "nat_gateway_destination_cidr_block" {
  description = "Used to pass a custom destination route for private NAT Gateway. If not specified, the default 0.0.0.0/0 is used as a destination route."
  type        = string
  default     = "0.0.0.0/0"
}

variable "tags" {
  description = "Tags to add to all resources"
  type        = map
  default     = {
    terraform = true
  }
}

variable "vpc_tags" {
  description = "Additional tags for the VPC"
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = "Additional tags for the private subnets"
  type        = map(string)
  default     = {}
}

variable "public_subnet_tags" {
  description = "Additional tags for the public subnets"
  type        = map(string)
  default     = {}
}

variable "public_subnet_suffix" {
  description = "Suffix to append to public subnets name. standard format for naming subnet: vpcname-subnetname-azs"
  type        = string
  default     = "public"
}

variable "private_subnet_suffix" {
  description = "Suffix to append to private subnets name. standard format for naming subnet: vpcname-subnetname-azs"
  type        = string
  default     = "private"
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_flow_log" {
  description = "Turn on Flow logs for the VPC"
  type        = bool
  default     = false
}

variable "create_flow_log_cloudwatch_iam_role" {
  description = "IAM Role for pushing logs to Cloudwatch log group"
  type        = bool
  default     = false
}

variable "create_flow_log_cloudwatch_log_group" {
  description = "Create a Cloudwatch Log Group"
  type        = bool
  default     = false
}

variable "flow_log_max_aggregation_interval" {
  description = "Time in seconds of the flow logs capture/aggregation window"
  type        = number
  default     = 60
}

variable "vpc_flow_log_tags" {
  description = "Tags for the VPC Flow Log"
  type        = map
  default     = {}
}

variable "enable_public_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for public subnets"
  type        = bool
  default     = false
}

variable "enable_private_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for private subnets"
  type        = bool
  default     = false
}

variable "public_inbound_acl_rules" {
  description = "Public subnets inbound network ACLs"
  type        = list(map(string))
  default     = [{}]
}

variable "public_outbound_acl_rules" {
  description = "Public subnets outbound network ACLs"
  type        = list(map(string))
  default     = [{}]
}

variable "private_inbound_acl_rules" {
  description = "Private subnets inbound network ACLs"
  type        = list(map(string))
  default     = [{}]
}

variable "private_outbound_acl_rules" {
  description = "Public subnets outbound network ACLs"
  type        = list(map(string))
  default     = [{}]
}

variable "create_vpc_endpoints" {
  description = "Turn on to create VPC Endpoints"
  type = bool
  default = false
}

variable "endpoint_subnet" {
  description = "Specify which subnet to create the Endpoints in, Accepted Values - private and public"
  type = string
  default = null
}