terraform {
  required_version = ">= 0.12"

  backend "s3" {
  }
}

provider "aws" {
  version = "2.14.0"

  region = var.aws_region
}

provider "template" {
  version = "2.1.2"
}

data "template_file" "container_definitions" {
  template = file("${path.module}/container-definitions.json")

  vars = {
    name                      = var.name
    image                     = "${var.docker_repo}/${var.name}:${var.docker_image_tag}"
    url                       = var.url
    mail__from                = var.mail__from
    mail__options__host       = var.mail__options__host
    mail__options__auth__user = var.mail__options__auth__user
    mail__options__auth__pass = var.mail__options__auth__pass
  }
}

module "hugo-exec-sh" {
  source = "github.com/antifragile-systems/antifragile-service"

  name       = var.name
  aws_region = var.aws_region

  loadbalancer_session_stickiness_enabled = true
  service_desired_count                   = var.service_desired_count

  container_definitions            = data.template_file.container_definitions.rendered
  health_check_path_preappend_name = false

  cdn_enabled                        = 1
  cdn_certificate_validation_enabled = 0
  cdn_hostname                       = var.cdn_hostname
  cdn_hostname_aliases               = var.cdn_hostname_aliases
  cdn_hostname_redirects             = var.cdn_hostname_redirects
}

