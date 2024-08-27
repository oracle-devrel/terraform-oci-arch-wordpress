resource "null_resource" "WordPress_provisioner_with_bastion" {
  count = (var.numberOfNodes > 1 && !var.inject_bastion_server_public_ip) ? 1 : 0
  depends_on = [oci_core_instance.WordPress,
    oci_core_network_security_group.WordPressFSSSecurityGroup,
    oci_core_network_security_group_security_rule.WordPressFSSSecurityIngressTCPGroupRules1,
    oci_core_network_security_group_security_rule.WordPressFSSSecurityIngressTCPGroupRules2,
    oci_core_network_security_group_security_rule.WordPressFSSSecurityIngressUDPGroupRules1,
    oci_core_network_security_group_security_rule.WordPressFSSSecurityIngressUDPGroupRules2,
    oci_core_network_security_group_security_rule.WordPressFSSSecurityEgressTCPGroupRules1,
    oci_core_network_security_group_security_rule.WordPressFSSSecurityEgressTCPGroupRules2,
    oci_core_network_security_group_security_rule.WordPressFSSSecurityEgressUDPGroupRules1,
    oci_file_storage_export.WordPressExport,
    oci_file_storage_file_system.WordPressFilesystem,
    oci_file_storage_export_set.WordPressExportset,
  oci_file_storage_mount_target.WordPressMountTarget]

  provisioner "file" {
    content     = data.template_file.install_php.rendered
    destination = local.php_script

    connection {
      type                = "ssh"
      host                = data.oci_core_vnic.WordPress_vnic1.private_ip_address
      agent               = false
      timeout             = "5m"
      user                = var.vm_user
      private_key         = tls_private_key.public_private_key_pair.private_key_pem
      bastion_host        = var.use_bastion_service ? "host.bastion.${var.bastion_service_region}.oci.oraclecloud.com" : oci_core_instance.bastion_instance[0].public_ip
      bastion_user        = var.use_bastion_service ? oci_bastion_session.ssh_via_bastion_service[0].id : var.vm_user
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
  }

  provisioner "file" {
    source      = "${path.module}/scripts/htaccess"
    destination = local.htaccess

    connection {
      type                = "ssh"
      host                = data.oci_core_vnic.WordPress_vnic1.private_ip_address
      agent               = false
      timeout             = "5m"
      user                = var.vm_user
      private_key         = tls_private_key.public_private_key_pair.private_key_pem
      bastion_host        = var.use_bastion_service ? "host.bastion.${var.bastion_service_region}.oci.oraclecloud.com" : oci_core_instance.bastion_instance[0].public_ip
      bastion_user        = var.use_bastion_service ? oci_bastion_session.ssh_via_bastion_service[0].id : var.vm_user
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
  }

  provisioner "file" {
    content     = data.template_file.configure_local_security.rendered
    destination = local.security_script

    connection {
      type                = "ssh"
      host                = data.oci_core_vnic.WordPress_vnic1.private_ip_address
      agent               = false
      timeout             = "5m"
      user                = var.vm_user
      private_key         = tls_private_key.public_private_key_pair.private_key_pem
      bastion_host        = var.use_bastion_service ? "host.bastion.${var.bastion_service_region}.oci.oraclecloud.com" : oci_core_instance.bastion_instance[0].public_ip
      bastion_user        = var.use_bastion_service ? oci_bastion_session.ssh_via_bastion_service[0].id : var.vm_user
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
  }

  provisioner "file" {
    content     = data.template_file.create_wp_db.rendered
    destination = local.create_wp_db

    connection {
      type                = "ssh"
      host                = data.oci_core_vnic.WordPress_vnic1.private_ip_address
      agent               = false
      timeout             = "5m"
      user                = var.vm_user
      private_key         = tls_private_key.public_private_key_pair.private_key_pem
      bastion_host        = var.use_bastion_service ? "host.bastion.${var.bastion_service_region}.oci.oraclecloud.com" : oci_core_instance.bastion_instance[0].public_ip
      bastion_user        = var.use_bastion_service ? oci_bastion_session.ssh_via_bastion_service[0].id : var.vm_user
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
  }

  provisioner "file" {
    content     = data.template_file.setup_fss.rendered
    destination = local.setup_fss

    connection {
      type                = "ssh"
      host                = data.oci_core_vnic.WordPress_vnic1.private_ip_address
      agent               = false
      timeout             = "5m"
      user                = var.vm_user
      private_key         = tls_private_key.public_private_key_pair.private_key_pem
      bastion_host        = var.use_bastion_service ? "host.bastion.${var.bastion_service_region}.oci.oraclecloud.com" : oci_core_instance.bastion_instance[0].public_ip
      bastion_user        = var.use_bastion_service ? oci_bastion_session.ssh_via_bastion_service[0].id : var.vm_user
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
  }

  provisioner "file" {
    content     = data.template_file.setup_wp.rendered
    destination = local.setup_wp

    connection {
      type                = "ssh"
      host                = data.oci_core_vnic.WordPress_vnic1.private_ip_address
      agent               = false
      timeout             = "5m"
      user                = var.vm_user
      private_key         = tls_private_key.public_private_key_pair.private_key_pem
      bastion_host        = var.use_bastion_service ? "host.bastion.${var.bastion_service_region}.oci.oraclecloud.com" : oci_core_instance.bastion_instance[0].public_ip
      bastion_user        = var.use_bastion_service ? oci_bastion_session.ssh_via_bastion_service[0].id : var.vm_user
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
  }

  provisioner "remote-exec" {
    connection {
      type                = "ssh"
      host                = data.oci_core_vnic.WordPress_vnic1.private_ip_address
      agent               = false
      timeout             = "5m"
      user                = var.vm_user
      private_key         = tls_private_key.public_private_key_pair.private_key_pem
      bastion_host        = var.use_bastion_service ? "host.bastion.${var.bastion_service_region}.oci.oraclecloud.com" : oci_core_instance.bastion_instance[0].public_ip
      bastion_user        = var.use_bastion_service ? oci_bastion_session.ssh_via_bastion_service[0].id : var.vm_user
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }

    inline = [
      "chmod +x ${local.php_script}",
      "sudo ${local.php_script}",
      "chmod +x ${local.security_script}",
      "sudo ${local.security_script}",
      "chmod +x ${local.create_wp_db}",
      "sudo ${local.create_wp_db}",
      "chmod +x ${local.setup_fss}",
      "sudo ${local.setup_fss}",
      "chmod +x ${local.setup_wp}",
      "sudo ${local.setup_wp}"
    ]

  }

}

resource "null_resource" "WordPress_provisioner_with_injected_bastion_server_public_ip" {
  count = (var.numberOfNodes > 1 && var.inject_bastion_server_public_ip) ? 1 : 0
  depends_on = [oci_core_instance.WordPress,
    oci_core_network_security_group.WordPressFSSSecurityGroup,
    oci_core_network_security_group_security_rule.WordPressFSSSecurityIngressTCPGroupRules1,
    oci_core_network_security_group_security_rule.WordPressFSSSecurityIngressTCPGroupRules2,
    oci_core_network_security_group_security_rule.WordPressFSSSecurityIngressUDPGroupRules1,
    oci_core_network_security_group_security_rule.WordPressFSSSecurityIngressUDPGroupRules2,
    oci_core_network_security_group_security_rule.WordPressFSSSecurityEgressTCPGroupRules1,
    oci_core_network_security_group_security_rule.WordPressFSSSecurityEgressTCPGroupRules2,
    oci_core_network_security_group_security_rule.WordPressFSSSecurityEgressUDPGroupRules1,
    oci_file_storage_export.WordPressExport,
    oci_file_storage_file_system.WordPressFilesystem,
    oci_file_storage_export_set.WordPressExportset,
  oci_file_storage_mount_target.WordPressMountTarget]

  provisioner "file" {
    content     = data.template_file.install_php.rendered
    destination = local.php_script

    connection {
      type                = "ssh"
      host                = data.oci_core_vnic.WordPress_vnic1.private_ip_address
      agent               = false
      timeout             = "5m"
      user                = var.vm_user
      private_key         = tls_private_key.public_private_key_pair.private_key_pem
      bastion_host        = var.bastion_server_public_ip
      bastion_user        = var.vm_user
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
  }

  provisioner "file" {
    source      = "${path.module}/scripts/htaccess"
    destination = local.htaccess

    connection {
      type                = "ssh"
      host                = data.oci_core_vnic.WordPress_vnic1.private_ip_address
      agent               = false
      timeout             = "5m"
      user                = var.vm_user
      private_key         = tls_private_key.public_private_key_pair.private_key_pem
      bastion_host        = var.bastion_server_public_ip
      bastion_user        = var.vm_user
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
  }

  provisioner "file" {
    content     = data.template_file.configure_local_security.rendered
    destination = local.security_script

    connection {
      type                = "ssh"
      host                = data.oci_core_vnic.WordPress_vnic1.private_ip_address
      agent               = false
      timeout             = "5m"
      user                = var.vm_user
      private_key         = tls_private_key.public_private_key_pair.private_key_pem
      bastion_host        = var.bastion_server_public_ip
      bastion_user        = var.vm_user
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
  }

  provisioner "file" {
    content     = data.template_file.create_wp_db.rendered
    destination = local.create_wp_db

    connection {
      type                = "ssh"
      host                = data.oci_core_vnic.WordPress_vnic1.private_ip_address
      agent               = false
      timeout             = "5m"
      user                = var.vm_user
      private_key         = tls_private_key.public_private_key_pair.private_key_pem
      bastion_host        = var.bastion_server_public_ip
      bastion_user        = var.vm_user
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
  }

  provisioner "file" {
    content     = data.template_file.setup_fss.rendered
    destination = local.setup_fss

    connection {
      type                = "ssh"
      host                = data.oci_core_vnic.WordPress_vnic1.private_ip_address
      agent               = false
      timeout             = "5m"
      user                = var.vm_user
      private_key         = tls_private_key.public_private_key_pair.private_key_pem
      bastion_host        = var.bastion_server_public_ip
      bastion_user        = var.vm_user
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
  }

  provisioner "file" {
    content     = data.template_file.setup_wp.rendered
    destination = local.setup_wp

    connection {
      type                = "ssh"
      host                = data.oci_core_vnic.WordPress_vnic1.private_ip_address
      agent               = false
      timeout             = "5m"
      user                = var.vm_user
      private_key         = tls_private_key.public_private_key_pair.private_key_pem
      bastion_host        = var.bastion_server_public_ip
      bastion_user        = var.vm_user
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }
  }

  provisioner "remote-exec" {
    connection {
      type                = "ssh"
      host                = data.oci_core_vnic.WordPress_vnic1.private_ip_address
      agent               = false
      timeout             = "5m"
      user                = var.vm_user
      private_key         = tls_private_key.public_private_key_pair.private_key_pem
      bastion_host        = var.bastion_server_public_ip
      bastion_user        = var.vm_user
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }

    inline = [
      "chmod +x ${local.php_script}",
      "sudo ${local.php_script}",
      "chmod +x ${local.security_script}",
      "sudo ${local.security_script}",
      "chmod +x ${local.create_wp_db}",
      "sudo ${local.create_wp_db}",
      "chmod +x ${local.setup_fss}",
      "sudo ${local.setup_fss}",
      "chmod +x ${local.setup_wp}",
      "sudo ${local.setup_wp}"
    ]

  }

}
