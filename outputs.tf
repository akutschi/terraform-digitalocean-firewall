data "digitalocean_firewall" "information" {
  firewall_id = digitalocean_firewall.droplet-fw.id
}

output "firewall_inventory" {
  value = {
    "name" : data.digitalocean_firewall.information.name,
    "droplets" : [for d in data.digitalocean_firewall.information.droplet_ids : d],
  }
}

