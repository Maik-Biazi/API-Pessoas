output "vpc" {
  value = {
    id        = aws_vpc.vpc.id
    arn       = aws_vpc.vpc.arn
    cidr_block = aws_vpc.vpc.cidr_block
  }
}

output "subnets" {
  value = {
    private = {
      id          = aws_subnet.private.*.id
      cidr_blocks = aws_subnet.private.*.cidr_block
    }
    public = {
      id          = aws_subnet.public.*.id
      cidr_blocks = aws_subnet.public.*.cidr_block
    }
  }
}

output "route_tables" {
  value = {
    private = {
      id = aws_route_table.rtb_privada.*.id
    }
    public = {
      id = aws_route_table.rtb_publica.*.id
    }
  }
}
