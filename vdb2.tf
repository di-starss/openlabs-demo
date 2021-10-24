/**
    OpenLabs/Ops/VDB[1,2]
**/

// ACCESS
// ---------------------------------------------------------------------------------------------------------------------
variable "os_auth_url" {}
variable "os_user_name" {}
variable "os_tenant_name" {}
variable "os_password" {}
variable "os_region" {}

variable "nbx_server_url" {}
variable "nbx_api_token" {}
variable "nbx_allow_insecure_https" {}

variable "dns_server_url" {}
variable "dns_api_key" {}

// CONSUL
// ---------------------------------------------------------------------------------------------------------------------
variable "consul_host" { default = "consul.openlabs.vspace307.io" }
variable "consul_port" { default = 8500 }
variable "consul_schema" { default = "http" }
variable "consul_dc" { default = "rg1" }

// VDB
// ---------------------------------------------------------------------------------------------------------------------
variable "env" { default = "ops" }
variable "project" { default = "vdb" }

variable "service_core0" { default = "core1" }
variable "service_core1" { default = "core2" }

// mgmt
variable "mgmt_user" { default = "debian" }
variable "mgmt_public_key" { default = "~/.ssh/id_rsa.pub" }
variable "mgmt_private_key" { default = "~/.ssh/id_rsa" }

// flavor
variable "flavor_vdb_master" { default = "vdb-master" }
variable "flavor_vdb_slave" { default = "vdb-slave" }
variable "flavor_vdb_delay" { default = "vdb-delay" }
variable "flavor_vdb_sysbench" { default = "vdb-sysbench" }

// network
variable "router_ams" { default = "ams-ops-vdb" }
variable "router_ldn" { default = "ldn-ops-vdb" }

variable "net_ams_vdb_master" { default = "ams-ops-vdb-master" }
variable "net_ams_vdb_slave" { default = "ams-ops-vdb-slave" }
variable "net_ldn_vdb_delay" { default = "ldn-ops-vdb-delay" }

variable "subnet_ams_vdb_master" { default = "172.19.16.0/24" }
variable "subnet_ams_vdb_slave" { default = "172.19.17.0/24" }
variable "subnet_ldn_vdb_delay" { default = "172.20.16.0/24" }

// volume
variable "volume_type_master" { default = "ams-ssd-rack-5" }
variable "volume_type_slave" { default = "ams-ssd-rack-6" }
variable "volume_type_delay" { default = "ldn-ssd-rack-17" }
variable "volume_type_sysbench" { default = "ams-ssd-rack-5" }

variable "disk_boot_size" { default = 10 }
variable "disk_data_size_master" { default = 15 }
variable "disk_data_size_slave" { default = 15 }
variable "disk_data_size_delay" { default = 15 }

// vdb
variable "vdb_root_password" { default = "password123123" }
variable "vdb_mgmt_user" { default = "mgmt" }
variable "vdb_mgmt_password" { default = "password123123" }

variable "vdb_innodb_flush_log_at_trx_commit" { default = 0 }
variable "vdb_innodb_file_per_table" { default = 1 }
variable "vdb_innodb_log_file_size" { default = "512M" }
variable "vdb_innodb_buffer_pool_size" { default = "512M" }

variable "vdb_delay_0" { default = "3600" }
variable "vdb_delay_1" { default = "7200" }
variable "vdb_delay_2" { default = "10800" }

// meta
variable "vdb_meta" { default = true }
variable "vdb_meta_data_url" { default = "http://meta.db.vspace307.io/meta/core.yaml" }
variable "vdb_meta_client_url" { default = "http://meta.db.vspace307.io/client/meta-db-client" }

// sysbench
variable "vdb_sysbench" { default = true }

variable "sysbench_tables" { default = 100 }
variable "sysbench_table_size" { default = 1000 }
variable "sysbench_time" { default = 60 }


// PROVIDER
// ---------------------------------------------------------------------------------------------------------------------
terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
    }
    netbox = {
      source = "e-breuninger/netbox"
    }
    powerdns = {
      source = "ag-TJNII/powerdns"
    }
    consul = {
      source = "hashicorp/consul"
    }
  }
}

provider "openstack" {
  auth_url    = var.os_auth_url
  tenant_name = var.os_tenant_name
  user_name   = var.os_user_name
  password    = var.os_password
  region      = var.os_region
}

provider "netbox" {
  server_url           = var.nbx_server_url
  api_token            = var.nbx_api_token
  allow_insecure_https = var.nbx_allow_insecure_https
}

provider "powerdns" {
  server_url  = var.dns_server_url
  api_key     = var.dns_api_key
}

provider "consul" {
  address    = local.consul_url
  datacenter = var.consul_dc
}

locals {
  consul_url = "${var.consul_schema}://${var.consul_host}:${var.consul_port}"
}


// MODULE
// ---------------------------------------------------------------------------------------------------------------------
module "vdb_core1" {
  source = "github.com/di-starss/vspace307-vdb"

  // consul
  consul_host = var.consul_host
  consul_dc = var.consul_dc
  consul_port = var.consul_port
  consul_schema = var.consul_schema

  // base
  env = var.env
  service = var.service_core0
  project = var.project

