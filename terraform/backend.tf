##########################
# ВМ для бэка (3 копии)
##########################
resource "yandex_compute_instance" "backend" {
  count       = 3
  name        = "backend-${count.index + 1}"
  platform_id = "standard-v1"

  depends_on = [yandex_compute_instance.postgres]

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params { image_id = "fd80bm0rh4rkepi5ksdi" }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.main_subnet.id
    nat       = true
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

# IP backend VM
output "backend_ips" {
  value = yandex_compute_instance.backend[*].network_interface[0].nat_ip_address
}

