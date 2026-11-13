# --- OCI Authentication & Target ---
variable "tenancy_ocid" {
  description = "OCID of your OCI tenancy"
  type        = string
}

variable "user_ocid" {
  description = "OCID of the OCI user running Terraform"
  type        = string
}

variable "fingerprint" {
  description = "Fingerprint for the OCI API RSA key"
  type        = string
}

variable "private_key_path" {
  description = "Local path to the OCI API private key (.pem)"
  type        = string
}

variable "region" {
  description = "OCI Region (e.g., eu-amsterdam-1, eu-frankfurt-1)"
  type        = string
  default     = "eu-amsterdam-1"
}

variable "compartment_ocid" {
  description = "OCID of the compartment where resources will be created (can be root tenancy OCID)"
  type        = string
}

# --- Compute Specs (Always Free Limits: up to 4 OCPUs, 24GB RAM, 200GB storage) ---
variable "availability_domain_index" {
  description = "Index of the Availability Domain (0, 1, or 2). Most single-AD EU regions use 0."
  type        = number
  default     = 0
}

variable "ocpus" {
  description = "Number of OCPUs for Ampere A1 (1 to 4 for Always Free)"
  type        = number
  default     = 4
}

variable "memory_in_gbs" {
  description = "Amount of RAM in GB (6 GB per OCPU recommended, up to 24 GB for Always Free)"
  type        = number
  default     = 24
}

variable "boot_volume_size_in_gbs" {
  description = "Boot volume size in GB (50 to 200 GB is covered by Always Free)"
  type        = number
  default     = 200
}

variable "ssh_public_key" {
  description = "SSH public key string (e.g., ssh-ed25519 AAAA...)"
  type        = string
}

variable "ssh_allowed_cidr" {
  description = "CIDR block allowed to SSH into the runner (set to YOUR_IP/32 for tighter security)"
  type        = string
  default     = "0.0.0.0/0"
}

# --- GitHub Runner Configuration ---
variable "github_org" {
  description = "GitHub Organization name (e.g., my-org)"
  type        = string
}

variable "github_pat" {
  description = "Fine-grained GitHub PAT with Organization 'Self-hosted runners: Read and write' permission"
  type        = string
  sensitive   = true
}

variable "runner_name_prefix" {
  description = "Prefix for the self-hosted runners displayed in GitHub (e.g., oci-ampere-runner-01, -02)"
  type        = string
  default     = "oci-ampere-runner"
}

variable "runner_count" {
  description = "Number of concurrent GitHub Action runner services to install on this VM"
  type        = number
  default     = 2 # could try 3 too
}

variable "runner_labels" {
  description = "Comma-separated labels to attach to the GitHub runner"
  type        = string
  default     = "self-hosted,linux,arm64,oci-free"
}