/*
* # Compliant & Secure VPC
*
* A wrapper for Hashicorps's VPC module to enhance security and cater to regulatory compliances.
*/

# Get availibility zones in the region
data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  name   = var.name
  region = var.region
  debug = true

  azs = slice(data.aws_availability_zones.available.names, 0, var.subnet_count)

  public_subnets = [
    for k, v in local.azs : cidrsubnet(var.cidr, 3, k)
  ]

  private_subnets = [
    for k, v in local.azs : cidrsubnet(var.cidr, 3, k + var.subnet_count)
  ]

  # opts = {
  #   enable_nat_gateway = false
  #   single_nat_gateway = false
  # }
}
module "base_infra" {
  source = "terraform-aws-modules/vpc/aws"
  # pin version
  version = "5.5.1"

  ################################################################################
  # VPC
  ################################################################################
  create_vpc                           = var.create_vpc
  name                                 = var.name
  cidr                                 = var.cidr
  secondary_cidr_blocks                = var.secondary_cidr_blocks
  instance_tenancy                     = var.instance_tenancy
  azs                                  = length(var.azs) > 0 ? var.azs : local.azs
  enable_dns_hostnames                 = var.enable_dns_hostnames
  enable_dns_support                   = var.enable_dns_support
  enable_network_address_usage_metrics = var.enable_network_address_usage_metrics
  use_ipam_pool                        = var.use_ipam_pool
  ipv4_ipam_pool_id                    = var.ipv4_ipam_pool_id
  ipv4_netmask_length                  = var.ipv4_netmask_length
  enable_ipv6                          = var.enable_ipv6
  ipv6_cidr                            = var.ipv6_cidr
  ipv6_ipam_pool_id                    = var.ipv6_ipam_pool_id
  ipv6_netmask_length                  = var.ipv6_netmask_length
  ipv6_cidr_block_network_border_group = var.ipv6_cidr_block_network_border_group
  vpc_tags                             = var.vpc_tags
  tags                                 = var.tags
  ################################################################################
  # DHCP Options Set
  ################################################################################
  enable_dhcp_options               = var.enable_dhcp_options
  dhcp_options_domain_name          = var.dhcp_options_domain_name
  dhcp_options_domain_name_servers  = var.dhcp_options_domain_name_servers
  dhcp_options_ntp_servers          = var.dhcp_options_ntp_servers
  dhcp_options_netbios_name_servers = var.dhcp_options_netbios_name_servers
  dhcp_options_netbios_node_type    = var.dhcp_options_netbios_node_type
  dhcp_options_tags                 = var.dhcp_options_tags
  ################################################################################
  # Publiс Subnets
  ################################################################################
  public_subnets                                               = length(var.public_subnets) > 0 ? var.public_subnets : local.public_subnets
  public_subnet_assign_ipv6_address_on_creation                = var.public_subnet_assign_ipv6_address_on_creation
  public_subnet_enable_dns64                                   = var.public_subnet_enable_dns64
  public_subnet_enable_resource_name_dns_aaaa_record_on_launch = var.public_subnet_enable_resource_name_dns_aaaa_record_on_launch
  public_subnet_enable_resource_name_dns_a_record_on_launch    = var.public_subnet_enable_resource_name_dns_a_record_on_launch
  public_subnet_ipv6_prefixes                                  = var.public_subnet_ipv6_prefixes
  public_subnet_ipv6_native                                    = var.public_subnet_ipv6_native
  map_public_ip_on_launch                                      = var.map_public_ip_on_launch
  public_subnet_private_dns_hostname_type_on_launch            = var.public_subnet_private_dns_hostname_type_on_launch
  public_subnet_names                                          = var.public_subnet_names
  public_subnet_suffix                                         = var.public_subnet_suffix
  public_subnet_tags                                           = var.public_subnet_tags
  public_subnet_tags_per_az                                    = var.public_subnet_tags_per_az
  public_route_table_tags                                      = var.public_route_table_tags
  ################################################################################
  # Public Network ACLs
  ################################################################################
  public_dedicated_network_acl = var.public_dedicated_network_acl
  public_inbound_acl_rules     = var.public_inbound_acl_rules
  public_outbound_acl_rules    = var.public_outbound_acl_rules
  public_acl_tags              = var.public_acl_tags
  ################################################################################
  # Private Subnets
  ################################################################################
  private_subnets                                               = length(var.private_subnets) > 0 ? var.private_subnets : local.private_subnets
  # private_subnets                                               = var.private_subnets
  private_subnet_assign_ipv6_address_on_creation                = var.private_subnet_assign_ipv6_address_on_creation
  private_subnet_enable_dns64                                   = var.private_subnet_enable_dns64
  private_subnet_enable_resource_name_dns_aaaa_record_on_launch = var.private_subnet_enable_resource_name_dns_aaaa_record_on_launch
  private_subnet_enable_resource_name_dns_a_record_on_launch    = var.private_subnet_enable_resource_name_dns_a_record_on_launch
  private_subnet_ipv6_prefixes                                  = var.private_subnet_ipv6_prefixes
  private_subnet_ipv6_native                                    = var.private_subnet_ipv6_native
  private_subnet_private_dns_hostname_type_on_launch            = var.private_subnet_private_dns_hostname_type_on_launch
  private_subnet_names                                          = var.private_subnet_names
  private_subnet_suffix                                         = var.private_subnet_suffix
  private_subnet_tags                                           = var.private_subnet_tags
  private_subnet_tags_per_az                                    = var.private_subnet_tags_per_az
  private_route_table_tags                                      = var.private_route_table_tags
  ################################################################################
  # Private Network ACLs
  ################################################################################
  private_dedicated_network_acl = var.private_dedicated_network_acl
  private_inbound_acl_rules     = var.private_inbound_acl_rules
  private_outbound_acl_rules    = var.private_outbound_acl_rules
  private_acl_tags              = var.private_acl_tags
  ################################################################################
  # Database Subnets
  ################################################################################
  database_subnets                                               = var.database_subnets
  database_subnet_assign_ipv6_address_on_creation                = var.database_subnet_assign_ipv6_address_on_creation
  database_subnet_enable_dns64                                   = var.database_subnet_enable_dns64
  database_subnet_enable_resource_name_dns_aaaa_record_on_launch = var.database_subnet_enable_resource_name_dns_aaaa_record_on_launch
  database_subnet_enable_resource_name_dns_a_record_on_launch    = var.database_subnet_enable_resource_name_dns_a_record_on_launch
  database_subnet_ipv6_prefixes                                  = var.database_subnet_ipv6_prefixes
  database_subnet_ipv6_native                                    = var.database_subnet_ipv6_native
  database_subnet_private_dns_hostname_type_on_launch            = var.database_subnet_private_dns_hostname_type_on_launch
  database_subnet_names                                          = var.database_subnet_names
  database_subnet_suffix                                         = var.database_subnet_suffix
  create_database_subnet_route_table                             = var.create_database_subnet_route_table
  create_database_internet_gateway_route                         = var.create_database_internet_gateway_route
  create_database_nat_gateway_route                              = var.create_database_nat_gateway_route
  database_route_table_tags                                      = var.database_route_table_tags
  database_subnet_tags                                           = var.database_subnet_tags
  create_database_subnet_group                                   = var.create_database_subnet_group
  database_subnet_group_name                                     = var.database_subnet_group_name
  database_subnet_group_tags                                     = var.database_subnet_group_tags
  ################################################################################
  # Database Network ACLs
  ################################################################################
  database_dedicated_network_acl = var.database_dedicated_network_acl
  database_inbound_acl_rules     = var.database_inbound_acl_rules
  database_outbound_acl_rules    = var.database_outbound_acl_rules
  database_acl_tags              = var.database_acl_tags
  ################################################################################
  # Redshift Subnets
  ################################################################################
  redshift_subnets                                               = var.redshift_subnets
  redshift_subnet_assign_ipv6_address_on_creation                = var.redshift_subnet_assign_ipv6_address_on_creation
  redshift_subnet_enable_dns64                                   = var.redshift_subnet_enable_dns64
  redshift_subnet_enable_resource_name_dns_aaaa_record_on_launch = var.redshift_subnet_enable_resource_name_dns_aaaa_record_on_launch
  redshift_subnet_enable_resource_name_dns_a_record_on_launch    = var.redshift_subnet_enable_resource_name_dns_a_record_on_launch
  redshift_subnet_ipv6_prefixes                                  = var.redshift_subnet_ipv6_prefixes
  redshift_subnet_ipv6_native                                    = var.redshift_subnet_ipv6_native
  redshift_subnet_private_dns_hostname_type_on_launch            = var.redshift_subnet_private_dns_hostname_type_on_launch
  redshift_subnet_names                                          = var.redshift_subnet_names
  redshift_subnet_suffix                                         = var.redshift_subnet_suffix
  enable_public_redshift                                         = var.enable_public_redshift
  create_redshift_subnet_route_table                             = var.create_redshift_subnet_route_table
  redshift_route_table_tags                                      = var.redshift_route_table_tags
  redshift_subnet_tags                                           = var.redshift_subnet_tags
  create_redshift_subnet_group                                   = var.create_redshift_subnet_group
  redshift_subnet_group_name                                     = var.redshift_subnet_group_name
  redshift_subnet_group_tags                                     = var.redshift_subnet_group_tags
  ################################################################################
  # Redshift Network ACLs
  ################################################################################
  redshift_dedicated_network_acl = var.redshift_dedicated_network_acl
  redshift_inbound_acl_rules     = var.redshift_inbound_acl_rules
  redshift_outbound_acl_rules    = var.redshift_outbound_acl_rules
  redshift_acl_tags              = var.redshift_acl_tags
  ################################################################################
  # Elasticache Subnets
  ################################################################################
  elasticache_subnets                                               = var.elasticache_subnets
  elasticache_subnet_assign_ipv6_address_on_creation                = var.elasticache_subnet_assign_ipv6_address_on_creation
  elasticache_subnet_enable_dns64                                   = var.elasticache_subnet_enable_dns64
  elasticache_subnet_enable_resource_name_dns_aaaa_record_on_launch = var.elasticache_subnet_enable_resource_name_dns_aaaa_record_on_launch
  elasticache_subnet_enable_resource_name_dns_a_record_on_launch    = var.elasticache_subnet_enable_resource_name_dns_a_record_on_launch
  elasticache_subnet_ipv6_prefixes                                  = var.elasticache_subnet_ipv6_prefixes
  elasticache_subnet_ipv6_native                                    = var.elasticache_subnet_ipv6_native
  elasticache_subnet_private_dns_hostname_type_on_launch            = var.elasticache_subnet_private_dns_hostname_type_on_launch
  elasticache_subnet_names                                          = var.elasticache_subnet_names
  elasticache_subnet_suffix                                         = var.elasticache_subnet_suffix
  elasticache_subnet_tags                                           = var.elasticache_subnet_tags
  create_elasticache_subnet_route_table                             = var.create_elasticache_subnet_route_table
  elasticache_route_table_tags                                      = var.elasticache_route_table_tags
  create_elasticache_subnet_group                                   = var.create_elasticache_subnet_group
  elasticache_subnet_group_name                                     = var.elasticache_subnet_group_name
  elasticache_subnet_group_tags                                     = var.elasticache_subnet_group_tags
  ################################################################################
  # Elasticache Network ACLs
  ################################################################################
  elasticache_dedicated_network_acl = var.elasticache_dedicated_network_acl
  elasticache_inbound_acl_rules     = var.elasticache_inbound_acl_rules
  elasticache_outbound_acl_rules    = var.elasticache_outbound_acl_rules
  elasticache_acl_tags              = var.elasticache_acl_tags
  ################################################################################
  # Intra Subnets
  ################################################################################
  intra_subnets                                               = var.intra_subnets
  intra_subnet_assign_ipv6_address_on_creation                = var.intra_subnet_assign_ipv6_address_on_creation
  intra_subnet_enable_dns64                                   = var.intra_subnet_enable_dns64
  intra_subnet_enable_resource_name_dns_aaaa_record_on_launch = var.intra_subnet_enable_resource_name_dns_aaaa_record_on_launch
  intra_subnet_enable_resource_name_dns_a_record_on_launch    = var.intra_subnet_enable_resource_name_dns_a_record_on_launch
  intra_subnet_ipv6_prefixes                                  = var.intra_subnet_ipv6_prefixes
  intra_subnet_ipv6_native                                    = var.intra_subnet_ipv6_native
  intra_subnet_private_dns_hostname_type_on_launch            = var.intra_subnet_private_dns_hostname_type_on_launch
  intra_subnet_names                                          = var.intra_subnet_names
  intra_subnet_suffix                                         = var.intra_subnet_suffix
  intra_subnet_tags                                           = var.intra_subnet_tags
  intra_route_table_tags                                      = var.intra_route_table_tags
  ################################################################################
  # Intra Network ACLs
  ################################################################################
  intra_dedicated_network_acl = var.intra_dedicated_network_acl
  intra_inbound_acl_rules     = var.intra_inbound_acl_rules
  intra_outbound_acl_rules    = var.intra_outbound_acl_rules
  intra_acl_tags              = var.intra_acl_tags
  ################################################################################
  # Outpost Subnets
  ################################################################################
  outpost_subnets                                               = var.outpost_subnets
  outpost_subnet_assign_ipv6_address_on_creation                = var.outpost_subnet_assign_ipv6_address_on_creation
  outpost_az                                                    = var.outpost_az
  customer_owned_ipv4_pool                                      = var.customer_owned_ipv4_pool
  outpost_subnet_enable_dns64                                   = var.outpost_subnet_enable_dns64
  outpost_subnet_enable_resource_name_dns_aaaa_record_on_launch = var.outpost_subnet_enable_resource_name_dns_aaaa_record_on_launch
  outpost_subnet_enable_resource_name_dns_a_record_on_launch    = var.outpost_subnet_enable_resource_name_dns_a_record_on_launch
  outpost_subnet_ipv6_prefixes                                  = var.outpost_subnet_ipv6_prefixes
  outpost_subnet_ipv6_native                                    = var.outpost_subnet_ipv6_native
  map_customer_owned_ip_on_launch                               = var.map_customer_owned_ip_on_launch
  outpost_arn                                                   = var.outpost_arn
  outpost_subnet_private_dns_hostname_type_on_launch            = var.outpost_subnet_private_dns_hostname_type_on_launch
  outpost_subnet_names                                          = var.outpost_subnet_names
  outpost_subnet_suffix                                         = var.outpost_subnet_suffix
  outpost_subnet_tags                                           = var.outpost_subnet_tags
  ################################################################################
  # Outpost Network ACLs
  ################################################################################
  outpost_dedicated_network_acl = var.outpost_dedicated_network_acl
  outpost_inbound_acl_rules     = var.outpost_inbound_acl_rules
  outpost_outbound_acl_rules    = var.outpost_outbound_acl_rules
  outpost_acl_tags              = var.outpost_acl_tags
  ################################################################################
  # Internet Gateway
  ################################################################################
  create_igw             = var.create_igw
  create_egress_only_igw = var.create_egress_only_igw
  igw_tags               = var.igw_tags
  ################################################################################
  # NAT Gateway
  ################################################################################
  enable_nat_gateway                 = var.enable_nat_gateway
  nat_gateway_destination_cidr_block = var.nat_gateway_destination_cidr_block
  single_nat_gateway                 = local.debug ? false : var.single_nat_gateway
  one_nat_gateway_per_az             = var.one_nat_gateway_per_az
  reuse_nat_ips                      = var.reuse_nat_ips
  external_nat_ip_ids                = var.external_nat_ip_ids
  external_nat_ips                   = var.external_nat_ips
  nat_gateway_tags                   = var.nat_gateway_tags
  nat_eip_tags                       = var.nat_eip_tags
  ################################################################################
  # Customer Gateways
  ################################################################################
  customer_gateways     = var.customer_gateways
  customer_gateway_tags = var.customer_gateway_tags
  ################################################################################
  # VPN Gateway
  ################################################################################
  enable_vpn_gateway                 = var.enable_vpn_gateway
  vpn_gateway_id                     = var.vpn_gateway_id
  amazon_side_asn                    = var.amazon_side_asn
  vpn_gateway_az                     = var.vpn_gateway_az
  propagate_intra_route_tables_vgw   = var.propagate_intra_route_tables_vgw
  propagate_private_route_tables_vgw = var.propagate_private_route_tables_vgw
  propagate_public_route_tables_vgw  = var.propagate_public_route_tables_vgw
  vpn_gateway_tags                   = var.vpn_gateway_tags
  ################################################################################
  # Default VPC
  ################################################################################
  manage_default_vpc               = var.manage_default_vpc
  default_vpc_name                 = var.default_vpc_name
  default_vpc_enable_dns_support   = var.default_vpc_enable_dns_support
  default_vpc_enable_dns_hostnames = var.default_vpc_enable_dns_hostnames
  default_vpc_tags                 = var.default_vpc_tags
  manage_default_security_group    = var.manage_default_security_group
  default_security_group_name      = var.default_security_group_name
  default_security_group_ingress   = var.default_security_group_ingress
  default_security_group_egress    = var.default_security_group_egress
  default_security_group_tags      = var.default_security_group_tags
  ################################################################################
  # Default Network ACLs
  ################################################################################
  manage_default_network_acl  = var.manage_default_network_acl
  default_network_acl_name    = var.default_network_acl_name
  default_network_acl_ingress = var.default_network_acl_ingress
  default_network_acl_egress  = var.default_network_acl_egress
  default_network_acl_tags    = var.default_network_acl_tags
  ################################################################################
  # Default Route
  ################################################################################
  manage_default_route_table           = var.manage_default_route_table
  default_route_table_name             = var.default_route_table_name
  default_route_table_propagating_vgws = var.default_route_table_propagating_vgws
  default_route_table_routes           = var.default_route_table_routes
  default_route_table_tags             = var.default_route_table_tags
  ################################################################################
  # Flow Log
  ################################################################################
  enable_flow_log                     = var.enable_flow_log
  vpc_flow_log_permissions_boundary   = var.vpc_flow_log_permissions_boundary
  flow_log_max_aggregation_interval   = var.flow_log_max_aggregation_interval
  flow_log_traffic_type               = var.flow_log_traffic_type
  flow_log_destination_type           = var.flow_log_destination_type
  flow_log_log_format                 = var.flow_log_log_format
  flow_log_destination_arn            = var.flow_log_destination_arn
  flow_log_file_format                = var.flow_log_file_format
  flow_log_hive_compatible_partitions = var.flow_log_hive_compatible_partitions
  flow_log_per_hour_partition         = var.flow_log_per_hour_partition
  vpc_flow_log_tags                   = var.vpc_flow_log_tags
  ################################################################################
  # Flow Log CloudWatch
  ################################################################################
  create_flow_log_cloudwatch_log_group            = var.create_flow_log_cloudwatch_log_group
  create_flow_log_cloudwatch_iam_role             = var.create_flow_log_cloudwatch_iam_role
  flow_log_cloudwatch_iam_role_arn                = var.flow_log_cloudwatch_iam_role_arn
  flow_log_cloudwatch_log_group_name_prefix       = var.flow_log_cloudwatch_log_group_name_prefix
  flow_log_cloudwatch_log_group_name_suffix       = var.flow_log_cloudwatch_log_group_name_suffix
  flow_log_cloudwatch_log_group_retention_in_days = var.flow_log_cloudwatch_log_group_retention_in_days
  flow_log_cloudwatch_log_group_kms_key_id        = var.flow_log_cloudwatch_log_group_kms_key_id
}
