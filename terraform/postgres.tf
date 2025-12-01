##########################
# PostgreSQL (1 ВМ)
##########################
resource "yandex_compute_instance" "postgres" {
  name        = "postgres-db"
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd80bm0rh4rkepi5ksdi"
      size     = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.main_subnet.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.postgres_sg.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("${path.module}/id_rsa.pub")}"

    user-data = <<-EOF
      #cloud-config
      package_update: true
      package_upgrade: true

      runcmd:
        # Установка PostgreSQL и ufw
        - apt-get update
        - apt-get install -y postgresql postgresql-contrib ufw
        - systemctl enable postgresql
        - systemctl start postgresql

        # Настройка firewall (сначала SSH)
        - ufw allow 22/tcp
        - ufw allow 5432/tcp
        - ufw --force enable

        # Создание пользователя и базы данных
        - sudo -u postgres psql -c "CREATE USER ${var.postgres_user} WITH PASSWORD '${var.postgres_password}';" || echo "User exists"
        - sudo -u postgres psql -c "CREATE DATABASE ${var.postgres_db} OWNER ${var.postgres_user};" || echo "DB exists"
        - sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE ${var.postgres_db} TO ${var.postgres_user};"

        # Настройка PostgreSQL для внешних подключений
        - PG_CONF=$(sudo -u postgres psql -t -c "SHOW config_file;" | tr -d '[:space:]')
        - PG_HBA=$(sudo -u postgres psql -t -c "SHOW hba_file;" | tr -d '[:space:]')
        - sudo sed -i "s/^#\\?listen_addresses\\s*=.*/listen_addresses = '*'/" "$PG_CONF"
        - echo "host all all 0.0.0.0/0 md5" | sudo tee -a "$PG_HBA"
        - systemctl restart postgresql
    EOF
  }
}

# output для Postgres
output "postgres_ip" {
  value = yandex_compute_instance.postgres.network_interface[0].nat_ip_address
}