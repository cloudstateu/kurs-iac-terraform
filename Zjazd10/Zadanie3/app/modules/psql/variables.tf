variable "name" {
  description = "PostgreSQL Server Name"
  type        = string
}

variable "environment" {
  type = string
}

variable "rg" {
  type = object({
    name     = string
    location = string
  })
}

variable "vnet" {
  type = object({
    id = string
    name = string
  })
}

variable "subnet_id" {
  type = string
}

variable "administrator_login" {
  type      = string
  sensitive = true
}

variable "administrator_password" {
  type      = string
  sensitive = true
  nullable  = true
  default   = null
}

variable "databases" {
  type = map(string)
}
