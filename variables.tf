variable "do_token" {
  description = "API key for Digitalocean"
  type        = string
  sensitive   = true
}

variable "do_droplets" {
  description = "Droplets that will be assigned to the firewall"
  type        = list(string)
  default     = []
}

variable "do_inbound_rules" {
  description = "List of allowed ports, protocols and source addresses"
  type        = list(string)
  default     = []
}

variable "do_firewall_name" {
  description = "Name of the firewall"
  type        = string
  default     = "firewall"
}
