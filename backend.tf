terraform {
  backend "s3" {
    encrypt = true
    bucket = "terraform-remotestate-tietoaws"
    key = "geo-test-cluster/terraform.tfstate"
    region = "eu-west-1"
    
  }
}