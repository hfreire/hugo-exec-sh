terraform {
  required_version = ">= 0.9.3, != 0.9.5"

  backend "s3" {}
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.50"
}

provider "template" {
  version = "1.0.0"
}

data "template_file" "container_definitions" {
  template = "${file("${path.module}/container-definitions.json")}"

  vars {
    name  = "${var.name}"
    image = "${var.docker_repo}/${var.name}:${var.version}"

    url                       = "${var.url}"
    mail__from                = "${var.mail__from}"
    mail__options__host       = "${var.mail__options__host}"
    mail__options__auth__user = "${var.mail__options__auth__user}"
    mail__options__auth__pass = "${var.mail__options__auth__pass}"
  }
}

module "hugo-exec-sh" {
  source = "github.com/antifragile-systems/antifragile-service"

  name       = "${var.name}"
  aws_region = "${var.aws_region}"

  service_desired_count = "${var.service_desired_count}"

  container_definitions            = "${data.template_file.container_definitions.rendered}"
  health_check_path_preappend_name = false

  cdn_enabled                        = 1
  cdn_certificate_validation_enabled = 0
  cdn_hostname                       = "${var.cdn_hostname}"
  cdn_hostname_aliases               = "${var.cdn_hostname_aliases}"
  cdn_hostname_redirects             = "${var.cdn_hostname_redirects}"
}
