resource "yandex_monitoring_dashboard" "main_infra" {
  name        = "main-infra-dashboard"
  title       = "Main Infrastructure Monitoring"
  description = "Frontend, Backend, Postgres, NLB"

  # ===============================
  # CPU Backend-1
  # ===============================
  widgets {
    chart {
      title          = "CPU Backend-1"
      chart_id       = "cpu_backend_1"
      display_legend = false

      queries {
        target {
          query = "cpu_usage{resource_id=\"${yandex_compute_instance.backend[0].id}\"}"
        }
      }

      visualization_settings {
        type        = "VISUALIZATION_TYPE_LINE"
        aggregation = "SERIES_AGGREGATION_AVG"
      }
    }

    position {
      x = 0
      y = 0
      w = 6
      h = 5
    }
  }

  # ===============================
  # CPU Backend-2
  # ===============================
  widgets {
    chart {
      title          = "CPU Backend-2"
      chart_id       = "cpu_backend_2"
      display_legend = false

      queries {
        target {
          query = "cpu_usage{resource_id=\"${yandex_compute_instance.backend[1].id}\"}"
        }
      }

      visualization_settings {
        type        = "VISUALIZATION_TYPE_LINE"
        aggregation = "SERIES_AGGREGATION_AVG"
      }
    }

    position {
      x = 6
      y = 0
      w = 6
      h = 5
    }
  }

  # ===============================
  # CPU Backend-3
  # ===============================
  widgets {
    chart {
      title          = "CPU Backend-3"
      chart_id       = "cpu_backend_3"
      display_legend = false

      queries {
        target {
          query = "cpu_usage{resource_id=\"${yandex_compute_instance.backend[2].id}\"}"
        }
      }

      visualization_settings {
        type        = "VISUALIZATION_TYPE_LINE"
        aggregation = "SERIES_AGGREGATION_AVG"
      }
    }

    position {
      x = 12
      y = 0
      w = 6
      h = 5
    }
  }

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
      y = 5
      w = 6
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
      x = 6
      y = 5
      w = 12
      h = 5
    }
  }
}


resource "yandex_monitoring_dashboard" "backend_1" {
  name        = "backend-1-dashboard"
  title       = "Мониторинг Backend-1"
  description = "Метрики CPU, памяти и сети для Backend-1"

  # ===============================
  # CPU
  # ===============================
  widgets {
    chart {
      title          = "CPU Backend-1"
      chart_id       = "cpu_backend_1"
      display_legend = false
      queries {
        target {
          query = "cpu_usage{resource_id=\"${yandex_compute_instance.backend[0].id}\"}"
        }
      }
      visualization_settings {
        type        = "VISUALIZATION_TYPE_LINE"
        aggregation = "SERIES_AGGREGATION_AVG"
      }
    }
    position {
      x = 0
      y = 0
      w = 24
      h = 6
    }
  }

  # ===============================
  # Сетевые пакеты (Полученные / Отправленные)
  # ===============================
  widgets {
    chart {
      title          = "Полученные сетевые пакеты Backend-1"
      chart_id       = "net_recv_packets_backend_1"
      display_legend = false
      queries {
        target {
          query = "network_received_packets{resource_id=\"${yandex_compute_instance.backend[0].id}\"}"
        }
      }
      visualization_settings {
        type        = "VISUALIZATION_TYPE_LINE"
        aggregation = "SERIES_AGGREGATION_SUM"
      }
    }
    position {
      x = 0
      y = 6
      w = 12
      h = 5
    }
  }

  widgets {
    chart {
      title          = "Отправленные сетевые пакеты Backend-1"
      chart_id       = "net_sent_packets_backend_1"
      display_legend = false
      queries {
        target {
          query = "network_sent_packets{resource_id=\"${yandex_compute_instance.backend[0].id}\"}"
        }
      }
      visualization_settings {
        type        = "VISUALIZATION_TYPE_LINE"
        aggregation = "SERIES_AGGREGATION_SUM"
      }
    }
    position {
      x = 12
      y = 6
      w = 12
      h = 5
    }
  }

  # ===============================
  # Отправленные байты
  # ===============================
  widgets {
    chart {
      title          = "Отправленные байты Backend-1"
      chart_id       = "net_sent_bytes_backend_1"
      display_legend = false
      queries {
        target {
          query = "network_sent_bytes{resource_id=\"${yandex_compute_instance.backend[0].id}\"}"
        }
      }
      visualization_settings {
        type        = "VISUALIZATION_TYPE_LINE"
        aggregation = "SERIES_AGGREGATION_SUM"
      }
    }
    position {
      x = 0
      y = 11
      w = 24
      h = 6
    }
  }
}

