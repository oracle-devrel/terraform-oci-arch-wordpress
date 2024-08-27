resource "oci_load_balancer" "lb01" {
  count = var.numberOfNodes > 1 ? 1 : 0
  shape = var.lb_shape

  dynamic "shape_details" {
    for_each = local.is_flexible_lb_shape ? [1] : []
    content {
      minimum_bandwidth_in_mbps = var.flex_lb_min_shape
      maximum_bandwidth_in_mbps = var.flex_lb_max_shape
    }
  }

  dynamic "reserved_ips" {
    for_each = var.numberOfNodes > 1 ? [1] : []
    content {
      id = oci_core_public_ip.WordPress_public_ip_for_multi_node[0].id
    }
  }
  compartment_id = var.compartment_ocid

  subnet_ids = [
    var.lb_subnet_id,
  ]

  display_name = "wordpress_lb"
  defined_tags = var.defined_tags
}

resource "oci_load_balancer_backend_set" "lb_bes_wp" {
  count            = var.numberOfNodes > 1 ? 1 : 0
  name             = "lb_app01"
  load_balancer_id = oci_load_balancer.lb01[count.index].id
  policy           = "ROUND_ROBIN"

  health_checker {
    port                = "80"
    protocol            = "HTTP"
    response_body_regex = ".*"
    url_path            = "/"
    interval_ms         = "10000"
    return_code         = "200"
    timeout_in_millis   = "3000"
    retries             = "3"
  }
}

resource "oci_load_balancer_listener" "lb_listener_wp" {
  count                    = var.numberOfNodes > 1 ? 1 : 0
  load_balancer_id         = oci_load_balancer.lb01[count.index].id
  name                     = "http"
  default_backend_set_name = oci_load_balancer_backend_set.lb_bes_wp[count.index].name
  port                     = 80
  protocol                 = "HTTP"

}

resource "oci_load_balancer_backend" "lb_be_wp1" {
  count            = var.numberOfNodes > 1 ? 1 : 0
  load_balancer_id = oci_load_balancer.lb01[0].id
  backendset_name  = oci_load_balancer_backend_set.lb_bes_wp[0].name
  ip_address       = oci_core_instance.WordPress.private_ip
  port             = 80
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}

resource "oci_load_balancer_backend" "lb_be_wp2plus" {
  count            = var.numberOfNodes > 1 ? var.numberOfNodes - 1 : 0
  load_balancer_id = oci_load_balancer.lb01[0].id
  backendset_name  = oci_load_balancer_backend_set.lb_bes_wp[0].name
  ip_address       = oci_core_instance.WordPress_from_image[count.index].private_ip
  port             = 80
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}

