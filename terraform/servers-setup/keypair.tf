resource "aws_key_pair" "deployer_one" {
  key_name   = "deployer-one"
  public_key = file("~/.ssh/deployer-one.pub")
}
