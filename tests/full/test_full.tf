terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "netascode/aci"
      version = ">=0.2.0"
    }
  }
}

resource "aci_rest" "fvTenant" {
  dn         = "uni/tn-TF"
  class_name = "fvTenant"
}

module "main" {
  source = "../.."

  tenant                = aci_rest.fvTenant.content.name
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

data "aci_rest" "vnsSvcRedirectPol" {
  dn = module.main.dn

  depends_on = [module.main]
}

resource "test_assertions" "vnsSvcRedirectPol" {
  component = "vnsSvcRedirectPol"

  equal "name" {
    description = "name"
    got         = data.aci_rest.vnsSvcRedirectPol.content.name
    want        = module.main.name
  }

  equal "nameAlias" {
    description = "nameAlias"
    got         = data.aci_rest.vnsSvcRedirectPol.content.nameAlias
    want        = "REDIRECT1-ALIAS"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest.vnsSvcRedirectPol.content.descr
    want        = "My Description"
  }

  equal "AnycastEnabled" {
    description = "AnycastEnabled"
    got         = data.aci_rest.vnsSvcRedirectPol.content.AnycastEnabled
    want        = "no"
  }

  equal "destType" {
    description = "destType"
    got         = data.aci_rest.vnsSvcRedirectPol.content.destType
    want        = "L3"
  }

  equal "hashingAlgorithm" {
    description = "hashingAlgorithm"
    got         = data.aci_rest.vnsSvcRedirectPol.content.hashingAlgorithm
    want        = "sip"
  }

  equal "thresholdEnable" {
    description = "thresholdEnable"
    got         = data.aci_rest.vnsSvcRedirectPol.content.thresholdEnable
    want        = "yes"
  }

  equal "maxThresholdPercent" {
    description = "maxThresholdPercent"
    got         = data.aci_rest.vnsSvcRedirectPol.content.maxThresholdPercent
    want        = "90"
  }

  equal "minThresholdPercent" {
    description = "minThresholdPercent"
    got         = data.aci_rest.vnsSvcRedirectPol.content.minThresholdPercent
    want        = "10"
  }

  equal "programLocalPodOnly" {
    description = "programLocalPodOnly"
    got         = data.aci_rest.vnsSvcRedirectPol.content.programLocalPodOnly
    want        = "yes"
  }

  equal "resilientHashEnabled" {
    description = "resilientHashEnabled"
    got         = data.aci_rest.vnsSvcRedirectPol.content.resilientHashEnabled
    want        = "yes"
  }

  equal "thresholdDownAction" {
    description = "thresholdDownAction"
    got         = data.aci_rest.vnsSvcRedirectPol.content.thresholdDownAction
    want        = "deny"
  }
}

data "aci_rest" "vnsRedirectDest" {
  dn = "${data.aci_rest.vnsSvcRedirectPol.id}/RedirectDest_ip-[1.1.1.1]"

  depends_on = [module.main]
}

resource "test_assertions" "vnsRedirectDest" {
  component = "vnsRedirectDest"

  equal "descr" {
    description = "descr"
    got         = data.aci_rest.vnsRedirectDest.content.descr
    want        = "L3 description"
  }

  equal "ip" {
    description = "ip"
    got         = data.aci_rest.vnsRedirectDest.content.ip
    want        = "1.1.1.1"
  }

  equal "ip2" {
    description = "ip2"
    got         = data.aci_rest.vnsRedirectDest.content.ip2
    want        = "1.1.1.2"
  }

  equal "mac" {
    description = "mac"
    got         = data.aci_rest.vnsRedirectDest.content.mac
    want        = "00:01:02:03:04:05"
  }

  equal "podId" {
    description = "podId"
    got         = data.aci_rest.vnsRedirectDest.content.podId
    want        = "2"
  }
}
