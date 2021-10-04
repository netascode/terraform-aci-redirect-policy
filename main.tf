resource "aci_rest" "vnsSvcRedirectPol" {
  dn         = "uni/tn-${var.tenant}/svcCont/svcRedirectPol-${var.name}"
  class_name = "vnsSvcRedirectPol"
  content = {
    name                 = var.name
    nameAlias            = var.alias
    descr                = var.description
    AnycastEnabled       = var.anycast == true ? "yes" : "no"
    destType             = var.type
    hashingAlgorithm     = var.hashing
    thresholdEnable      = var.threshold == true ? "yes" : "no"
    maxThresholdPercent  = var.max_threshold
    minThresholdPercent  = var.min_threshold
    programLocalPodOnly  = var.pod_aware == true ? "yes" : "no"
    resilientHashEnabled = var.resilient_hashing == true ? "yes" : "no"
    thresholdDownAction  = var.threshold_down_action
  }
}

resource "aci_rest" "vnsRedirectDest" {
  for_each   = { for destination in var.l3_destinations : destination.ip => destination }
  dn         = "${aci_rest.vnsSvcRedirectPol.id}/RedirectDest_ip-[${each.value.ip}]"
  class_name = "vnsRedirectDest"
  content = {
    descr = each.value.description != null ? each.value.description : ""
    ip    = each.value.ip
    ip2   = each.value.ip_2 != null ? each.value.ip_2 : "0.0.0.0"
    mac   = each.value.mac
    podId = each.value.pod_id != null ? each.value.pod_id : "1"
  }
}
