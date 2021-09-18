module "aci_redirect_policy" {
  source  = "netascode/redirect-policy/aci"
  version = ">= 0.0.1"

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
    pod         = 2
  }]
}
