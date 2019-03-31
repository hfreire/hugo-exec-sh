variable "infrastructure_name" {
  default = "antifragile-infrastructure"
}

variable "docker_repo" {}

variable "name" {
  default = "hugo-exec-sh"
}

variable "version" {}


variable "aws_region" {
  default = "eu-west-1"
}

variable "service_desired_count" {
  default = 3
}

variable "api_keys" {
  type    = "list"
  default = [ ]
}

variable "cdn_hostname" {
}

variable "cdn_hostname_aliases" {
  type    = "list"
  default = [ ]
}

variable "cdn_hostname_redirects" {
  type    = "list"
  default = [ ]
}

variable "url" {
  default = ""
}

variable "mail__from" {
  default = ""
}

variable "mail__options__host" {
  default = ""
}

variable "mail__options__auth__user" {
  default = ""
}

variable "mail__options__auth__pass" {
  default = ""
}
