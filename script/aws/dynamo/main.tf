resource "aws_dynamodb_table" "cars" {
  name = "cars"
  hash_key = "VIN"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "VIN"
    type = "S"
  }
}
resource "aws_dynamodb_table_item" "car-items" {
  table_name = aws_dynamodb_table.cars.name
  hash_key   = aws_dynamodb_table.cars.hash_key
  item       = <<EOF
    {
      "Manufacturer":{"S": "Audi"},
      "Make":{"S": "Q5"},
      "Year":{"N": "2021"},
      "VIN":{"S": "6662TYEBGFAYUA999"}
    }
  EOF
}
