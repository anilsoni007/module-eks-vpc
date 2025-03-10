output "vpc_id" {
  value = aws_vpc.sandbox-vpc.id
}

output "private_subnet_ids" {
  value = aws_subnet.priv_sub[*].id
}

output "pub_subnets_ids" {
  value = aws_subnet.pub_sub[*].id
}