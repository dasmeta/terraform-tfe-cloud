## This file and its content are generated based on config, pleas check README.md for more details

module "this" {
  source  = "dasmeta/account/aws"
  version = "1.2.2"

  alarm_actions = {"enabled":true,"slack_webhooks":[{"channel":"test-monitoring","hook_url":"${0-account/secret-reader.secrets.MONITORING_SLACK_HOOK_URL}","username":"reporter"}],"web_endpoints":["${0-account/secret-reader.secrets.MONITORING_OPSGENIE_HOOK_URL_HIGH}"]}
  alarm_actions_virginia = {"enabled":true,"slack_webhooks":[{"channel":"test-monitoring","hook_url":"${0-account/secret-reader.secrets.MONITORING_SLACK_HOOK_URL}","username":"reporter2"}],"web_endpoints":["${0-account/secret-reader.secrets.MONITORING_OPSGENIE_HOOK_URL_HIGH}"]}
  secrets = {"enabled":true,"values":{}}
  providers = {"aws":"aws","aws.virginia":"aws.virginia"}
}


data "tfe_outputs" "this" {
  for_each = { for workspace in ["0-account/root/secret-reader"] : workspace => workspace }

  organization = "dasmeta-testing"
  workspace    = replace(each.value, "/[^a-zA-Z0-9_-]+/", "_")
}
