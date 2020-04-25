output "public_subnet_ids" {
  value = data.aws_subnet_ids.public.ids
}

output "private_subnet_ids" {
 # value = [for id in data.aws_subnet_ids.private.ids : id.value]
  value = data.aws_subnet_ids.public.ids
}

output "vpc_id" {
  value = data.aws_vpc.selected.id
}