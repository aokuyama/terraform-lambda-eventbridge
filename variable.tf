variable "region" {
  type    = string
  default = "ap-northeast-1"
}

variable "lambda" {
  type = map(object({
    function_name = string
    schedule      = string
    input         = any
    description   = string
  }))

  default = {
    lambda1 = {
      function_name = "function_name"
      schedule      = "cron(0 1 * * ? *)"
      input         = { key = "value" }
      description   = "Jobs description."
    }
  }
}
