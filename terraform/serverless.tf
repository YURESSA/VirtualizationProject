resource "yandex_function" "reservation_cleaner" {
  name               = "reservation-cleaner"
  description        = "Удаляет неоплаченные бронирования старше 15 минут"

  user_hash          = "v1"
  runtime            = "python311"
  entrypoint         = "index.handler"
  memory             = 256
  execution_timeout  = 30
  service_account_id = var.sa_cleanup

  environment = {
    POSTGRES_HOST     = yandex_compute_instance.postgres.network_interface[0].nat_ip_address
    POSTGRES_DB       = var.postgres_db
    POSTGRES_USER     = var.postgres_user
    POSTGRES_PASSWORD = var.postgres_password
  }

  content {
    zip_filename = "${path.module}/serverless/function.zip"
  }
}


resource "yandex_function_trigger" "reservation_cleaner_trigger" {
  name        = "reservation-cleaner-trigger"
  description = "Запускает функцию каждые 15 минут"

  function {
    id                 = yandex_function.reservation_cleaner.id
    service_account_id = var.sa_cleanup
  }

  timer {
    cron_expression = "*/15 * ? * * *"
  }
}
