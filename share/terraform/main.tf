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

    url = "${var.url}"
  }
}

module "hugo-exec-sh" {
  source = "github.com/antifragile-systems/antifragile-service"

  name       = "${var.name}"
  aws_region = "${var.aws_region}"

  service_desired_count = "${var.service_desired_count}"

  container_definitions            = "${data.template_file.container_definitions.rendered}"
  health_check_path_preappend_name = false

  cdn_enabled        = 1
  cdn_cnames         = "${var.cdn_cnames}"
  cdn_redirect_cname = "${var.cdn_redirect_cname}"
}
