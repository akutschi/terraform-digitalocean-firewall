# Digitalocean Droplets Module

This module will create a [Digitalocean](digitalocean.com) firewall to protected a Digitalocean VM - aka droplet.

# Requirements

## Digitalocean

A `personal access token` is required. Get this at `Account -> API -> Generate New Token` or click just [here](https://cloud.digitalocean.com/account/api/tokens). Replace `<token>` in `secrets.tfvars`.

## Secrets

Quite obvious: A `secrets.tfvars` file is required to store your credentials for Cloudflare and Digitalocean.

# Firewall Defaults

- By default only `ssh` on port 22 and `ICMP` are open to the outside world. 
- Outbound are no limitations. 

# Example Usage

## Basic Example - Just a Plain Firewall

Either you use the example below where the module will be grabbed from [GitHub](github.com) direct or clone the repository and get the relative path to the module. Replace the GitHub link with the relative path (i.e. `"../../module/terraform-digitalocean-cloudflare-droplet-firewall"`) in the following `main.tf`:

```hcl
terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
  }
  required_version = ">= 0.14, < 0.15"
}

provider "digitalocean" {
  token = var.do_token
}

module "example-firewall" {
  source = "github.com/akutschi/terraform-digitalocean-firewall?ref=v0.0.1"

  do_firewall_name = "example-droplet-firewall"

  do_droplets = concat(module.example.droplet_inventory[*].droplet_id)

  do_token = var.do_token

  do_inbound_rules = [
      "80/tcp",
      "443/tcp",
  ]

}
```

In the same directory `variables.tf` is required: 

```hcl
variable "do_token" {
  description = "API key for Digitalocean"
  type        = string
  sensitive   = true
}
```

And the secrets are stored in `secrets.tfvars`:

```hcl
do_token = "<token>"
```

Assuming that all files are in the same directory, run `terraform plan -var-file=./secrets.tfvars` check the changes and `terraform apply -var-file=./secrets.tfvars` to apply the plan. 

## Example with Droplet Provisioning
Either you use the example below where two modules will be grabbed from [GitHub](github.com) direct or clone the repository and get the relative path to the modules. Replace the GitHub link with the relative path (i.e. `"../../module/terraform-digitalocean-cloudflare-droplet-firewall"`) in the following `main.tf`:

```hcl
terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
  required_version = ">= 0.14, < 0.15"
}

provider "digitalocean" {
  token = var.do_token
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

module "example-firewall" {
  source = "github.com/akutschi/terraform-digitalocean-firewall?ref=v0.0.1"

  do_firewall_name = "example-droplet-firewall"

  do_droplets = concat(module.example.droplet_inventory[*].droplet_id)

  do_token = var.do_token

  do_inbound_rules = [
      "80/tcp",
      "443/tcp",
  ]

}

module "example" {
  source = "github.com/akutschi/terraform-digitalocean-cloudflare-droplet?ref=v0.1.0"

  do_token        = var.do_token
  ssh_public_keys = var.ssh_public_keys

  resource_number_server = 1

  resource_country     = "de"
  resource_datacenter  = "fra1"
  resource_project     = "demo"
  resource_purpose     = "example"
  resource_environment = "dev"

  resource_tags = [
      "example-tag-1",
      "example-tag-2:,
  ]

  cloudflare_email   = var.cloudflare_email
  cloudflare_api_key = var.cloudflare_api_key
  cloudflare_tld     = "example.com"
}
```

In the same directory `variables.tf` is required: 

```hcl
variable "do_token" {
  description = "API key for Digitalocean"
  type        = string
  sensitive   = true
}

variable "ssh_public_keys" {
  description = "Fingerprints of public ssh keys"
  type        = list(string)
  sensitive   = true
}

variable "cloudflare_email" {
  description = "The E-Mail address assigned to the Cloudflare account"
  type        = string
  sensitive   = true
}

variable "cloudflare_api_key" {
  description = "API key for Cloudflare"
  type        = string
  sensitive   = true
}
```

And the secrets are stored in `secrets.tfvars`:

```hcl
do_token = "<token>"

ssh_public_keys = [
    "<public_key_fingerprint>",
  ]

cloudflare_email = "<name>@example.com"

cloudflare_api_key = "<key>"
```

Assuming that all files are in the same directory, run `terraform plan -var-file=./secrets.tfvars` check the changes and `terraform apply -var-file=./secrets.tfvars` to apply the plan. 

# Argument Reference

- `do_token` - (**Required**) API key for Digitalocean.

- `do_inbound_rules` - (Optional) List of allowed ports, protocols and source addresses. Type is `list(string)`. Default is an empty list. Everything incoming except 22 and ICMP will be blocked by default. Outgoing traffic is unblocked.
