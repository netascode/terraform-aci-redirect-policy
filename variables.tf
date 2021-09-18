variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "Redirect policy name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "alias" {
  description = "Alias."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.alias))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "Description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "anycast" {
  description = "Anycast."
  type        = bool
  default     = false
}

variable "type" {
  description = "Redirect policy type. Choices: `L3`, `L2`, `L1`."
  type        = string
  default     = "L3"

  validation {
    condition     = contains(["L3", "L2", "L1"], var.type)
    error_message = "Allowed values are `L3`, `L2` or `L1`."
  }
}

variable "hashing" {
  description = "Hashing algorithm. Choices: `sip-dip-prototype`, `sip`, `dip`."
  type        = string
  default     = "sip-dip-prototype"

  validation {
    condition     = contains(["sip-dip-prototype", "sip", "dip"], var.hashing)
    error_message = "Allowed values are `sip-dip-prototype`, `sip` or `dip`."
  }
}

variable "threshold" {
  description = "Threshold."
  type        = bool
  default     = false
}

variable "max_threshold" {
  description = "Maximum threshold. Minimum value: 0. Maximum value: 100."
  type        = number
  default     = 0

  validation {
    condition     = var.max_threshold >= 0 && var.max_threshold <= 100
    error_message = "Minimum value: 0. Maximum value: 100."
  }
}

variable "min_threshold" {
  description = "Minimum threshold. Minimum value: 0. Maximum value: 100."
  type        = number
  default     = 0

  validation {
    condition     = var.min_threshold >= 0 && var.min_threshold <= 100
    error_message = "Minimum value: 0. Maximum value: 100."
  }
}

variable "pod_aware" {
  description = "Pod aware redirect."
  type        = bool
  default     = false
}

variable "resilient_hashing" {
  description = "Resilient hashing."
  type        = bool
  default     = false
}

variable "threshold_down_action" {
  description = "Threshold down action. Choices: `permit`, `deny`, `bypass`."
  type        = string
  default     = "permit"

  validation {
    condition     = contains(["permit", "deny", "bypass"], var.threshold_down_action)
    error_message = "Allowed values are `permit`, `deny` or `bypass`."
  }
}

variable "l3_destinations" {
  description = "List of L3 destinations. Allowed values `pod`: 1-255."
  type = list(object({
    description = optional(string)
    ip          = string
    ip_2        = optional(string)
    mac         = string
    pod         = optional(number)
  }))
  default = []

  validation {
    condition = alltrue([
      for l3 in var.l3_destinations : l3.description == null || can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", l3.description))
    ])
    error_message = "`description`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue([
      for l3 in var.l3_destinations : l3.pod == null || (l3.pod >= 1 && l3.pod <= 255)
    ])
    error_message = "`pod`: Minimum value: 1. Maximum value: 255."
  }
}

