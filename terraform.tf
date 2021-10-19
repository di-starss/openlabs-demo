//
// TERRAFORM
//

// ENV
variable "os_user_name" {}
variable "os_tenant_name" {}
variable "os_password" {}
variable "os_auth_url" {}
variable "os_region" {}

variable "nbx_server_url" {}
variable "nbx_api_token" {}
variable "nbx_allow_insecure_https" {}

variable "dns_server_url" {}
variable "dns_api_key" {}

// Providers
terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
    netbox = {
      source = "e-breuninger/netbox"
      version = "0.2.2"
    }
    powerdns = {
      source = "ag-TJNII/powerdns"
      version = "101.6.1"
    }
  }
}

provider "openstack" {
  user_name   = var.os_user_name
  tenant_name = var.os_tenant_name
  password    = var.os_password
  auth_url    = var.os_auth_url
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


// Vars
variable "env" { default = "example" }
variable "site" { default = "LDN1" }
variable "project" { default = "terraform"}
variable "service" { default = "nginx" }

variable "netbox_cluster" { default = "demo-lab" }
variable "netbox_vm_interface_0" { default = "eth0" }

variable "dns_domain" { default = "cloud.vspace307.io" }

variable "vm_name" { default = "www0" }
variable "subnet" { default = "172.20.1.0/24" }
variable "net" { default = "ldn-openlabs-www" }

variable "mgmt_user" { default = "debian" }
variable "mgmt_public_key" { default = "~/.ssh/id_rsa.pub" }
variable "mgmt_private_key_file" { default = "~/.ssh/id_rsa" }

variable "flavor" { default = "m1.small" }
variable "image" { default = "debian-10" }


// Netbox
module "nbx" {
  source = "../../modules/cloud-netbox"

  env = var.env
  project = var.project
  service = var.service
  site = var.site
  domain = var.dns_domain

  cluster = var.netbox_cluster
  vm_name = var.vm_name
  vm_interface = var.netbox_vm_interface_0
  prefix = var.subnet
}


// DNS
module "dns" {
  source = "../../modules/cloud-dns-record"

  zone = module.nbx.dns_zone
  record = module.nbx.dns_record
  ip = module.nbx.vm_ip
}


// OpenStack
data "openstack_images_image_v2" "img" {
  name        = var.image
  most_recent = true
}

data "openstack_compute_flavor_v2" "flavor" {
  name = var.flavor
}

resource "openstack_compute_secgroup_v2" "terraform_secgroup" {
  description = "terraform security group deploy"
  name        = "terraform-sg0"
  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_compute_keypair_v2" "terraform_keypair" {
  name       = "terraform"
  public_key = file(var.mgmt_public_key)
}

resource "openstack_compute_instance_v2" "terraform_nginx" {
  name              = module.nbx.vm_hostname
  flavor_id         = data.openstack_compute_flavor_v2.flavor.id
  image_id          = data.openstack_images_image_v2.img.id
  key_pair          = openstack_compute_keypair_v2.terraform_keypair.name
  security_groups   = ["default", openstack_compute_secgroup_v2.terraform_secgroup.name]
  availability_zone = var.site

  network {
    name = var.net
    fixed_ip_v4 = module.nbx.vm_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt upgrade -y",
      "sudo apt install nginx -y"
    ]

    connection {
      type     = "ssh"
      user     = var.mgmt_user
      private_key = file(var.mgmt_private_key_file)
      host = module.nbx.vm_ip
    }
  }

}
