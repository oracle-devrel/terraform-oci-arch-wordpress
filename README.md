# terraform-oci-arch-wordpress

This is Terraform module that deploys [WordPress](http://wordpress.org/) on [Oracle Cloud Infrastructure (OCI)](https://cloud.oracle.com/en_US/cloud-infrastructure).

## About
WordPress is a free and open-source content management system (CMS) written in PHP and paired with a MySQL database. Features include a plugin architecture and a template system, referred to within WordPress as Themes.

## Prerequisites
1. Download and install Terraform (v1.0 or later)
2. Download and install the OCI Terraform Provider (v4.4.0 or later)
3. Export OCI credentials. (this refer to the https://github.com/oracle/terraform-provider-oci )

## What's a Module?
A Module is a canonical, reusable, best-practices definition for how to run a single piece of infrastructure, such as a database or server cluster. Each Module is created using Terraform, and includes automated tests, examples, and documentation. It is maintained both by the open source community and companies that provide commercial support.
Instead of figuring out the details of how to run a piece of infrastructure from scratch, you can reuse existing code that has been proven in production. And instead of maintaining all that infrastructure code yourself, you can leverage the work of the Module community to pick up infrastructure improvements through a version number bump.

## How to use this Module
This Module has the following folder structure:
* [root](): This folder contains a root module.
* [examples](examples): This folder contains examples of how to use the module:
  - [WordPress single-node + custom network injected into module](examples/wordpress-single-mds-use-existing-network): This is an example of how to use the oci-arch-wordpress module to deploy WordPress (single-node) with MDS and network cloud infrastrucutre elements injected into the module.
  - [WordPress multi-node + custom network injected into module](examples/wordpress-ha-mds-use-existing-network): This is an example of how to use the oci-arch-wordpress module to deploy WordPress HA (multi-node) with MDS and network cloud infrastrucutre elements injected into the module.
  - [WordPress multi-node + custom network + Bastion Host injected into module](examples/wordpress-ha-mds-use-existing-network-and-injected-bastion-host): This is an example of how to use the oci-arch-wordpress module to deploy WordPress HA (multi-node) with MDS and network cloud infrastrucutre elements + Bastion Host injected into the module.
  - [WordPress multi-node + custom network + Bastion Service injected into module](examples/wordpress-ha-mds-use-existing-network-and-injected-bastion-service): This is an example of how to use the oci-arch-wordpress module to deploy WordPress HA (multi-node) with MDS and network cloud infrastrucutre elements + Bastion Service injected into the module.

To deploy WordPress using this Module with minimal effort use this:

```hcl
module "oci-arch-wordpress" {
  source                    = "github.com/oracle-devrel/terraform-oci-arch-wordpress"
  tenancy_ocid              = "<tenancy_ocid>"
  vcn_id                    = "<vcn_id>"
  numberOfNodes             = 1
  availability_domain_name  = "<availability_domain_name>"
  compartment_ocid          = "<compartment_ocid>""
  image_id                  = "<image_id>"
  shape                     = "<shape>"
  flex_shape_ocpus          = "<flex_shape_ocpus>"
  flex_shape_memory         = "<flex_shape_memory>" 
  label_prefix              = "<label_prefix>""
  ssh_authorized_keys       = "<ssh_public_key>"
  mds_ip                    = "<mysql_server_ip_address>"
  wp_subnet_id              = "<wordpress_subnet_id>"
  admin_password            = "<admin_password>"
  admin_username            = "<admin_username>"
  wp_auto_update            = "<wp_auto_update>" # false to block auto-update
  wp_schema                 = "<wp_schema>"
  wp_version                = "<wp_version>"
  wp_name                   = "<wp_name>"
  wp_password               = "<wp_password>"
  wp_site_title             = "<wp_site_title>"
  wp_site_admin_user        = "<wp_site_admin_user>"
  wp_site_admin_pass        = "<wp_site_admin_pass>"
  wp_site_admin_email       = "<wp_site_admin_email>"
}
```

Argument | Description
--- | ---
compartment_ocid | Compartment's OCID where WordPress will be created
use_existing_vcn | If you want to inject already exisitng VCN then you need to set the value to TRUE.
vcn_cidr | If use_existing_vcn is set to FALSE then you can define VCN CIDR block and then it will used to create VCN within the module.
vcn_id | If use_existing_vcn is set to TRUE then you can pass VCN OCID and module will use it to create WordPress installation.
numberOfNodes | If you need HA configuration with LB and FSS then set the value to 2 or more.
wp_subnet_id | The OCID of the WordPress public (single node) and private (multi node) subnet access. 
lb_subnet_id | If numberOfNodes set to 2 or more then you can provide OCID of the Load Balancer subnet.
bastion_subnet_id | If numberOfNodes set to 2 or more then you can use OCID of the Bastion subnet.
fss_subnet_id | If numberOfNodes set to 2 or more then you can use OCID of the File Storage Service subnet. 
availability_domain_name | The Availability Domain for deployment.
display_name | The name of the WordPress instance. 
shape | Instance shape to use for WordPress node.
flex_shape_ocpus | If shape is set to Flex shape then you can define Flex Shape OCPUs.
flex_shape_memory | If shape is set to Flex shape then you can define Flex Shape Memory (GB).
lb_shape | If numberOfNodes set to 2 or more then you can define Load Balancer shape
flex_lb_min_shape | If numberOfNodes set to 2 or more and lb_shape=flexible then you can define Load Balancer minimum shape.
flex_lb_max_shape | If numberOfNodes set to 2 or more and lb_shape=flexible then you can define Load Balancer maximum shape.
use_bastion_service | If you want to use OCI Bastion Service then you need to set the value to TRUE.
bastion_service_region | If use_bastion_service is set to TRUE then you can define bastion service region. 
bastion_image_id | If use_bastion_service is set to FALSE then you can define Bastion VM image id. 
bastion_shape | If use_bastion_service is set to FALSE then you can define Bastion VM shape.
bastion_flex_shape_ocpus | If use_bastion_service is set to FALSE and bastion_shape is using Flex shapes then you can define Flex Shape OCPUs.
bastion_flex_shape_memory | If use_bastion_service is set to FALSE and bastion_shape is using Flex shapes then you can define Flex Shape Memory (GB).
inject_bastion_service_id | Instead of counting on module to create Bastion Service you can pass Bastion Service OCID as input (set value to TRUE).
bastion_service_id | If inject_bastion_service_id is set to TRUE then you can pass here Bastion Service OCID as input.
inject_bastion_server_public_ip  | Instead of counting on module to create Bastion VM you can pass Bastion Host Public IP Address as input (set value to TRUE).
bastion_server_public_ip | If inject_bastion_server_public_ip is set to TRUE then you can pass here Bastion Host Public IP Address.
use_shared_storage | If numberOfNodes set to 2 or more then you can use shared NFS on OCI FSS (value TRUE). If you want to replicate WordPress by yourself (for example with rsync) then you can you can set the value to FALSE.
wp_shared_working_dir | If numberOfNodes set to 2 or more then you can define shared mountpoint name.
label_prefix | To create unique identifier for multiple clusters in a compartment.
wp_version | WordPress Version.
wp_name | WordPress Database User Name for MySQL Server.
wp_schema | WordPress Database User Schema for MySQL Server.
wp_password | WordPress Database User Password for MySQL Server.
wp_prefix | WordPress MySQL Prefix for tables (for example WordPress_)
wp_plugins | A list of WordPress plugins to install.
wp_themes" | A list of WordPress themes to install.
wp_working_dir | Decide where to store WordPress data.
wp_shared_working_dir | Decide where to store WordPress data.
wp_site_url | WordPress Site URL.
wp_site_title | WordPress Site Title.
wp_site_admin_user | WordPress Site Admin Username.
wp_site_admin_pass | WordPress Site Admin Password.
wp_site_admin_email | WordPress Site Admin Email.
admin_username | Admin User Name for MySQL Server.
admin_password | Admin User Password for MySQL Server.
mds_ip | Private IP of the MySQL Server.
defined_tags | Defined tags to be added to compute instances.

## Contributing
This project is open source.  Please submit your contributions by forking this repository and submitting a pull request!  Oracle appreciates any contributions that are made by the open source community.

## License
Copyright (c) 2024 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](LICENSE) for more details.
