## Copyright (c) 2022 Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

output "wp_home_URL" {
  value = "http://${module.wordpress.public_ip[0]}/"
}

output "generated_ssh_private_key" {
  value     = module.wordpress.generated_ssh_private_key
  sensitive = true
}

output "wp_name" {
  value = var.wp_name
}

output "wp_password" {
  value = var.wp_password
}

output "wp_database" {
  value = var.wp_schema
}

output "mds_instance_ip" {
  value = module.mds-instance.mysql_db_system.ip_address
  sensitive = true
}