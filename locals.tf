locals {
    azs = var.number_of_azs == 1 ? ["${var.region}a"] : var.number_of_azs == 2 ? ["${var.region}a", "${var.region}b"] : ["${var.region}a", "${var.region}b", "${var.region}c"]
    endpoint_config = yamldecode(file("./endpoints.yaml"))
}