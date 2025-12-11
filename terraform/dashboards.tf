resource "yandex_monitoring_dashboard" "main_infra" {
  name        = "main-infra-dashboard"
  title       = "Main Infrastructure Monitoring"
  description = "Frontend, Postgres, NLB, Functions, Triggers"

  # ===============================
  # CPU Frontend
  # ===============================
  widgets {
    chart {
      title    = "CPU Frontend"
      chart_id = "cpu_frontend"

      queries {
        target {
          query = "cpu_usage{resource_id=\"${yandex_compute_instance.frontend.id}\"}"
        }
      }

      visualization_settings { type = "VISUALIZATION_TYPE_LINE" }
    }

    position {
      x = 0
      y = 0
      w = 12
      h = 5
    }
  }

  # ===============================
  # CPU Postgres
  # ===============================
  widgets {
    chart {
      title    = "CPU Postgres"
      chart_id = "cpu_postgres"

      queries {
        target {
          query = "cpu_usage{resource_id=\"${yandex_compute_instance.postgres.id}\"}"
        }
      }

      visualization_settings { type = "VISUALIZATION_TYPE_LINE" }
    }

    position {
      x = 12
      y = 0
      w = 12
      h = 5
    }
  }

  # ========================================================
  # FUNCTION: Reservation cleaner — Request Latency
  # ========================================================
  widgets {
    chart {
      title    = "Function Reservation Cleaner — Request Latency (ms)"
      chart_id = "func_reservation_cleaner_request_latency"

      queries {
        target {
          query = "histogram_percentile(as_vector(50, 75, 90, 95, 99), \"bin\", replace_nan(series_sum(as_vector(\"version\", \"bin\"), \"serverless.functions.execution_time_milliseconds\"{folderId=\"${var.folder_id}\", service=\"serverless-functions\", function=\"${yandex_function.reservation_cleaner.id}\", version=\"*\", bin=\"*\"}), 0))"
        }
      }

      visualization_settings { type = "VISUALIZATION_TYPE_LINE" }
    }

    position {
      x = 0
      y = 5
      w = 12
      h = 5
    }
  }

  # ========================================================
  # FUNCTION: Reservation cleaner — Errors
  # ========================================================
  widgets {
    chart {
      title    = "Function Reservation Cleaner — Errors"
      chart_id = "func_reservation_cleaner_errors"

      queries {
        target {
          query = "series_sum(\"version\", \"serverless.functions.errors_per_second\"{folderId=\"${var.folder_id}\", service=\"serverless-functions\", function=\"${yandex_function.reservation_cleaner.id}\", version=\"*\"})"
        }
      }

      visualization_settings { type = "VISUALIZATION_TYPE_LINE" }
    }

    position {
      x = 12
      y = 5
      w = 12
      h = 5
    }
  }

  # ========================================================
  # TRIGGER: Reservation Cleaner — Request Latency
  # ========================================================
  widgets {
    chart {
      title    = "Trigger Reservation Cleaner — Request Latency (ms)"
      chart_id = "trigger_reservation_cleaner_request_latency"

      queries {
        target {
          query = "histogram_percentile(as_vector(50, 75, 90, 95, 99), \"bin\", replace_nan(\"serverless.triggers.execution_time_milliseconds\"{folderId=\"${var.folder_id}\", service=\"serverless-functions\", bin=\"*\", type=\"request\", trigger=\"${yandex_function_trigger.reservation_cleaner_trigger.id}\"}, 0))"
        }
      }

      visualization_settings { type = "VISUALIZATION_TYPE_LINE" }
    }

    position {
      x = 0
      y = 10
      w = 12
      h = 5
    }
  }

  # ========================================================
  # TRIGGER: Reservation Cleaner — Errors
  # ========================================================
  widgets {
    chart {
      title    = "Trigger Reservation Cleaner — Errors"
      chart_id = "trigger_reservation_cleaner_errors"

      queries {
        target {
          query = "\"serverless.triggers.error_per_second\"{folderId=\"${var.folder_id}\", service=\"serverless-functions\", type=\"request\", trigger=\"${yandex_function_trigger.reservation_cleaner_trigger.id}\"}"
        }
      }

      visualization_settings { type = "VISUALIZATION_TYPE_LINE" }
    }

    position {
      x = 12
      y = 10
      w = 12
      h = 5
    }
  }
}
