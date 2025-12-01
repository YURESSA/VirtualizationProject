resource "yandex_storage_bucket" "project_bucket" {
  bucket        = var.bucket_name
  access_key    = var.yc_access_key
  secret_key    = var.yc_secret_key
  acl           = "private"
  force_destroy = true
}