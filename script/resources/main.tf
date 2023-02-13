resource "local_file" "pet" {
  filename        = var.filename
  content         = "My favorite pets was ${random_pet.my_pet.id}"
  file_permission = "0770"
  lifecycle {
    ignore_changes = [content]
  }
}

resource "random_pet" "my_pet" {
  prefix    = var.prefix
  separator = var.separator
  length    = var.length
}