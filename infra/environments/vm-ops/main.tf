terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = "gcp-gitops-microservices" 
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_compute_network" "ansible_vpc" {
  name                    = "ansible-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "ansible_subnet" {
  name          = "ansible-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.ansible_vpc.id
}

# Open ports for SSH (Ansible) and HTTP (Nginx)
resource "google_compute_firewall" "allow_ssh_http" {
  name    = "allow-ssh-http-ansible"
  network = google_compute_network.ansible_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ansible-target"]

}

# Provision the Ubuntu VM
resource "google_compute_instance" "ansible_vm" {
  name         = "ansible-target-vm"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  tags = ["ansible-target"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network    = google_compute_network.ansible_vpc.name
    subnetwork = google_compute_subnetwork.ansible_subnet.name
    access_config {
      # Requests an ephemeral public IP
    }
  }

  metadata = {
    # Dynamically read local public key and inject into the VM
    ssh-keys = "ansible_admin:${file("~/.ssh/gcp_ansible.pub")}"
  }

}

# Output the IP to connect via SSH
output "vm_public_ip" {
  value       = google_compute_instance.ansible_vm.network_interface.0.access_config.0.nat_ip
  description = "The public IP of the Ansible target VM"
}