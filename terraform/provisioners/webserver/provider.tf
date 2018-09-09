provider "aws" {
  region = "ap-southeast-2"
}

terraform {
 backend "s3" {
   encrypt = true
   bucket = "terraform-remote-state-storage-s3-chris"
   region = "ap-southeast-2"
   key = "path/to/state/file"
 }
}

