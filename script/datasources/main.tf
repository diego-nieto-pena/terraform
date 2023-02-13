terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "2.2.2"
    }
  }
}

resource "local_file" "lorem_ipsum_file" {
  filename = each.value
  content  = data.local_file.lorem_ipsum.content
  for_each = var.filename
}