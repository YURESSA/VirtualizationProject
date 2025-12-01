##########################
# ВМ для фронта (1 копия)
##########################
resource "yandex_compute_instance" "frontend" {
  name        = "frontend"
  platform_id = "standard-v1"

  resources {
    cores  = 2
    memory = 2
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
        - DEBIAN_FRONTEND=noninteractive apt-get install -y docker.io git
        - systemctl enable --now docker

        # Клонируем репозиторий
        - git clone https://github.com/YURESSA/VirtualizationProject.git /app/virtualization

        # Создаём .env ТОЛЬКО после клонирования
        - echo "VITE_FRONTEND_URL=http://${one(yandex_lb_network_load_balancer.nlb.listener[*].external_address_spec[*].address)[0]}/" > /app/virtualization/frontend/.env
        - echo "BACKEND_URL=http://${one(yandex_lb_network_load_balancer.nlb.listener[*].external_address_spec[*].address)[0]}/" >> /app/virtualization/frontend/.env
        - chown ubuntu:ubuntu /app/virtualization/frontend/.env
        - chmod 600 /app/virtualization/frontend/.env

        # Сборка фронтенда
        - docker build -t frontend:latest -f /app/virtualization/frontend/Dockerfile /app/virtualization/frontend

        # Запуск
        - docker run -d --name frontend_container -p 80:80 -v /app/virtualization/backend/static:/app/static:ro --env-file /app/virtualization/frontend/.env frontend:latest
    EOF
  }
}

# IP frontend VM
output "frontend_ip" {
  value = yandex_compute_instance.frontend.network_interface[0].nat_ip_address
}


