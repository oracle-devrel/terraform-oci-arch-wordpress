## Copyright (c) 2022, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

module "oci-arch-wordpress" {
  source                    = "github.com/oracle-devrel/terraform-oci-arch-wordpress"
  tenancy_ocid              = var.tenancy_ocid
  vcn_id                    = oci_core_virtual_network.wp_mds_vcn.id
  numberOfNodes             = 1
  availability_domain       = var.availability_domain_name == "" ? lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name") : var.availability_domain_name
  compartment_ocid          = var.compartment_ocid
  image_id                  = lookup(data.oci_core_images.InstanceImageOCID.images[0], "id")
  shape                     = var.node_shape
  label_prefix              = var.label_prefix
  ssh_authorized_keys       = var.ssh_public_key
  mds_ip                    = module.mds-instance.mysql_db_system.ip_address
  wp_subnet_id              = oci_core_subnet.wp_subnet.id
  admin_password            = var.admin_password
  admin_username            = var.admin_username
  wp_schema                 = var.wp_schema
  wp_name                   = var.wp_name
  wp_password               = var.wp_password
  wp_plugins                = tolist(split(",",var.wp_plugins))
  wp_themes                 = tolist(split(",",var.wp_themes))
  wp_site_title             = var.wp_site_title
  wp_site_admin_user        = var.wp_site_admin_user
  wp_site_admin_pass        = var.wp_site_admin_pass
  wp_site_admin_email       = var.wp_site_admin_email
  display_name              = var.wp_instance_name
  flex_shape_ocpus          = var.node_flex_shape_ocpus
  flex_shape_memory         = var.node_flex_shape_memory
}

