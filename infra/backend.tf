terraform {
  backend "s3" {
    bucket         = "tfstate-focuslistdinesh"
    key            = "focuslist/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