  mgmt_user = var.mgmt_user
  mgmt_private_key = var.mgmt_private_key
  mgmt_public_key = var.mgmt_public_key

  flavor_vdb_master = var.flavor_vdb_master
  flavor_vdb_slave = var.flavor_vdb_slave
  flavor_vdb_delay = var.flavor_vdb_delay
  flavor_vdb_sysbench = var.flavor_vdb_sysbench

  // network
  router_ams = var.router_ams
  router_ldn = var.router_ldn

  net_ams_vdb_master = var.net_ams_vdb_master
  net_ams_vdb_slave = var.net_ams_vdb_slave
  net_ldn_vdb_delay = var.net_ldn_vdb_delay

  subnet_ams_vdb_master = var.subnet_ams_vdb_master
  subnet_ams_vdb_slave = var.subnet_ams_vdb_slave
  subnet_ldn_vdb_delay = var.subnet_ldn_vdb_delay

  // volume
  volume_type_master = var.volume_type_master
  volume_type_slave = var.volume_type_slave
  volume_type_delay = var.volume_type_delay
  volume_type_sysbench = var.volume_type_sysbench

  disk_boot_size = var.disk_boot_size
  disk_data_size_master = var.disk_data_size_master
  disk_data_size_slave = var.disk_data_size_slave
  disk_data_size_delay = var.disk_data_size_delay

  // vdb
  vdb_root_password = var.vdb_root_password
  vdb_mgmt_user = var.mgmt_user
  vdb_mgmt_password = var.vdb_mgmt_password

  vdb_sysbench = var.vdb_sysbench

  vdb_innodb_buffer_pool_size = var.vdb_innodb_buffer_pool_size
  vdb_innodb_file_per_table = var.vdb_innodb_file_per_table
  vdb_innodb_flush_log_at_trx_commit = var.vdb_innodb_flush_log_at_trx_commit
  vdb_innodb_log_file_size = var.vdb_innodb_log_file_size

  vdb_delay_0 = var.vdb_delay_0
  vdb_delay_1 = var.vdb_delay_1
  vdb_delay_2 = var.vdb_delay_2

  vdb_meta = var.vdb_meta
  vdb_meta_client_url = var.vdb_meta_client_url
  vdb_meta_data_url = var.vdb_meta_data_url

  // sysbench
  sysbench_time = var.sysbench_time
  sysbench_tables = var.sysbench_tables
  sysbench_table_size = var.sysbench_table_size
}

module "vdb_core2" {
  source = "github.com/di-starss/vspace307-vdb"
  depends_on = [module.vdb_core1]

  // consul
  consul_host = var.consul_host
  consul_dc = var.consul_dc
  consul_port = var.consul_port
  consul_schema = var.consul_schema

  // base
  env = var.env
  service = var.service_core1
  project = var.project

  mgmt_user = var.mgmt_user
  mgmt_private_key = var.mgmt_private_key
  mgmt_public_key = var.mgmt_public_key

  flavor_vdb_master = var.flavor_vdb_master
  flavor_vdb_slave = var.flavor_vdb_slave
  flavor_vdb_delay = var.flavor_vdb_delay
  flavor_vdb_sysbench = var.flavor_vdb_sysbench

  // network
  router_ams = var.router_ams
  router_ldn = var.router_ldn

  net_ams_vdb_master = var.net_ams_vdb_master
  net_ams_vdb_slave = var.net_ams_vdb_slave
  net_ldn_vdb_delay = var.net_ldn_vdb_delay

  subnet_ams_vdb_master = var.subnet_ams_vdb_master
  subnet_ams_vdb_slave = var.subnet_ams_vdb_slave
  subnet_ldn_vdb_delay = var.subnet_ldn_vdb_delay

  // volume
  volume_type_master = var.volume_type_master
  volume_type_slave = var.volume_type_slave
  volume_type_delay = var.volume_type_delay
  volume_type_sysbench = var.volume_type_sysbench

  disk_boot_size = var.disk_boot_size
  disk_data_size_master = var.disk_data_size_master
  disk_data_size_slave = var.disk_data_size_slave
  disk_data_size_delay = var.disk_data_size_delay

  // vdb
  vdb_root_password = var.vdb_root_password
  vdb_mgmt_user = var.mgmt_user
  vdb_mgmt_password = var.vdb_mgmt_password

  vdb_sysbench = var.vdb_sysbench

  vdb_innodb_buffer_pool_size = var.vdb_innodb_buffer_pool_size
  vdb_innodb_file_per_table = var.vdb_innodb_file_per_table
  vdb_innodb_flush_log_at_trx_commit = var.vdb_innodb_flush_log_at_trx_commit
  vdb_innodb_log_file_size = var.vdb_innodb_log_file_size

  vdb_delay_0 = var.vdb_delay_0
  vdb_delay_1 = var.vdb_delay_1
  vdb_delay_2 = var.vdb_delay_2

  vdb_meta = var.vdb_meta
  vdb_meta_client_url = var.vdb_meta_client_url
  vdb_meta_data_url = var.vdb_meta_data_url

  // sysbench
  sysbench_time = var.sysbench_time
  sysbench_tables = var.sysbench_tables
  sysbench_table_size = var.sysbench_table_size
}
