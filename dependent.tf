data "aws_iam_policy_document" "generic_endpoint_policy" {

  count = var.create_vpc_endpoints == true ? 1 : 0
  
  statement {
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "StringNotEquals"
      variable = "aws:SourceVpc"

      values = [module.vpc.vpc_id]
    }
  }
}


resource "aws_security_group" "generic" {

  count = var.create_vpc_endpoints == true ? 1 : 0

  name_prefix = "vpc_endpoints_generic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    description = "Allow Outbound Any Traffic"
    from_port = 0
    to_port   = 0
    protocol = -1
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

}