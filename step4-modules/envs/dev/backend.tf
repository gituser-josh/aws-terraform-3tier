terraform {
  backend "s3" {
    bucket         = "tfstate-125291801547-ap-northeast-1"
    key            = "step4/dev/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}