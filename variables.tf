variable "username" {
  description = "VK Cloud username email"
  type        = string
}

variable "password" {
  description = "VK Cloud password"
  type        = string
  sensitive   = true
}

variable "project_id" {
  description = "VK Cloud project ID"
  type        = string
}

variable "compute_flavor" {
  type = string
  default = "STD2-2-8"
}

variable "key_pair_name1" {
  type = string
  default = "ubuntu-Sokolova-HNI4S95u"
}

variable "key_pair_name2" {
  type = string
  default = "ubuntu-Sokolova-MM30Ta5p"
}

variable "key_pair_name3" {
  type = string
  default = "VM1-Sokolova-vUA6KexR"
}


