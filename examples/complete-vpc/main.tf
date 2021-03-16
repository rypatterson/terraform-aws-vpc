provider "aws" {
  region = "us-east-2"
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.vpc.vpc_id
}

module "vpc" {
  source = "../../"

  name = "dev"

  cidr = "20.10.0.0/16" # 10.0.0.0/8 is reserved for EC2-Classic

  azs                 = ["us-east-2a", "us-east-2b", "us-east-2c"]
  private_subnets     = ["20.10.1.0/24", "20.10.2.0/24", "20.10.3.0/24"]
  public_subnets      = ["20.10.11.0/24", "20.10.12.0/24", "20.10.13.0/24"]
  database_subnets    = ["20.10.21.0/24", "20.10.22.0/24", "20.10.23.0/24"]
#  elasticache_subnets = ["20.10.31.0/24", "20.10.32.0/24", "20.10.33.0/24"]
#  redshift_subnets    = ["20.10.41.0/24", "20.10.42.0/24", "20.10.43.0/24"]
#  intra_subnets       = ["20.10.51.0/24", "20.10.52.0/24", "20.10.53.0/24"]

  create_database_subnet_group = false

  manage_default_route_table = true
  default_route_table_tags   = { DefaultRouteTable = true }

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_classiclink             = false
  enable_classiclink_dns_support = false

  enable_nat_gateway = true
  single_nat_gateway = true

  customer_gateways = {
    IP1 = {
      bgp_asn    = 65112
      ip_address = "1.2.3.4"
    },
    IP2 = {
      bgp_asn    = 65112
      ip_address = "5.6.7.8"
    }
  }

  enable_vpn_gateway = true

  enable_dhcp_options              = true
  dhcp_options_domain_name         = "service.consul"
  dhcp_options_domain_name_servers = ["127.0.0.1", "10.10.0.2"]

/*
  # VPC endpoint for S3
  # Note - S3 Interface type support is only available on AWS provider 3.10 and later
  enable_s3_endpoint              = false
  s3_endpoint_type                = "Interface"
  s3_endpoint_private_dns_enabled = false
  s3_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC endpoint for DynamoDB
  enable_dynamodb_endpoint = false
  dynamodb_endpoint_policy = data.aws_iam_policy_document.dynamodb_endpoint_policy.json

  # VPC endpoint for SSM
  enable_ssm_endpoint              = false
  ssm_endpoint_private_dns_enabled = false
  ssm_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC endpoint for Lambda
  enable_lambda_endpoint              = false
  lambda_endpoint_private_dns_enabled = false
  lambda_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC endpoint for SSMMESSAGES
  enable_ssmmessages_endpoint              = false
  ssmmessages_endpoint_private_dns_enabled = false
  ssmmessages_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC Endpoint for EC2
  enable_ec2_endpoint              = false
  ec2_endpoint_policy              = data.aws_iam_policy_document.generic_endpoint_policy.json
  ec2_endpoint_private_dns_enabled = false
  ec2_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC Endpoint for EC2MESSAGES
  enable_ec2messages_endpoint              = false
  ec2messages_endpoint_private_dns_enabled = false
  ec2messages_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC Endpoint for ECR API
  enable_ecr_api_endpoint              = true
  ecr_api_endpoint_policy              = data.aws_iam_policy_document.generic_endpoint_policy.json
  ecr_api_endpoint_private_dns_enabled = true
  ecr_api_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC Endpoint for ECR DKR
  enable_ecr_dkr_endpoint              = true
  ecr_dkr_endpoint_policy              = data.aws_iam_policy_document.generic_endpoint_policy.json
  ecr_dkr_endpoint_private_dns_enabled = true
  ecr_dkr_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC endpoint for KMS
  enable_kms_endpoint              = true
  kms_endpoint_private_dns_enabled = true
  kms_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC endpoint for ECS
  enable_ecs_endpoint              = true
  ecs_endpoint_private_dns_enabled = true
  ecs_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC endpoint for ECS telemetry
  enable_ecs_telemetry_endpoint              = true
  ecs_telemetry_endpoint_private_dns_enabled = true
  ecs_telemetry_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC endpoint for CodeDeploy
  enable_codedeploy_endpoint              = true
  codedeploy_endpoint_private_dns_enabled = true
  codedeploy_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC endpoint for CodeDeploy Commands Secure
  enable_codedeploy_commands_secure_endpoint              = true
  codedeploy_commands_secure_endpoint_private_dns_enabled = true
  codedeploy_commands_secure_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # Default security group - ingress/egress rules cleared to deny all
  manage_default_security_group  = true
  default_security_group_ingress = []
  default_security_group_egress  = []
*/


  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = false
  create_flow_log_cloudwatch_log_group = false
  create_flow_log_cloudwatch_iam_role  = false
  flow_log_max_aggregation_interval    = 60

  tags = {
    Owner       = "user"
    Environment = "dev"
    Name        = "dev"
  }

  vpc_endpoint_tags = {
    Project  = "Secret"
    Endpoint = "false"
  }
}
