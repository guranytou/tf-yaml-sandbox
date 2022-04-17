resource "aws_vpc" "example" {
  cidr_block = "192.168.0.0/24"
}

resource "aws_security_group" "example" {
  name   = "example_sg"
  vpc_id = aws_vpc.example.id
}

resource "aws_security_group_rule" "ingress_example" {
  for_each          = yamldecode(file("list.yml"))
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = each.value
  description       = each.key
  security_group_id = aws_security_group.example.id
}

resource "aws_security_group_rule" "egress_example" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.example.id
}
