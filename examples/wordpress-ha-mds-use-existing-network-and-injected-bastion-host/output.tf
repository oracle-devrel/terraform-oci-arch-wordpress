output "wordpress_home_URL" {
  value = "http://${module.oci-fk-wordpress.public_ip[0]}/"
}

output "wordpress_wp-admin_URL" {
  value = "http://${module.oci-fk-wordpress.public_ip[0]}/wp-admin/"
}

output "wp_site_admin_user" {
  value = var.wp_site_admin_user
}

output "wp_site_admin_pass" {
  value = var.wp_site_admin_pass
}

output "generated_ssh_private_key" {
  value     = module.oci-fk-wordpress.generated_ssh_private_key
  sensitive = true
}

output "generated_ssh_public_key" {
  value     = module.oci-fk-wordpress.generated_ssh_public_key
  sensitive = true
}

output "mds_instance_ip" {
  value = module.mds-instance.mysql_db_system.ip_address
  sensitive = true
}