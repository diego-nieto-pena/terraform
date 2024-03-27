module "uk_payroll" {
  source = "../payroll-app"
  app_region = "ue-west-2"
  ami = "ami-213568736avm"
}