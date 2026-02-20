resource "aws_eip" "nat" {
  count  = length(aws_subnet.public)
  domain = "vpc"
}

resource "aws_nat_gateway" "this" {
  count         = length(aws_subnet.public)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "eks-devops-nat-${count.index}"
  }

  depends_on = [aws_internet_gateway.this]
}
