# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------
variable "name" {
    type = string
    description = "The name of the project."
    default = "jumpserver"
}

variable "location" {
  type        = string
  default     = "northeurope"
  description = "The azure location"
}

variable "resource_group_name" {
  type        = string
  default     = "jumpserver"
  description = "The resource group name"
}

variable "subnet_id" {
  type        = any
  description = "The default subnet id"
}

variable "public_url" {
  description = "The public subdomain name."
  default     = "jumpserver"
}

variable "tags" {
  description = "The tags to associate with all resources."
  type        = "map"

  default = {
    author = "Kai Kahllund"
    project = "jumpserver"
  }
}

variable "os_user" {
  description = "The admin username of the VM that will be deployed"
  default     = "centos"
}

variable "ssh_key" {
  description = "Path to the public key to be used for ssh access to the VM."
  default     = "~/.ssh/id_rsa.pub"
}