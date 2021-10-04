<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-redirect-policy/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-redirect-policy/actions/workflows/test.yml)

# Terraform ACI Redirect Policy Module

Manages ACI Redirect Policy

Location in GUI:
`Tenants` » `XXX` » `Policies` » `Protocol` » `L4-L7 Policy-Based Redirect`

## Examples

```hcl
module "aci_redirect_policy" {
  source  = "netascode/redirect-policy/aci"
  version = ">= 0.0.2"

  tenant                = "ABC"
  name                  = "REDIRECT1"
  alias                 = "REDIRECT1-ALIAS"
  description           = "My Description"
  anycast               = false
  type                  = "L3"
  hashing               = "sip"
  threshold             = true
  max_threshold         = 90
  min_threshold         = 10
  pod_aware             = true
  resilient_hashing     = true
  threshold_down_action = "deny"
  l3_destinations = [{
    description = "L3 description"
    ip          = "1.1.1.1"
    ip_2        = "1.1.1.2"
    mac         = "00:01:02:03:04:05"
    pod_id      = 2
  }]
}

```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 0.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 0.2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tenant"></a> [tenant](#input\_tenant) | Tenant name. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Redirect policy name. | `string` | n/a | yes |
| <a name="input_alias"></a> [alias](#input\_alias) | Alias. | `string` | `""` | no |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_anycast"></a> [anycast](#input\_anycast) | Anycast. | `bool` | `false` | no |
| <a name="input_type"></a> [type](#input\_type) | Redirect policy type. Choices: `L3`, `L2`, `L1`. | `string` | `"L3"` | no |
| <a name="input_hashing"></a> [hashing](#input\_hashing) | Hashing algorithm. Choices: `sip-dip-prototype`, `sip`, `dip`. | `string` | `"sip-dip-prototype"` | no |
| <a name="input_threshold"></a> [threshold](#input\_threshold) | Threshold. | `bool` | `false` | no |
| <a name="input_max_threshold"></a> [max\_threshold](#input\_max\_threshold) | Maximum threshold. Minimum value: 0. Maximum value: 100. | `number` | `0` | no |
| <a name="input_min_threshold"></a> [min\_threshold](#input\_min\_threshold) | Minimum threshold. Minimum value: 0. Maximum value: 100. | `number` | `0` | no |
| <a name="input_pod_aware"></a> [pod\_aware](#input\_pod\_aware) | Pod aware redirect. | `bool` | `false` | no |
| <a name="input_resilient_hashing"></a> [resilient\_hashing](#input\_resilient\_hashing) | Resilient hashing. | `bool` | `false` | no |
| <a name="input_threshold_down_action"></a> [threshold\_down\_action](#input\_threshold\_down\_action) | Threshold down action. Choices: `permit`, `deny`, `bypass`. | `string` | `"permit"` | no |
| <a name="input_l3_destinations"></a> [l3\_destinations](#input\_l3\_destinations) | List of L3 destinations. Allowed values `pod`: 1-255. | <pre>list(object({<br>    description = optional(string)<br>    ip          = string<br>    ip_2        = optional(string)<br>    mac         = string<br>    pod_id      = optional(number)<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `vnsSvcRedirectPol` object. |
| <a name="output_name"></a> [name](#output\_name) | Redirect policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest.vnsRedirectDest](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.vnsSvcRedirectPol](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
<!-- END_TF_DOCS -->