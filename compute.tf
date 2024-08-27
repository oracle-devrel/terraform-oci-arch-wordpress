resource "oci_core_instance" "WordPress" {
  availability_domain = var.availability_domain == "" ? lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name") : var.availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = "${var.label_prefix}${var.display_name}1"
  shape               = var.shape

  dynamic "shape_config" {
    for_each = local.is_flexible_node_shape ? [1] : []
    content {
      memory_in_gbs = var.flex_shape_memory
      ocpus         = var.flex_shape_ocpus
    }
  }

  create_vnic_details {
    subnet_id        = var.wp_subnet_id
    display_name     = "${var.label_prefix}${var.display_name}1"
    assign_public_ip = false
    hostname_label   = var.display_name
  }

  dynamic "agent_config" {
    for_each = var.numberOfNodes > 1 ? [1] : []
    content {
      are_all_plugins_disabled = false
      is_management_disabled   = false
      is_monitoring_disabled   = false
      plugins_config {
        desired_state = "ENABLED"
        name          = "Bastion"
      }
    }
  }

  metadata = {
    ssh_authorized_keys = var.ssh_authorized_keys
    user_data           = data.template_cloudinit_config.cloud_init.rendered
  }

  source_details {
    source_id   = var.image_id
    source_type = "image"
  }

  defined_tags = var.defined_tags

  provisioner "local-exec" {
    command = "sleep 240"
  }
}

resource "oci_core_instance" "bastion_instance" {
  count               = (var.numberOfNodes > 1 && !var.use_bastion_service && !var.inject_bastion_server_public_ip) ? 1 : 0
  availability_domain = var.availability_domain == "" ? data.oci_identity_availability_domains.ADs.availability_domains[0]["name"] : var.availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = "${var.label_prefix}BastionVM"
  shape               = var.bastion_shape

  dynamic "shape_config" {
    for_each = local.is_flexible_node_shape ? [1] : []
    content {
      memory_in_gbs = var.bastion_flex_shape_memory
      ocpus         = var.bastion_flex_shape_ocpus
    }
  }

  create_vnic_details {
    subnet_id        = var.bastion_subnet_id
    display_name     = "bastionvm"
    assign_public_ip = true
  }

  source_details {
    source_id   = var.bastion_image_id
    source_type = "image"
  }

  defined_tags = var.defined_tags

  metadata = {
    ssh_authorized_keys = var.ssh_authorized_keys
    user_data           = data.template_cloudinit_config.cloud_init.rendered
  }
}

resource "oci_core_image" "wordpress_instance_image" {
  count          = var.numberOfNodes > 1 ? 1 : 0
  depends_on     = [null_resource.WordPress_provisioner_with_bastion, null_resource.WordPress_provisioner_with_injected_bastion_server_public_ip]
  compartment_id = var.compartment_ocid
  instance_id    = oci_core_instance.WordPress.id
  display_name   = "WordPress_instance_image"
  defined_tags   = var.defined_tags
}

resource "oci_core_instance" "WordPress_from_image" {
  count               = var.numberOfNodes > 1 ? var.numberOfNodes - 1 : 0
  availability_domain = var.availability_domain == "" ? lookup(data.oci_identity_availability_domains.ADs.availability_domains[0], "name") : var.availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = "${var.label_prefix}${var.display_name}${count.index + 2}"
  shape               = var.shape

  dynamic "shape_config" {
    for_each = local.is_flexible_node_shape ? [1] : []
    content {
      memory_in_gbs = var.flex_shape_memory
      ocpus         = var.flex_shape_ocpus
    }
  }

  create_vnic_details {
    subnet_id        = var.wp_subnet_id
    display_name     = "${var.label_prefix}${var.display_name}${count.index + 2}"
    assign_public_ip = false
    hostname_label   = "${var.label_prefix}${var.display_name}${count.index + 2}"
  }

  dynamic "agent_config" {
    for_each = var.numberOfNodes > 1 ? [1] : []
    content {
      are_all_plugins_disabled = false
      is_management_disabled   = false
      is_monitoring_disabled   = false
      plugins_config {
        desired_state = "ENABLED"
        name          = "Bastion"
      }
    }
  }

  metadata = {
    ssh_authorized_keys = var.ssh_authorized_keys
  }

  source_details {
    source_id   = oci_core_image.wordpress_instance_image[0].id
    source_type = "image"
  }

  defined_tags = var.defined_tags

  provisioner "local-exec" {
    command = "sleep 240"
  }
}

