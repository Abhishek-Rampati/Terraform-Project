resource "random_integer" "rand" {
  min = 10000
  max = 99999

}


locals {
  common_tags = {
    company      = var.company_name
    Billing_code = var.Billing_code
    project      = "${var.company_name}-${var.project}"
  }

  s3_bucket_name = "global-web-app-${random_integer.rand.result}"
}