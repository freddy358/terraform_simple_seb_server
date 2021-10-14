terraform {
  backend "s3" {
    bucket = "farid-terraform-state-files"
    key    = "terraform/webserver-state"
    region = "us-west-2"
  }
}