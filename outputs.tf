output "dn" {
  value       = aci_rest.vnsSvcRedirectPol.id
  description = "Distinguished name of `vnsSvcRedirectPol` object."
}

output "name" {
  value       = aci_rest.vnsSvcRedirectPol.content.name
  description = "Redirect policy name."
}
