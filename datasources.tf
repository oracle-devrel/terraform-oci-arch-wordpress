
data "oci_identity_availability_domains" "ADs" {
  compartment_id = var.tenancy_ocid
}

data "template_file" "install_php" {
  template = file("${path.module}/scripts/install_php74.sh")

  vars = {
    mysql_version = var.mysql_version
    user          = var.vm_user
  }
}

data "template_file" "setup_fss" {
  template = file("${path.module}/scripts/setup_fss.sh")

  vars = {
    wp_shared_working_dir = var.wp_shared_working_dir
    mt_ip_address         = local.mt_ip_address
    use_shared_storage    = tostring(var.use_shared_storage)
  }
}

data "template_file" "configure_local_security" {
  template = file("${path.module}/scripts/configure_local_security.sh")
}

data "template_file" "create_wp_db" {
  template = file("${path.module}/scripts/create_wp_db.sh")

  vars = {
    admin_password = var.admin_password
    admin_username = var.admin_username
    wp_name        = var.wp_name
    wp_password    = var.wp_password
    wp_schema      = var.wp_schema
    mds_ip         = var.mds_ip
  }
}

data "template_file" "key_script" {
  template = file("${path.module}/scripts/sshkey.tpl")
  vars = {
    ssh_public_key = tls_private_key.public_private_key_pair.public_key_openssh
  }
}

data "template_cloudinit_config" "cloud_init" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "ainit.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.key_script.rendered
  }
}

data "oci_core_subnet" "wp_subnet_ds" {
  count     = var.numberOfNodes > 1 && var.use_shared_storage ? 1 : 0
  subnet_id = var.wp_subnet_id
}

data "oci_core_private_ips" "ip_mount_WordPressMountTarget" {
  count     = var.numberOfNodes > 1 && var.use_shared_storage ? 1 : 0
  subnet_id = oci_file_storage_mount_target.WordPressMountTarget[0].subnet_id

  filter {
    name   = "id"
    values = [oci_file_storage_mount_target.WordPressMountTarget[0].private_ip_ids[0]]
  }
}

data "oci_core_vnic_attachments" "WordPress_vnics" {
  depends_on          = [oci_core_instance.WordPress]
  compartment_id      = var.compartment_ocid
  availability_domain = var.availability_domain == "" ? lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name") : var.availability_domain
  instance_id         = oci_core_instance.WordPress.id
}

data "oci_core_vnic" "WordPress_vnic1" {
  depends_on = [oci_core_instance.WordPress]
  vnic_id    = data.oci_core_vnic_attachments.WordPress_vnics.vnic_attachments[0]["vnic_id"]
}

data "oci_core_private_ips" "WordPress_private_ips1" {
  depends_on = [oci_core_instance.WordPress]
  vnic_id    = data.oci_core_vnic.WordPress_vnic1.id
  subnet_id = var.wp_subnet_id
}

data "template_file" "setup_wp" {
  template = file("${path.module}/scripts/setup_wp.sh")

  vars = {
    wp_auto_update        = var.wp_auto_update
    wp_version            = var.wp_version
    wp_name               = var.wp_name
    wp_password           = var.wp_password
    wp_schema             = var.wp_schema
    mds_ip                = var.mds_ip
    wp_site_url           = var.numberOfNodes > 1 ? oci_core_public_ip.WordPress_public_ip_for_multi_node[0].ip_address : oci_core_public_ip.WordPress_public_ip_for_single_node[0].ip_address
    wp_site_title         = var.wp_site_title
    wp_site_admin_user    = var.wp_site_admin_user
    wp_site_admin_pass    = var.wp_site_admin_pass
    wp_site_admin_email   = var.wp_site_admin_email
    wp_plugins            = join(" ", var.wp_plugins)
    wp_themes             = join(" ", var.wp_themes)
    wp_working_dir        = var.wp_working_dir
    wp_shared_working_dir = var.wp_shared_working_dir
    use_shared_storage    = var.numberOfNodes > 1 ? tostring(var.use_shared_storage) : tostring(false)
  }
}
