# OCI Free Tier GitHub Actions Runner

Deploys an Always Free Oracle Cloud Ampere A1 (`VM.Standard.A1.Flex`, 4 OCPUs, 24 GB RAM, 100 GB boot disk) self-hosted GitHub Actions Runner for a GitHub Organization.

## Prerequisites

1. **Oracle Cloud API Key**:
   - In OCI Console -> **Profile (top right)** -> **User settings** -> **Tokens and keys** -> **API keys** -> **Add API key**.
   - Download the private key to `~/.oci/oci_api_key.pem` (`chmod 600 ~/.oci/oci_api_key.pem`) and copy the displayed `tenancy`, `user`, `fingerprint`, and `region` values.
        - On Windows run the following command:
        ```powershell
        mkdir "$HOME\.oci" -Force
        Move-Item -Path "$HOME\Downloads\oci-key.pem" -Destination "$HOME\.oci\oci_api_key.pem"
        ```
        - Then reference it in `terraform.tfvars`:
        ```tf
        private_key_path = "C:/Users/YourUsername/.oci/oci_api_key.pem"
        ```
2. **GitHub Fine-Grained PAT**:
   - Go to **GitHub Settings** -> **Developer settings** -> **Personal access tokens** -> [**Fine-grained tokens**](https://github.com/settings/personal-access-tokens).
   - Set **Resource owner** to your GitHub Organization.
   - Under **Permissions** -> **Organization permissions**, set **Self-hosted runners** to **Read and write**.

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your OCI & GitHub credentials

terraform init
terraform plan
terraform apply
```

## Using in GitHub Workflows

Target the runner in any repository within your organization:

```YAML
jobs:
  build:
    runs-on: [self-hosted, linux, arm64]
    steps:
      - uses: actions/checkout@v4
      - run: uname -a
```

### Quick Tip on Oracle "Out of Host Capacity"

Occasionally, Oracle's free tier throws an `Out of host capacity` error for `VM.Standard.A1.Flex` in busy regions when requesting all 4 OCPUs at once. If you hit that during `terraform apply`:
1. Lower `ocpus = 2` and `memory_in_gbs = 12` in `terraform.tfvars` (you can scale it up later in the console or via Terraform), **or**
2. Upgrade your OCI account to **Pay-As-You-Go (PAYG)**. Upgrading to PAYG removes the free-pool capacity restriction while **keeping the exact same Always Free allowance** (4 Ampere OCPUs + 24 GB RAM + 200 GB storage remain $0.00/month forever as long as you don't exceed those numbers).