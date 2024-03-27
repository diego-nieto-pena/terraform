module "us_payroll" {
  source = "../payroll-app"
  app_region = "us-east-1"
  ami = "ami-7625ahhadavm"
}