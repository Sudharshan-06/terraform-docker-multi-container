terraform {
	required_providers {
		docker = {
			source = "kreuzwerker/docker"
			version = "~> 3.0"
		}
	}
}

resource "docker_network" "devops_network" {
	name = "devops_network"
}

resource "docker_container" "mongodb" {
	name = "mongodb"
	image = "mongo:6"

	networks_advanced {
		name = docker_network.devops_network.name
	}
	ports {
		internal =27017
		external = 27017
	}
}

resource "docker_image" "backend_image" {
	name = "backend_image"
	
	build {
		context = "./backend"
	}
}

resource "docker_container" "backend" {
	name = "backend"
	image = docker_image.backend_image.name

	networks_advanced {
		name = docker_network.devops_network.name
	}
	depends_on = [
		docker_container.mongodb
	]
}


 
resource "docker_container" "nginx" {
	name = "nginx"
	image = "nginx:latest"
	
	networks_advanced {
	name = docker_network.devops_network.name
	}
	
	volumes {
		host_path  = "${path.cwd}/nginx/default.conf"
		container_path = "/etc/nginx/conf.d/default.conf"

	}


	ports {
		internal = 80
		external = 8080
	}
	
	depends_on = [
		docker_container.backend
	]
}

