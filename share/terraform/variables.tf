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

variable "cdn_cnames" {
  type    = "list"
  default = [ ]
}

variable "cdn_redirect_cname" {
  default = ""
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
