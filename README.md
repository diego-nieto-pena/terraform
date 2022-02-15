# Terraform

## [Docker](https://learn.hashicorp.com/tutorials/terraform/docker-variables?in=terraform/docker-get-started)

### Build infrastructure.

#### The main.tf file

##### Terraform block

The terraform{} block contains Terraform settings, including the required providers Terraform will use to provision your infrastructure.
- **source**: defines an optional hostname, namespace and the provider type. Terraform install providers from the [registry](https://registry.terraform.io/) by default. In this example the docker provider source is defined as **kreuzwerker/docker**.
- **version**: An optional attribute defined in the **required_providers** block. Is recommended to use thsi attribute to constrain the provider version so that Terraform doesn't install the latest version by default.

```
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
  }
}
```

#### Providers block

Configures the specified provider, in this case docker. A provider is a plugin that Terraform uses to create and manage resources. You can use multiple providers blocks in your configuration to manage resources from different rpoviders. You can even use different providers together. For example you could pass the Docker image ID to a Kubernetes service.
```
provider "docker" {}
```
#### Resources block
Defines components of your infrastructure, a resource might be a physical or virtual component such a Dokcer container, or it can be a logical resource such as a Heroku application.

Resource blocks have two strings before the block: te resource type and the resource name. In this example, resource type is docker-image and the name is nginx. The prefix of the type maps to the name of the provider. The resource type and name form a unique ID for the resource. e.g.: **docker_image.nginx**. Resource blocks contain arguments which you use to configure the resource; machine sizes, disk image names, or VPC IDs.

```
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
  name  = "tutorial"
  ports {
    internal = 80
    external = 8080
  }
}
```

### Initialize the directory
When you create a new configuration-or check out an existing configuration from version control-is necessary to initialize the directory with ```terraform init```.
Initializing a configuration directory downloads and installs the providers defined in the configuration, docker in this case.
### Create infraestructure.
```terraform apply```
Will apply the configuration from the **main.tf** file.
### Change infrastructure
Update the configuration file by changing the container external port.
```
resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
  name  = "tutorial"
  hostname = "learn-terraform-docker"
  ports {
    internal = 80
-   external = 8000
+   external = 8080
  }
}
```
Apply the changes ```terraform apply```

### Destroy infrastructure
The command ```terraform destroy``` terminates resources managed by the project.

### Input variables
Create new filled called **variables.tf** with a block defining a new container_name variable.
```
variable "container_name" {
  description = "Value of the name for the Docker container"
  type        = string
  default     = "ExampleNginxContainer"
}

```
In the **main.tf**, update the **docker_container** resource block to use the new variable. The **container_name** variable block will default to its value unless you declare a different one.

```
resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
- name  = "tutorial"
+ name  = var.container_name
  ports {
    internal = 80
    external = 8080
  }
}
```
Checking the docker running containers:
```
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                  NAMES
fa854c65348e   2e7e2ec411a6   "/docker-entrypoint.…"   40 seconds ago   Up 39 seconds   0.0.0.0:8080->80/tcp   ExampleNginxContainer
```

### Query data with outputs
Create a file called **output.tf**, add the following to define the outputs for the container's ID and the image ID:
```
output "container_id" {
  description = "ID of the Docker container"
  value       = docker_container.nginx.id
}

output "image_id" {
  description = "ID of the Docker image"
  value       = docker_image.nginx.id
}
```
Apply the configuration:
```
Changes to Outputs:
  + container_id = "fa854c65348ec911ac59460382d07485ce77a4589e5899da5f39f682e6a3e1e2"
  + image_id     = "sha256:2e7e2ec411a6fdeee34c78b4d41d9a7f6d4cd311f320f03bcec11a239f524341nginx:latest"

You can apply this plan to save these new output values to the Terraform state, without changing any real infrastructure.
```
Execute ```terraform output``` command:
```
terraform output
container_id = "fa854c65348ec911ac59460382d07485ce77a4589e5899da5f39f682e6a3e1e2"
image_id = "sha256:2e7e2ec411a6fdeee34c78b4d41d9a7f6d4cd311f320f03bcec11a239f524341nginx:latest"
```
Terraform outputs can be used to connect Terraform projects with other parts of the infrastructure or with other projects.
