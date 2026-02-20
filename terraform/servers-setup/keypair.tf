resource "aws_key_pair" "deployer_one" {
  key_name   = "deployer-one"
  public_key = file(pathexpand("~/.ssh/deployer-one.pub"))
}
