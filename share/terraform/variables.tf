variable "state_aws_region" {
}

variable "state_aws_s3_bucket" {
}

variable "infrastructure_name" {
  default = "antifragile-infrastructure"
}

variable "docker_repo" {
}

variable "docker_image_tag" {
}

variable "name" {
  default = "hugo-exec-sh"
}

variable "aws_region" {
  default = "eu-west-1"
}

variable "service_desired_count" {
  // https://ghost.org/faq/clustering-sharding-multi-server/?_ga=2.230977878.855100731.1561154377-2032773571.1561154377
  default = 1
}

variable "api_keys" {
  type    = list(string)
  default = [ ]
}

variable "cdn_hostname" {
}

variable "cdn_hostname_aliases" {
  type    = list(string)
  default = [ ]
}

variable "cdn_hostname_redirects" {
  type    = list(string)
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

variable "database_user_password" {
  default = null
}
