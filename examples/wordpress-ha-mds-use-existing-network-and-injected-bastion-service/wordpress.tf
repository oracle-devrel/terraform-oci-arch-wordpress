module "oci-fk-wordpress" {
  source                          = "github.com/oracle-devrel/terraform-oci-fk-wordpress"
  tenancy_ocid                    = var.tenancy_ocid
  vcn_id                          = oci_core_virtual_network.wordpress_mds_vcn.id
  numberOfNodes                   = 2
  availability_domain             = var.availability_domain_name == "" ? lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name") : var.availability_domain_name
  compartment_ocid                = var.compartment_ocid
  image_id                        = lookup(data.oci_core_images.InstanceImageOCID.images[0], "id")
  shape                           = var.node_shape
  ssh_authorized_keys             = var.ssh_public_key
  mds_ip                          = module.mds-instance.mysql_db_system.ip_address
  wp_subnet_id                    = oci_core_subnet.wordpress_subnet.id
  lb_subnet_id                    = oci_core_subnet.lb_subnet_public.id 
  fss_subnet_id                   = oci_core_subnet.fss_subnet_private.id 
  admin_password                  = var.admin_password
  admin_username                  = var.admin_username
  wp_auto_update                  = var.wp_auto_update
  wp_schema                       = var.wp_schema
  wp_version                      = var.wp_version
  wp_name                         = var.wp_name
  wp_password                     = var.wp_password
  wp_plugins                      = tolist(split(",",var.wp_plugins))
  wp_themes                       = tolist(split(",",var.wp_themes))
  wp_site_title                   = var.wp_site_title
  wp_site_admin_user              = var.wp_site_admin_user
  wp_site_admin_pass              = var.wp_site_admin_pass
  wp_site_admin_email             = var.wp_site_admin_email
  lb_shape                        = var.lb_shape 
  flex_lb_min_shape               = var.flex_lb_min_shape 
  flex_lb_max_shape               = var.flex_lb_max_shape 
  inject_bastion_service_id       = true
  use_bastion_service             = true
  inject_bastion_server_public_ip = false
  bastion_service_id              = oci_bastion_bastion.bastion_service.id
  bastion_service_region          = var.region
}

