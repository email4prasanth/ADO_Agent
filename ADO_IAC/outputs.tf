output "vm_public_ip" {
  value = azurerm_public_ip.public_ip_backend.ip_address
}

# output "private_key_pem" {
#   value     = tls_private_key.ssh_key.private_key_pem
#   sensitive = true
# }

# output "public_key_openssh" {
#   value = tls_private_key.ssh_key.public_key_openssh
# }