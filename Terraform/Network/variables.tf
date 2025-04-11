variable "vpc" {
  type = object({
    az_count             = number
    cidr_block           = string
    enable_dns_support   = bool
    enable_dns_hostnames = bool
  })
  default = {
    az_count             = 2
    cidr_block           = "172.16.0.0/16"
    enable_dns_support   = true
    enable_dns_hostnames = true
  }

}
