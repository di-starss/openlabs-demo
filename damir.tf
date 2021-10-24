/**
    OpenLabs/Damir/VDB
**/

// ACCESS
// ---------------------------------------------------------------------------------------------------------------------
variable "qemu_ip" {}

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

// OPENLABS
// ---------------------------------------------------------------------------------------------------------------------
variable "env" { default = "damir" }

variable "mgmt_user" { default = "mgmt" }
variable "mgmt_public_key" { default = "~/.ssh/id_rsa.pub" }
variable "mgmt_private_key" { default = "~/.ssh/id_rsa" }

variable "openstack_release" { default = "victoria" }
variable "openstack_keystone_bootstrap_password" { default = "password123123" }
variable "openstack_neutron_metadata_proxy_shared_secret" { default = "password123123" }

variable "openstack_mgmt_user" { default = "mgmt" }
variable "openstack_mgmt_password" { default = "password123123" }

variable "openstack_service_glance_password" { default = "password123123" }
variable "openstack_service_nova_password" { default = "password123123" }
variable "openstack_service_placement_password" { default = "password123123" }
variable "openstack_service_neutron_password" { default = "password123123" }
variable "openstack_service_cinder_password" { default = "password123123" }

variable "openstack_db_root_password" { default = "password123123" }
variable "openstack_db_mgmt_password" { default = "password123123" }

variable "openstack_db_keystone_password" { default = "password123123" }
variable "openstack_db_glance_password" { default = "password123123" }
variable "openstack_db_nova_password" { default = "password123123" }
variable "openstack_db_placement_password" { default = "password123123" }
variable "openstack_db_neutron_password" { default = "password123123" }
variable "openstack_db_cinder_password" { default = "password123123" }

variable "openstack_mq_user" { default = "openlabs" }
variable "openstack_mq_password" { default = "password123123" }

variable "openstack_rsyslog_logdna_key" {}

variable "img_source" {}
variable "img_name" { default = "focal" }


// CFG
// ---------------------------------------------------------------------------------------------------------------------
variable "cfg_project" { default = "vdb" }

variable "cfg_project_user" { default = "vdb" }
variable "cfg_project_password" { default = "password123123" }

variable "cfg_image_name" { default = "debian-10" }
variable "cfg_image_url" { default = "https://cdimage.debian.org/cdimage/openstack/current-10/debian-10-openstack-amd64.qcow2" }

variable "cfg_router_ams" { default = "ams-vdb" }
variable "cfg_router_ldn" { default = "ldn-vdb" }

variable "cfg_net_ams_master" { default = "vdb-master" }
variable "cfg_subnet_ams_master" { default = "172.19.16.0/24" }

variable "cfg_net_ams_slave" { default = "vdb-slave" }
variable "cfg_subnet_ams_slave" { default = "172.19.17.0/24" }

variable "cfg_net_ldn_delay" { default = "vdb-delay" }
variable "cfg_subnet_ldn_delay" { default = "172.20.16.0/24" }

variable "cfg_dns" { default = "172.21.17.17" }

variable "cfg_region" { default = "RegionOne" }

// flavor
variable "cfg_flavor_vdb_master" { default = "vdb-master" }
variable "cfg_flavor_vdb_slave" { default = "vdb-slave" }
variable "cfg_flavor_vdb_delay" { default = "vdb-delay" }
variable "cfg_flavor_vdb_sysbench" { default = "vdb-sysbench" }

// volume
variable "cfg_volume_type_ams_ssd_5" { default = "ams-ssd-rack-5" }
variable "cfg_volume_type_ams_ssd_6" { default = "ams-ssd-rack-6" }
variable "cfg_volume_type_ldn_ssd_17" { default = "ldn-ssd-rack-17" }
variable "cfg_volume_type_ldn_ssd_18" { default = "ldn-ssd-rack-18" }


