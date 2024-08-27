resource "oci_bastion_bastion" "bastion-service" {
  count            = (var.numberOfNodes > 1 && var.use_bastion_service && !var.inject_bastion_service_id) ? 1 : 0
  bastion_type     = "STANDARD"
  compartment_id   = var.compartment_ocid
  target_subnet_id = var.wp_subnet_id
  client_cidr_block_allow_list = ["0.0.0.0/0"]
  name                         = "BastionService4WP"
  max_session_ttl_in_seconds   = 10800
}

data "oci_computeinstanceagent_instance_agent_plugins" "wordpress_agent_plugin_bastion" {
  count            = var.numberOfNodes > 1 && var.use_bastion_service ? 1 : 0
  compartment_id   = var.compartment_ocid
  instanceagent_id = oci_core_instance.WordPress.id
  name             = "Bastion"
  status           = "RUNNING"
}

resource "time_sleep" "wordpress_agent_checker" {
  depends_on      = [oci_core_instance.WordPress]
  count           = var.numberOfNodes > 1 && var.use_bastion_service ? 1 : 0
  create_duration = "60s"

  triggers = {
    changed_time_stamp = length(data.oci_computeinstanceagent_instance_agent_plugins.wordpress_agent_plugin_bastion) != 0 ? 0 : timestamp()
    instance_ocid  = oci_core_instance.WordPress.id
    private_ip     = oci_core_instance.WordPress.private_ip
  }
}


resource "oci_bastion_session" "ssh_via_bastion_service" {
  depends_on = [oci_core_instance.WordPress]
  count      = var.numberOfNodes > 1 && var.use_bastion_service ? 1 : 0
  bastion_id = var.bastion_service_id == "" ? oci_bastion_bastion.bastion-service[0].id : var.bastion_service_id 

  key_details {
    public_key_content = tls_private_key.public_private_key_pair.public_key_openssh
  }

  target_resource_details {
    session_type                               = "MANAGED_SSH"
    target_resource_id                         = time_sleep.wordpress_agent_checker[count.index].triggers["instance_ocid"]
    target_resource_operating_system_user_name = "opc"
    target_resource_port                       = 22
    target_resource_private_ip_address         = time_sleep.wordpress_agent_checker[count.index].triggers["private_ip"]
  }

  display_name           = "ssh_via_bastion_service_to_wordpress1"
  key_type               = "PUB"
  session_ttl_in_seconds = 10800
}



data "oci_computeinstanceagent_instance_agent_plugins" "wordpress2plus_agent_plugin_bastion" {
  count            = var.numberOfNodes > 1 && var.use_bastion_service ? var.numberOfNodes - 1 : 0
  compartment_id   = var.compartment_ocid
  instanceagent_id = oci_core_instance.WordPress_from_image[count.index].id
  name             = "Bastion"
  status           = "RUNNING"
}

resource "time_sleep" "wordpress2plus_agent_checker" {
  depends_on      = [oci_core_instance.WordPress_from_image]
  count           = var.numberOfNodes > 1 && var.use_bastion_service ? var.numberOfNodes - 1 : 0
  create_duration = "60s"

  triggers = {
    changed_time_stamp = length(data.oci_computeinstanceagent_instance_agent_plugins.wordpress2plus_agent_plugin_bastion) != 0 ? 0 : timestamp()
    instance_ocid  = oci_core_instance.WordPress_from_image[count.index].id
    private_ip     = oci_core_instance.WordPress_from_image[count.index].private_ip
  }
}

resource "oci_bastion_session" "ssh_via_bastion_service2plus" {
  depends_on = [oci_core_instance.WordPress]
  count      = var.numberOfNodes > 1 && var.use_bastion_service ? var.numberOfNodes - 1 : 0
  bastion_id = var.bastion_service_id == "" ? oci_bastion_bastion.bastion-service[0].id : var.bastion_service_id 

  key_details {
    public_key_content = tls_private_key.public_private_key_pair.public_key_openssh
  }

  target_resource_details {
    session_type                               = "MANAGED_SSH"
    target_resource_id                         = time_sleep.wordpress2plus_agent_checker[count.index].triggers["instance_ocid"]
    target_resource_operating_system_user_name = "opc"
    target_resource_port                       = 22
    target_resource_private_ip_address         = time_sleep.wordpress2plus_agent_checker[count.index].triggers["private_ip"]
  }

  display_name           = "ssh_via_bastion_service_to_wordpress${count.index + 2}"
  key_type               = "PUB"
  session_ttl_in_seconds = 10800
}