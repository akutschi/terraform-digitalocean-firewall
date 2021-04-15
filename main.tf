terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.4"
    }
  }
  required_version = ">= 0.14, < 0.16"
}

resource "digitalocean_firewall" "droplet-fw" {
  name = var.do_firewall_name

  droplet_ids = var.do_droplets

  dynamic "inbound_rule" {
    iterator = rule
    for_each = var.do_inbound_rules
    content {
      port_range       = split("/", rule.value)[0]
      protocol         = split("/", rule.value)[1]
      source_addresses = ["0.0.0.0/0", "::/0"]
    }
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