// VDB
// ---------------------------------------------------------------------------------------------------------------------
// service
variable "vdb_service" { default = "core" }
variable "vdb_instance_mgmt_user" { default = "debian" }

// volume
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
    libvirt = {
      source = "dmacvicar/libvirt"
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

provider "libvirt" {
  uri = "qemu+tcp://root@${var.qemu_ip}/system"
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

provider "openstack" {
  auth_url    = module.cfg.api_url
  tenant_name = module.cfg.tenant_name
  user_name   = module.cfg.api_user
  password    = module.cfg.api_password
  region      = module.cfg.region
}

locals {
  consul_url = "${var.consul_schema}://${var.consul_host}:${var.consul_port}"
}


// MODULE
// ---------------------------------------------------------------------------------------------------------------------
module "openlabs" {
  source = "github.com/di-starss/vspace307-openlabs"

  // openlabs
  env = var.env

  mgmt_user = var.mgmt_user
  mgmt_public_key = var.mgmt_public_key
  mgmt_private_key = var.mgmt_private_key

  img_name = var.img_name
  img_source = var.img_source

  openstack_release = var.openstack_release

  openlabs_consul_host = var.consul_host
  openlabs_consul_port = var.consul_port
  openlabs_consul_schema = var.consul_schema
  openlabs_consul_dc = var.consul_dc

  openstack_db_root_password = var.openstack_db_root_password
  openstack_db_cinder_password = var.openstack_db_cinder_password
  openstack_db_glance_password = var.openstack_db_glance_password
  openstack_db_keystone_password = var.openstack_db_keystone_password
  openstack_db_mgmt_password = var.openstack_db_mgmt_password
  openstack_db_neutron_password = var.openstack_db_neutron_password
  openstack_db_nova_password = var.openstack_db_nova_password
  openstack_db_placement_password = var.openstack_db_placement_password

  openstack_keystone_bootstrap_password = var.openstack_keystone_bootstrap_password

  openstack_mgmt_password = var.openstack_mgmt_password
  openstack_mgmt_user = var.openstack_mgmt_user

  openstack_mq_password = var.openstack_mq_password
  openstack_mq_user = var.openstack_mq_user

  openstack_service_cinder_password = var.openstack_service_cinder_password
  openstack_service_glance_password = var.openstack_service_glance_password
  openstack_service_neutron_password = var.openstack_service_neutron_password
  openstack_service_nova_password = var.openstack_service_nova_password
  openstack_service_placement_password = var.openstack_service_placement_password

  openstack_neutron_metadata_proxy_shared_secret = var.openstack_neutron_metadata_proxy_shared_secret

  openstack_rsyslog_logdna_key = var.openstack_rsyslog_logdna_key
}

module "cfg" {
  source = "github.com/di-starss/vspace307-openlabs-cfg-vdb"
  depends_on = [module.openlabs]

  api_url = module.openlabs.api
  api_admin_password = var.openstack_keystone_bootstrap_password
  cfg_region = var.cfg_region

  cfg_project = var.cfg_project
  cfg_project_user = var.cfg_project_user
  cfg_project_password = var.cfg_project_password

  cfg_mgmt_ip = module.openlabs.mgmt_ip
  cfg_mgmt_user = var.mgmt_user
  cfg_mgmt_private_key = var.mgmt_private_key

  cfg_compute_ams_kvm0_hostname = module.openlabs.vm_ams_compute_kvm0_hostname
  cfg_compute_ams_kvm1_hostname = module.openlabs.vm_ams_compute_kvm1_hostname
  cfg_compute_ams_kvm2_hostname = module.openlabs.vm_ams_compute_kvm2_hostname
  cfg_compute_ldn_kvm3_hostname = module.openlabs.vm_ldn_compute_kvm3_hostname
  cfg_compute_ldn_kvm4_hostname = module.openlabs.vm_ldn_compute_kvm4_hostname
  cfg_compute_ldn_kvm5_hostname = module.openlabs.vm_ldn_compute_kvm5_hostname

  cfg_flavor_vdb_master = var.cfg_flavor_vdb_master
  cfg_flavor_vdb_slave = var.cfg_flavor_vdb_slave
  cfg_flavor_vdb_delay = var.cfg_flavor_vdb_delay
  cfg_flavor_vdb_sysbench = var.cfg_flavor_vdb_sysbench

  cfg_image_name = var.cfg_image_name
  cfg_image_url = var.cfg_image_url

  cfg_router_ams = var.cfg_router_ams
  cfg_router_ldn = var.cfg_router_ldn

  cfg_net_ams_master = var.cfg_net_ams_master
  cfg_net_ams_slave = var.cfg_net_ams_slave
  cfg_net_ldn_delay = var.cfg_net_ldn_delay

  cfg_subnet_ams_master = var.cfg_subnet_ams_master
  cfg_subnet_ams_slave = var.cfg_subnet_ams_slave
  cfg_subnet_ldn_delay = var.cfg_subnet_ldn_delay

  cfg_dns = var.cfg_dns

  cfg_volume_type_ams_ssd_5 = var.cfg_volume_type_ams_ssd_5
  cfg_volume_type_ams_ssd_6 = var.cfg_volume_type_ams_ssd_6
  cfg_volume_type_ldn_ssd_17 = var.cfg_volume_type_ldn_ssd_17
  cfg_volume_type_ldn_ssd_18 = var.cfg_volume_type_ldn_ssd_18

  storage_backend_name_ams_rack_5 = module.openlabs.storage_backend_name_ams_rack_5
  storage_backend_name_ams_rack_6 = module.openlabs.storage_backend_name_ams_rack_6
  storage_backend_name_ldn_rack_17 = module.openlabs.storage_backend_name_ldn_rack_17
  storage_backend_name_ldn_rack_18 = module.openlabs.storage_backend_name_ldn_rack_18
}

module "vdb" {
  source = "github.com/di-starss/vspace307-vdb"
  depends_on = [module.cfg]

  // base
  env = var.env
  service = var.vdb_service
  project = var.cfg_project

  mgmt_user = var.vdb_instance_mgmt_user
  mgmt_private_key = var.mgmt_private_key
  mgmt_public_key = var.mgmt_public_key

  flavor_vdb_master = var.cfg_flavor_vdb_master
  flavor_vdb_slave = var.cfg_flavor_vdb_slave
  flavor_vdb_delay = var.cfg_flavor_vdb_delay
  flavor_vdb_sysbench = var.cfg_flavor_vdb_sysbench

  image = var.cfg_image_name

  // network
  router_ams = var.cfg_router_ams
  router_ldn = var.cfg_router_ldn

  net_ams_vdb_master = var.cfg_net_ams_master
  net_ams_vdb_slave = var.cfg_net_ams_slave
  net_ldn_vdb_delay = var.cfg_net_ldn_delay

  subnet_ams_vdb_master = var.cfg_subnet_ams_master
  subnet_ams_vdb_slave = var.cfg_subnet_ams_slave
  subnet_ldn_vdb_delay = var.cfg_subnet_ldn_delay

  // volume
  volume_type_master = var.cfg_volume_type_ams_ssd_5
  volume_type_slave = var.cfg_volume_type_ams_ssd_6
  volume_type_delay = var.cfg_volume_type_ldn_ssd_17
  volume_type_sysbench = var.cfg_volume_type_ams_ssd_5

  disk_boot_size = var.disk_boot_size
  disk_data_size_master = var.disk_data_size_master
  disk_data_size_slave = var.disk_data_size_slave
  disk_data_size_delay = var.disk_data_size_delay

  // consul
  consul_host = var.consul_host
  consul_port = var.consul_port
  consul_schema = var.consul_schema
  consul_dc = var.consul_dc

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
