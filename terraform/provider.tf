terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.90.0"
    }
  }
}

provider "yandex" {
  service_account_key_file = "${path.module}/key.json"
  cloud_id                 = var.yc_cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}