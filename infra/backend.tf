terraform {
  backend "s3" {
    bucket = "your-terraform-state-bucket"
    key    = "focuslist/terraform.tfstate"
    region = "ap-south-1"
  }
}
