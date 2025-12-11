##########################
# Auto Scale Backend Group
##########################
resource "yandex_compute_instance_group" "backend_group" {
  name               = "backend-group"
  service_account_id = var.sa_id
  folder_id          = var.folder_id

  instance_template {
    platform_id = "standard-v1"

    resources {
      cores  = 2
      memory = 4
    }

    boot_disk {
      initialize_params {
        image_id = "fd80bm0rh4rkepi5ksdi"
      }
    }

    network_interface {
      subnet_ids = [yandex_vpc_subnet.main_subnet.id]
      nat = true
    }

    metadata = {
      ssh-keys = "ubuntu:${file("${path.module}/id_rsa.pub")}"

      user-data = <<-EOF
        #cloud-config
        package_update: true
        package_upgrade: true

        runcmd:
          - rm -rf /app/virtualization || true
          - mkdir -p /app/virtualization
          - chown ubuntu:ubuntu /app/virtualization

          - apt-get update
          - DEBIAN_FRONTEND=noninteractive apt-get install -y docker.io git postgresql-client
          - systemctl enable --now docker

          # Ждём готовности Postgres по внутреннему IP
          - until pg_isready -h "${yandex_compute_instance.postgres.network_interface[0].ip_address}" -p 5432; do sleep 3; done

          - git clone https://github.com/YURESSA/VirtualizationProject.git /app/virtualization

          # Создаём .env построчно через echo (каждая строка отдельно)
          - rm -f /app/virtualization/.env
          - echo "POSTGRES_HOST=${yandex_compute_instance.postgres.network_interface[0].ip_address}" >> /app/virtualization/.env
          - echo "POSTGRES_DB=${var.postgres_db}" >> /app/virtualization/.env
          - echo "POSTGRES_USER=${var.postgres_user}" >> /app/virtualization/.env
          - echo "POSTGRES_PASSWORD=${var.postgres_password}" >> /app/virtualization/.env
          - echo "SECRET_KEY=${var.secret_key}" >> /app/virtualization/.env
          - echo "JWT_SECRET_KEY=${var.jwt_secret_key}" >> /app/virtualization/.env
          - echo "MAIL_PASSWORD=${var.mail_password}" >> /app/virtualization/.env
          - echo "MAIL_SERVER=${var.mail_server}" >> /app/virtualization/.env
          - echo "MAIL_PORT=${var.mail_port}" >> /app/virtualization/.env
          - echo "MAIL_USERNAME=${var.mail_username}" >> /app/virtualization/.env
          - echo "MAIL_DEFAULT_SENDER=${var.mail_default_sender}" >> /app/virtualization/.env
          - echo "FRONTEND_URL=" >> /app/virtualization/.env
          - echo "PRODUCTION=True" >> /app/virtualization/.env
          - echo "USE_POSTGRES=True" >> /app/virtualization/.env
          - echo "ACCOUNT_ID=${var.account_id}" >> /app/virtualization/.env
          - echo "YOOKASSA_SECRET_KEY=${var.yookassa_secret_key}" >> /app/virtualization/.env
          - echo "BUCKET_NAME=${var.bucket_name}" >> /app/virtualization/.env
          - echo "YC_ACCESS_KEY=${var.yc_access_key}" >> /app/virtualization/.env
          - echo "YC_SECRET_KEY=${var.yc_secret_key}" >> /app/virtualization/.env

          - chown ubuntu:ubuntu /app/virtualization/.env
          - chmod 600 /app/virtualization/.env

          - docker build -t backend:latest -f /app/virtualization/backend/Dockerfile /app/virtualization
          - docker run -d --name backend_container --env-file /app/virtualization/.env -p 5000:5000 backend:latest
      EOF
    }
  }

  # Стратегия развёртывания (обязательный блок)
  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  # Авто‑масштабирование: стартуем с 1 ВМ
  scale_policy {
    auto_scale {
      initial_size           = 1
      min_zone_size          = 1
      max_size               = 3
      cpu_utilization_target = 60
      measurement_duration   = 60
      warmup_duration        = 30
      stabilization_duration = 120
    }
  }

  # Одна зона (соответствует одной подсети выше)
  allocation_policy {
    zones = ["ru-central1-a"]
  }

  # Привязка к балансировщику
  load_balancer {
    target_group_name = "backend-target-group"
  }
}

##########################
# Network Load Balancer
##########################
resource "yandex_lb_network_load_balancer" "nlb" {
  name = "backend-nlb"

  listener {
    name        = "listener"
    port        = 80
    target_port = 5000

    external_address_spec {}
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.backend_group.load_balancer[0].target_group_id

    healthcheck {
      name = "http"
      http_options {
        port = 5000
        path = "/api/user/excursions"
      }
    }
  }
}

##########################
# Outputs
##########################
output "lb_ip" {
  value = one(yandex_lb_network_load_balancer.nlb.listener[*].external_address_spec[*].address)[0]
}
data "yandex_compute_instance_group" "backend_group_data" {
  instance_group_id = yandex_compute_instance_group.backend_group.id
}

output "backend_vm_ips" {
  value = [
    for inst in data.yandex_compute_instance_group.backend_group_data.instances :
    inst.network_interface[0].nat_ip_address
  ]
}
