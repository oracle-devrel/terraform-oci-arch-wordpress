resource "oci_core_public_ip" "WordPress_public_ip_for_single_node" {
  depends_on     = [oci_core_instance.WordPress]
  count          = var.numberOfNodes > 1 ? 0 : 1
  compartment_id = var.compartment_ocid
  display_name   = "WordPress_public_ip_for_single_node"
  lifetime       = "RESERVED"
  #  private_ip_id  = var.numberOfNodes == 1 ? data.oci_core_private_ips.WordPress_private_ips1.private_ips[0]["id"] : null
  private_ip_id = data.oci_core_private_ips.WordPress_private_ips1.private_ips[0]["id"]
  defined_tags  = var.defined_tags
  lifecycle {
    ignore_changes = [defined_tags]
  }
}

resource "oci_core_public_ip" "WordPress_public_ip_for_multi_node" {
  count          = var.numberOfNodes > 1 ? 1 : 0
  compartment_id = var.compartment_ocid
  display_name   = "WordPress_public_ip_for_multi_node"
  lifetime       = "RESERVED"
  defined_tags   = var.defined_tags
  lifecycle {
    ignore_changes = [defined_tags]
  }
}