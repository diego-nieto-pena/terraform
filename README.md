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

## Variables

Variables are usually defined in the `variables.tf' configuration file:

**variables.tf**
```
variable "filename" {
    default = "/root/pets.txt"
}

variable "content" {
    default = "we love pets!"
}

variable "prefix" {
    default = "Mrs."
}
```
And used in the `main.tf` configuration file like this:

**main.tf**
```
resource "local_file" "pet" {
    filename = var.filename
    content = var.content
}
```

### Variables can be defined in multiple ways:

- Command line flags:
```
terraform apply -var "filename=/root/pets.txt" -var "content=we love pets!" - var "prefix=Mrs." ....
```

- Environment variables:
```
export TF_VAR_filename="/root/pets.txt"
export TF_VAR_content="We love pets!"
export TF_VAR_prefix="Mrs."
```

- Variable definition files (when there are too many variables):

files named like: terraform.tfvars / terraform.tfvars.json /*.auto.tfvars/*auto.tfvars.json, will be loaded automatically by terraform.
```
filename="/root/pets.txt"
content="We love pets!"
prefix="Mrs."
```

If any other file name format is used it should be passed as argument for the apply:
```
terraform apply -var-file variables.tfvars
```

### Variable definition precedence
1. **-var or -var-file** (commandline flags)
2. ***.auto.tfvars** (alphabetical order)
3. **terraform.tfvars**
4. Environment variables

There are multiple variable types:

- **string:** “/root/pets.txt”
- **number:** 1
- :**bool:** true/flase
- **any:** Default value
- **list:** [“cat”, “dog”]
- **map:**
    pet1 = cat
    pet2 = dog
- **object:** 
    variable "bella" {
        type = object({
            name = string
            color = string 
            food = list (string)
        })
       default = {
            name = "angelica"
            color = "black"
            food = ["banana", "mango", "kiwi"]
       }
   }
- **tuple:**
    variable kitty {
          type = tuple[string, number, bool]
          default = ["cat", 9, true]
    }

## Resource Attributes

Output from one resource could be used as parameters for creating other resources.
![resource dynamic attributes](./terraform/img/resources/img.png)

Some other resources doesn't need any attribute as the time_static resource type

```
resource "time_static" "time_update" {
}

resource "local_file" "time" {
    filename = "/root/time.txt"
    content = "Time stamp of this file is ${time_static.time_update.id}"
}
```
Executing terraform plan command looks like: 
```
Terraform will perform the following actions:

  # local_file.time will be created
   -/+ resource "local_file" "time" {
      ~ content              = "Time stamp of this file is {time_static.time_update.id}" -> "Time stamp of this file is 2023-02-06T19:06:04Z" # forces replacement
        directory_permission = "0777"
        file_permission      = "0777"
        filename             = "/root/time.txt"
      ~ id                   = "29c3ddf9d9e875a87d3f435d4848bb784a65ab2c" -> (known after apply)
    }

  # time_static.time_update will be created
  + resource "time_static" "time_update" {
      + day     = (known after apply)
      + hour    = (known after apply)
      + id      = (known after apply)
      + minute  = (known after apply)
      + month   = (known after apply)
      + rfc3339 = (known after apply)
      + second  = (known after apply)
      + unix    = (known after apply)
      + year    = (known after apply)
    }
```

### Resource dependencies

By specifying a dependency, terraform makes sure the resource will be created after it's dependency is created, multiple
dependencies can be defined as a list.

**Implicit dependency**: the resource A makes use of any of the arguments from resource B (depends_on not needed)  
```
resource "time_static" "time_update" {
}

resource "local_file" "time" {
    filename = "/root/time.txt"
    content = "Time stamp of this file is ${time_static.time_update.id}"
}
```
**Explicit dependency**: resource A references explicitly any of the properties from resource B

```
resource "time_static" "time_update" {
}

resource "local_file" "time" {
    filename = "/root/time.txt"
    content = "Time stamp of this file is ${time_static.time_update.id}"
    depends_on = [time_static.time_update]
}
```

another example explicit dependency

```
resource "local_file" "whale" {
    filename = "/root/whale"
    content = "whale"
    depends_on = [local_file.krill]
}

resource "local_file" "krill" {
    filename = "/root/krill"
    content = "krill"
}
```
terraform plan
```
# local_file.krill will be created
+ resource "local_file" "krill" {
    + content              = "krill"
    + directory_permission = "0777"
    + file_permission      = "0777"
    + filename             = "/root/krill"
    + id                   = (known after apply)
      }

# local_file.whale will be created
+ resource "local_file" "whale" {
    + content              = "whale"
    + directory_permission = "0777"
    + file_permission      = "0777"
    + filename             = "/root/whale"
    + id                   = (known after apply)
      }
```
