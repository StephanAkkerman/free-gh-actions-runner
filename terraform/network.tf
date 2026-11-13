resource "oci_core_vcn" "runner_vcn" {
  compartment_id = var.compartment_ocid
  cidr_blocks    = ["10.0.0.0/16"]
  display_name   = "gh-runner-vcn"
  dns_label      = "ghrunnervcn"
}

resource "oci_core_internet_gateway" "runner_igw" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.runner_vcn.id
  display_name   = "gh-runner-igw"
  enabled        = true
}

resource "oci_core_route_table" "runner_rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.runner_vcn.id
  display_name   = "gh-runner-rt"

  route_rules {
    network_entity_id = oci_core_internet_gateway.runner_igw.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}

resource "oci_core_security_list" "runner_sl" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.runner_vcn.id
  display_name   = "gh-runner-security-list"

  # Allow all outbound traffic (required to pull jobs from GitHub & packages/Docker images)
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
    stateless   = false
  }

  # Allow inbound SSH only
  ingress_security_rules {
    protocol  = "6" # TCP
    source    = var.ssh_allowed_cidr
    stateless = false

    tcp_options {
      min = 22
      max = 22
    }
  }
}

resource "oci_core_subnet" "runner_subnet" {
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_vcn.runner_vcn.id
  cidr_block                 = "10.0.1.0/24"
  display_name               = "gh-runner-public-subnet"
  dns_label                  = "ghrunnersub"
  route_table_id             = oci_core_route_table.runner_rt.id
  security_list_ids          = [oci_core_security_list.runner_sl.id]
  prohibit_public_ip_on_vnic = false
}