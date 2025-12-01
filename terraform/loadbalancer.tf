##########################
# Балансировщик нагрузки
##########################
resource "yandex_lb_target_group" "backend" {
  name = "backend-group"

  dynamic "target" {
    for_each = yandex_compute_instance.backend
    content {
      subnet_id = yandex_vpc_subnet.main_subnet.id
      address   = target.value.network_interface[0].ip_address
    }
  }
}


resource "yandex_lb_network_load_balancer" "nlb" {
  name = "backend-nlb"

  listener {
    name        = "listener"
    port        = 80
    target_port = 5000

    external_address_spec {}
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.backend.id

    healthcheck {
      name = "http"
      http_options {
        port = 5000
        path = "/api/user/excursions"
      }
    }
  }
}


output "lb_ip" {
  value = one(yandex_lb_network_load_balancer.nlb.listener[*].external_address_spec[*].address)[0]
}