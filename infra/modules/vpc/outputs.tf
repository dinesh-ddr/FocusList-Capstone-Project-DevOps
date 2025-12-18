output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "sg_http_id" {
  value = aws_security_group.http.id
}

output "sg_ssh_id" {
  value = aws_security_group.ssh.id
}
