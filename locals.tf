locals {
  php_script      = "/home/${var.vm_user}/install_php74.sh"
  security_script = "/home/${var.vm_user}/configure_local_security.sh"
  create_wp_db    = "/home/${var.vm_user}/create_wp_db.sh"
  setup_wp        = "/home/${var.vm_user}/setup_wp.sh"
  setup_fss       = "/home/${var.vm_user}/setup_fss.sh"
  htaccess        = "/home/${var.vm_user}/htaccess"
  mt_ip_address = var.numberOfNodes > 1 && var.use_shared_storage ? data.oci_core_private_ips.ip_mount_WordPressMountTarget[0].private_ips[0].ip_address : ""
}