resource "yandex_monitoring_dashboard" "backend_2" {
  name        = "backend-2-dashboard"
  title       = "Мониторинг Backend-2"
  description = "Метрики CPU, памяти и сети для Backend-2"

  # ===============================
  # CPU
  # ===============================
  widgets {
    chart {
      title          = "CPU Backend-2"
      chart_id       = "cpu_backend_2"
      display_legend = false
      queries {
        target {
          query = "cpu_usage{resource_id=\"${yandex_compute_instance.backend[1].id}\"}"
        }
      }
      visualization_settings {
        type        = "VISUALIZATION_TYPE_LINE"
        aggregation = "SERIES_AGGREGATION_AVG"
      }
    }
    position {
      x = 0
      y = 0
      w = 24
      h = 6
    }
  }

  # ===============================
  # Сетевые пакеты (Полученные / Отправленные)
  # ===============================
  widgets {
    chart {
      title          = "Полученные сетевые пакеты Backend-2"
      chart_id       = "net_recv_packets_backend_2"
      display_legend = false
      queries {
        target {
          query = "network_received_packets{resource_id=\"${yandex_compute_instance.backend[1].id}\"}"
        }
      }
      visualization_settings {
        type        = "VISUALIZATION_TYPE_LINE"
        aggregation = "SERIES_AGGREGATION_SUM"
      }
    }
    position {
      x = 0
      y = 6
      w = 12
      h = 5
    }
  }

  widgets {
    chart {
      title          = "Отправленные сетевые пакеты Backend-2"
      chart_id       = "net_sent_packets_backend_2"
      display_legend = false
      queries {
        target {
          query = "network_sent_packets{resource_id=\"${yandex_compute_instance.backend[1].id}\"}"
        }
      }
      visualization_settings {
        type        = "VISUALIZATION_TYPE_LINE"
        aggregation = "SERIES_AGGREGATION_SUM"
      }
    }
    position {
      x = 12
      y = 6
      w = 12
      h = 5
    }
  }

  # ===============================
  # Отправленные байты
  # ===============================
  widgets {
    chart {
      title          = "Отправленные байты Backend-2"
      chart_id       = "net_sent_bytes_backend_2"
      display_legend = false
      queries {
        target {
          query = "network_sent_bytes{resource_id=\"${yandex_compute_instance.backend[1].id}\"}"
        }
      }
      visualization_settings {
        type        = "VISUALIZATION_TYPE_LINE"
        aggregation = "SERIES_AGGREGATION_SUM"
      }
    }
    position {
      x = 0
      y = 11
      w = 24
      h = 6
    }
  }
}

resource "yandex_monitoring_dashboard" "backend_3" {
  name        = "backend-3-dashboard"
  title       = "Мониторинг Backend-3"
  description = "Метрики CPU, памяти и сети для Backend-3"

  # ===============================
  # CPU
  # ===============================
  widgets {
    chart {
      title          = "CPU Backend-3"
      chart_id       = "cpu_backend_3"
      display_legend = false
      queries {
        target {
          query = "cpu_usage{resource_id=\"${yandex_compute_instance.backend[2].id}\"}"
        }
      }
      visualization_settings {
        type        = "VISUALIZATION_TYPE_LINE"
        aggregation = "SERIES_AGGREGATION_AVG"
      }
    }
    position {
      x = 0
      y = 0
      w = 24
      h = 6
    }
  }

  # ===============================
  # Сетевые пакеты (Полученные / Отправленные)
  # ===============================
  widgets {
    chart {
      title          = "Полученные сетевые пакеты Backend-3"
      chart_id       = "net_recv_packets_backend_3"
      display_legend = false
      queries {
        target {
          query = "network_received_packets{resource_id=\"${yandex_compute_instance.backend[2].id}\"}"
        }
      }
      visualization_settings {
        type        = "VISUALIZATION_TYPE_LINE"
        aggregation = "SERIES_AGGREGATION_SUM"
      }
    }
    position {
      x = 0
      y = 6
      w = 12
      h = 5
    }
  }

  widgets {
    chart {
      title          = "Отправленные сетевые пакеты Backend-3"
      chart_id       = "net_sent_packets_backend_3"
      display_legend = false
      queries {
        target {
          query = "network_sent_packets{resource_id=\"${yandex_compute_instance.backend[2].id}\"}"
        }
      }
      visualization_settings {
        type        = "VISUALIZATION_TYPE_LINE"
        aggregation = "SERIES_AGGREGATION_SUM"
      }
    }
    position {
      x = 12
      y = 6
      w = 12
      h = 5
    }
  }

  # ===============================
  # Отправленные байты
  # ===============================
  widgets {
    chart {
      title          = "Отправленные байты Backend-3"
      chart_id       = "net_sent_bytes_backend_3"
      display_legend = false
      queries {
        target {
          query = "network_sent_bytes{resource_id=\"${yandex_compute_instance.backend[2].id}\"}"
        }
      }
      visualization_settings {
        type        = "VISUALIZATION_TYPE_LINE"
        aggregation = "SERIES_AGGREGATION_SUM"
      }
    }
    position {
      x = 0
      y = 11
      w = 24
      h = 6
    }
  }
}
