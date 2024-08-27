# FSS NSG
resource "oci_core_network_security_group" "WordPressFSSSecurityGroup" {
  count          = var.numberOfNodes > 1 && var.use_shared_storage ? 1 : 0
  compartment_id = var.compartment_ocid
  display_name   = "WordPressFSSSecurityGroup"
  vcn_id         = var.vcn_id
}

# FSS NSG Ingress TCP Rules
resource "oci_core_network_security_group_security_rule" "WordPressFSSSecurityIngressTCPGroupRules1" {
  count = var.numberOfNodes > 1 && var.use_shared_storage ? 1 : 0

  network_security_group_id = oci_core_network_security_group.WordPressFSSSecurityGroup[0].id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = data.oci_core_subnet.wp_subnet_ds[0].cidr_block
  source_type               = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      max = 111
      min = 111
    }
  }
}

# FSS NSG Ingress TCP Rules
resource "oci_core_network_security_group_security_rule" "WordPressFSSSecurityIngressTCPGroupRules2" {
  count = var.numberOfNodes > 1 && var.use_shared_storage ? 1 : 0

  network_security_group_id = oci_core_network_security_group.WordPressFSSSecurityGroup[0].id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = data.oci_core_subnet.wp_subnet_ds[0].cidr_block
  source_type               = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      max = 2050
      min = 2048
    }
  }
}

# FSS NSG Ingress UDP Rules
resource "oci_core_network_security_group_security_rule" "WordPressFSSSecurityIngressUDPGroupRules1" {
  count = var.numberOfNodes > 1 && var.use_shared_storage ? 1 : 0

  network_security_group_id = oci_core_network_security_group.WordPressFSSSecurityGroup[0].id
  direction                 = "INGRESS"
  protocol                  = "17"
  source                    = data.oci_core_subnet.wp_subnet_ds[0].cidr_block
  source_type               = "CIDR_BLOCK"

  udp_options {
    destination_port_range {
      max = 111
      min = 111
    }
  }
}

# FSS NSG Ingress UDP Rules
resource "oci_core_network_security_group_security_rule" "WordPressFSSSecurityIngressUDPGroupRules2" {
  count = var.numberOfNodes > 1 && var.use_shared_storage ? 1 : 0

  network_security_group_id = oci_core_network_security_group.WordPressFSSSecurityGroup[0].id
  direction                 = "INGRESS"
  protocol                  = "17"
  source                    = data.oci_core_subnet.wp_subnet_ds[0].cidr_block
  source_type               = "CIDR_BLOCK"

  udp_options {
    destination_port_range {
      max = 2048
      min = 2048
    }
  }
}


# FSS NSG Egress TCP Rules
resource "oci_core_network_security_group_security_rule" "WordPressFSSSecurityEgressTCPGroupRules1" {
  count = var.numberOfNodes > 1 && var.use_shared_storage ? 1 : 0

  network_security_group_id = oci_core_network_security_group.WordPressFSSSecurityGroup[0].id
  direction                 = "EGRESS"
  protocol                  = "6"
  destination               = data.oci_core_subnet.wp_subnet_ds[0].cidr_block
  destination_type          = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      max = 111
      min = 111
    }
  }
}

# FSS NSG Egress TCP Rules
resource "oci_core_network_security_group_security_rule" "WordPressFSSSecurityEgressTCPGroupRules2" {
  count = var.numberOfNodes > 1 && var.use_shared_storage ? 1 : 0

  network_security_group_id = oci_core_network_security_group.WordPressFSSSecurityGroup[0].id
  direction                 = "EGRESS"
  protocol                  = "6"
  destination               = data.oci_core_subnet.wp_subnet_ds[0].cidr_block
  destination_type          = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      max = 2050
      min = 2048
    }
  }
}


# FSS NSG Egress UDP Rules
resource "oci_core_network_security_group_security_rule" "WordPressFSSSecurityEgressUDPGroupRules1" {
  count = var.numberOfNodes > 1 && var.use_shared_storage ? 1 : 0

  network_security_group_id = oci_core_network_security_group.WordPressFSSSecurityGroup[0].id
  direction                 = "EGRESS"
  protocol                  = "17"
  destination               = data.oci_core_subnet.wp_subnet_ds[0].cidr_block
  destination_type          = "CIDR_BLOCK"

  udp_options {
    destination_port_range {
      max = 111
      min = 111
    }
  }

}
