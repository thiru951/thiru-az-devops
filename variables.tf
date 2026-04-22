variable "admin_username" {
  type = string
}

variable "admin_password" {
  type      = string
  sensitive = true
}
