## Copyright (c) 2022 Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}

variable "ssh_public_key" {
  default = ""
}

variable "availability_domain_name" {
  default = ""
}

variable "tenancy_ocid" {
  description = "Tenancy's OCID"
}

variable "compartment_ocid" {
  description = "Compartment's OCID where VCN will be created. "
}

variable "region" {
  description = "OCI Region"
}

variable "vcn" {
  description = "VCN Name"
  default     = "wordpress_mds_vcn"
}

variable "vcn_cidr" {
  description = "VCN's CIDR IP Block"
  default     = "10.0.0.0/16"
}

variable "node_image_id" {
  description = "The OCID of an image for a node instance to use. "
  default     = ""
}

variable "node_shape" {
description = "Instance shape to use for master instance. "
 default     = "VM.Standard.E4.Flex"
}

variable "node_flex_shape_ocpus" {
  description = "Flex Instance shape OCPUs"
  default = 1
}

variable "node_flex_shape_memory" {
  description = "Flex Instance shape Memory (GB)"
  default = 6
}

variable "label_prefix" {
  description = "To create unique identifier for multiple setup in a compartment."
  default     = ""
}

variable "lb_shape" {
  default = "flexible"
}

variable "flex_lb_min_shape" {
  default = "10"
}

variable "flex_lb_max_shape" {
  default = "100"
}

variable "use_bastion_service" {
  default = false
}

variable "bastion_shape" {
  default = "VM.Standard.E4.Flex"
}

variable "bastion_flex_shape_ocpus" {
  default = 1
}

variable "bastion_flex_shape_memory" {
  default = 1
}

variable "instance_os" {
  description = "Operating system for compute instances"
  default     = "Oracle Linux"
}

variable "linux_os_version" {
  description = "Operating system version for all Linux instances"
  default     = "8"
}

variable "admin_password" {
  description = "Password for the admin user for MySQL Database Service"
}

variable "admin_username" {
  description = "MySQL Database Service Username"
  default = "admin"
}

variable "ssh_authorized_keys_path" {
  description = "Public SSH keys path to be included in the ~/.ssh/authorized_keys file for the default user on the instance. DO NOT FILL WHEN USING REOSURCE MANAGER STACK!"
  default     = ""
}

variable "ssh_private_key_path" {
  description = "The private key path to access instance. DO NOT FILL WHEN USING RESOURCE MANAGER STACK!"
  default     = ""
}

variable "mysql_shape" {
    default = "MySQL.VM.Standard.E3.1.8GB"
}

variable "wordpress_name" {
  description = "wordpress Database User Name."
  default     = "wordpress"
}

variable "wordpress_password" {
  description = "wordpress Database User Password."
  default     = ""
}

variable "wordpress_schema" {
  description = "wordpress MySQL Schema"
  default     = "wordpress"
}

variable "mds_instance_name" {
  description = "Name of the MDS instance"
  default     = "wordpressMDS"
}

variable "mysql_is_highly_available" {
  default = false
}

variable "mysql_db_system_data_storage_size_in_gb" {
  default = 50
}

variable "mysql_db_system_description" {
  description = "MySQL DB System for wordpress-MDS"
  default = "MySQL DB System for wordpress-MDS"
}

variable "mysql_db_system_display_name" {
  description = "MySQL DB System display name"
  default = "wordpressMDS"
}

variable "mysql_db_system_fault_domain" {
  description = "The fault domain on which to deploy the Read/Write endpoint. This defines the preferred primary instance."
  default = "FAULT-DOMAIN-1"
}                  

variable "mysql_db_system_hostname_label" {
  description = "The hostname for the primary endpoint of the DB System. Used for DNS. The value is the hostname portion of the primary private IP's fully qualified domain name (FQDN) (for example, dbsystem-1 in FQDN dbsystem-1.subnet123.vcn1.oraclevcn.com). Must be unique across all VNICs in the subnet and comply with RFC 952 and RFC 1123."
  default = "wordpressMDS"
}
   
variable "mysql_db_system_maintenance_window_start_time" {
  description = "The start of the 2 hour maintenance window. This string is of the format: {day-of-week} {time-of-day}. {day-of-week} is a case-insensitive string like mon, tue, etc. {time-of-day} is the Time portion of an RFC3339-formatted timestamp. Any second or sub-second time data will be truncated to zero."
  default = "SUNDAY 14:30"
}

variable "wordpress_instance_name" {
  description = "Name of the wordpress compute instance"
  default     = "wordpressvm"
}

variable "use_shared_storage" {
  description = "Decide if you want to use shared NFS on OCI FSS"
  default     = true
}

variable "wp_working_dir" {
  description = "Decide where to store WordPress data"
  default     = "/var"
}

variable "wp_shared_working_dir" {
  description = "Decide where to store WordPress data"
  default     = "/sharedwp"
}

variable "ssh_authorized_keys" {
  description = "Public SSH keys path to be included in the ~/.ssh/authorized_keys file for the default user on the instance. "
  default     = ""
}

variable "ssh_private_key" {
  description = "The private key path to access instance. "
  default     = ""
}

variable "image_id" {
  description = "The OCID of an image for an instance to use. "
  default     = ""
}

variable "vm_user" {
  description = "The SSH user to connect to the master host."
  default     = "opc"
}

variable "wp_version" {
  description = "WordPress version"
  default = "5.9"
}

variable "wp_auto_update" {
  default     = true
}

variable "wp_name" {
  description = "WordPress Database User Name."
  default     = "wordpress"
}

variable "wp_password" {
  description = "WordPress Database User Password."
}

variable "wp_schema" {
  description = "WordPress MySQL Schema"
  default     = "wordpress"
}

variable "wp_plugins" {
  description = "A list of WordPress plugins to install."
  default     = "hello-dolly"
}

variable "wp_themes" {
  description = "A list of WordPress themes to install."
  default     = "lodestar, twentysixteen"
}

variable "wp_site_url" {
  description = "WordPress Site URL"
  default     = "example.com"
}

variable "wp_site_title" {
  description = "WordPress Site Title"
  default     = "Yet Another WordPress Site"
}

variable "wp_site_admin_user" {
  description = "WordPress Site Admin Username"
  default     = "admin"
}

variable "wp_site_admin_pass" {
  description = "WordPress Site Admin Password"
  default     = ""
}

variable "wp_site_admin_email" {
  description = "WordPress Site Admin Email"
  default     = "admin@example.com"
}


# Dictionary Locals
locals {
  compute_flexible_shapes = [
    "VM.Standard.E3.Flex",
    "VM.Standard.E4.Flex"
  ]
  is_flexible_node_shape = contains(local.compute_flexible_shapes, var.bastion_shape)
  availability_domain_name  = var.availability_domain_name == "" ? lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name") : var.availability_domain_name
  
}
