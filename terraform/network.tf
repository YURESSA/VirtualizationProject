##########################
# VPC + Subnet
##########################
resource "yandex_vpc_network" "main" {
  name = "main-network"
}

resource "yandex_vpc_subnet" "main_subnet" {
  name       = "main-subnet"
  zone       = var.zone
  network_id = yandex_vpc_network.main.id
  v4_cidr_blocks = ["10.10.0.0/24"]
}

##########################
# Security Group для SSH и PostgreSQL
##########################
resource "yandex_vpc_security_group" "postgres_sg" {
  name       = "postgres-sg"
  network_id = yandex_vpc_network.main.id

  ingress {
    description = "Allow SSH"
    protocol    = "TCP"
    port        = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow PostgreSQL"
    protocol    = "TCP"
    port        = 5432
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    protocol    = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}