#input variables 
variable "sub_PRD" {
  type = string
  description   = "Subscription Id for Prod Subscription"
}
variable "sub_NPR" {
  type = string
  description   = "Subscription Id for Non-Prod Subscription"
}

variable "system" {
  type = string
  description   = "System this Subscription will contain"
}

#tags
variable "businessowner" {
  type = string
  description   = "Distribution group that Ownes the Subscription"
  validation {
    condition     = can(regex("[a-z0-9]+@[a-z]+\\.[a-z]{2,3}", var.businessowner))
    error_message = "Must be valid email."
  }
}

variable "costcenter" {
  type = string
  description   = "Cost Center for the subscription"
}

variable "monthlybudget" {
  type = string
  description   = "Monthly budget for the Subscription"
}

variable "wiki" {
  type = string
  description   = "link to documentation"
}

#network info
variable "peer_PRD" {
  type = string
  description   = "Cidr address for the peer to on-premise network"
  validation {
    condition     = can(cidrhost(var.peer_PRD, 32))
    error_message = "Must be valid IPv4 CIDR."
  }
}
variable "peer_NPR" {
  type = string
  description   = "Cidr address for the peer to on-premise network"
  validation {
    condition     = can(cidrhost(var.peer_NPR, 32))
    error_message = "Must be valid IPv4 CIDR."
  }
}
