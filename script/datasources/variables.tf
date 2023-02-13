variable "filename" {
  type = set(string)
  default = [
    "./files/dogs.txt",
    "./files/cats.txt",
    "./files/cows.txt"
  ]
}