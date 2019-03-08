workflow "New workflow" {
  on = "push"
  resolves = ["npm-publish"]
}

action "npm-build" {
  uses = "actions/npm@59b64a598378f31e49cb76f27d6f3312b582f680"
  args = "build"
}

action "npm-test" {
  uses = "actions/npm@59b64a598378f31e49cb76f27d6f3312b582f680"
  needs = ["npm-build"]
  args = "test"
}

action "npm-publish" {
  uses = "actions/npm@59b64a598378f31e49cb76f27d6f3312b582f680"
  needs = ["npm-test"]
  args = "publish"
  secrets = ["NPM_AUTH_TOKEN"]
}
