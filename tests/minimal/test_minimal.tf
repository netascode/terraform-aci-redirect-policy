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

  tenant = aci_rest.fvTenant.content.name
  name   = "REDIRECT1"
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
}
