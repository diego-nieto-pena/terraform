resource "local_file" "pet" {
  filename = var.filename
  content = "My favorite pets is ${random_pet.my_pet.id}"
  file_permission = "0700"
}

resource "random_pet" "my_pet" {
  prefix = var.prefix
  separator = var.separator
  length = var.length
}