# Mount Target

resource "oci_file_storage_mount_target" "WordPressMountTarget" {
  count               = var.numberOfNodes > 1 && var.use_shared_storage ? 1 : 0
  availability_domain = var.availability_domain == "" ? lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name") : var.availability_domain
  compartment_id      = var.compartment_ocid
  subnet_id           = var.fss_subnet_id
  display_name        = "WordPressMountTarget"
  nsg_ids             = [oci_core_network_security_group.WordPressFSSSecurityGroup[0].id]
}

# Export Set

resource "oci_file_storage_export_set" "WordPressExportset" {
  count           = var.numberOfNodes > 1 && var.use_shared_storage ? 1 : 0
  mount_target_id = oci_file_storage_mount_target.WordPressMountTarget[0].id
  display_name    = "WordPressExportset"
}

# FileSystem

resource "oci_file_storage_file_system" "WordPressFilesystem" {
  count               = var.numberOfNodes > 1 && var.use_shared_storage ? 1 : 0
  availability_domain = var.availability_domain == "" ? lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name") : var.availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = "WordPressFilesystem"
}

# Export

resource "oci_file_storage_export" "WordPressExport" {
  count          = var.numberOfNodes > 1 && var.use_shared_storage ? 1 : 0
  export_set_id  = oci_file_storage_mount_target.WordPressMountTarget[0].export_set_id
  file_system_id = oci_file_storage_file_system.WordPressFilesystem[0].id
  path           = var.wp_shared_working_dir
}
