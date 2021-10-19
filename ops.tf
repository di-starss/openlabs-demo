/**
    OpenLabs/Ops
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
variable "env" { default = "ops" }

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

locals {
  consul_url = "${var.consul_schema}://${var.consul_host}:${var.consul_port}"
}


// PROVIDER
// ---------------------------------------------------------------------------------------------------------------------
terraform {
  required_providers {
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
