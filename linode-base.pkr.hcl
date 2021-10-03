packer {
  required_plugins {
    linode = {
      source = "github.com/hashicorp/linode"
      version = ">= 0.0.1"
    }
  }
}

// begin vars
variable "linode_token" {
  type = string
  sensitive = true
}

variable "linode_image" {
  description = "Image to build from"
  default = "linode/almalinux8"
}

variable "label" {
  description = "Human-friendly name"
  default = "mediawiki-base"
}

variable "region" {
  description = "Linode region"
  default = "us-southeast"
}

variable "flavor" {
  description = "Cloud server flavor"
  default = "g6-standard-1"
}

// variable "stackscript_id" {
//   description = "provisioning script ID"
//   type = number
//   default = 909122
// }

// end vars

//begin locals

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

// end locals

source "linode" "base_img" {
  image = "linode/almalinux8"
  image_description = "base_img"
  image_label = "base_img_${local.timestamp}"
  instance_label = "base_img_build_${local.timestamp}"
  instance_type = var.flavor
  linode_token = var.linode_token
  region = var.region
  ssh_username = "root"

}

build {
  sources = ["source.linode.base_img"]


  provisioner "ansible" {
    playbook_file = "/Users/gizzmonic/code/riichilab/ansible-roles/linode-base.yml"
  }

}
