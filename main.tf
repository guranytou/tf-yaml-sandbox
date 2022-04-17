resource "aws_vpc" "example" {
  cidr_block = "192.168.0.0/24"
}

resource "aws_security_group" "example1" {
  name   = "example_sg_1"
  vpc_id = aws_vpc.example.id
}

resource "aws_security_group_rule" "ingress_example1" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = yamldecode(file("list1.yml"))
  security_group_id = aws_security_group.example1.id
}

resource "aws_security_group_rule" "egress_example1" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.example1.id
}

resource "aws_security_group" "example2" {
  name   = "example_sg_2"
  vpc_id = aws_vpc.example.id
}

resource "aws_security_group_rule" "ingress_example2" {
  for_each          = yamldecode(file("list2.yml"))
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = each.value
  description       = each.key
  security_group_id = aws_security_group.example2.id
}

resource "aws_security_group_rule" "egress_example2" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.example2.id
}
