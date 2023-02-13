resource "local_file" "welcome" {
  filename = "./pets.txt"
  content = "Pets are welcome"
}
