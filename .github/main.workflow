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

action "GitHub Action for Docker" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "build"
}

workflow "docker publish" {
  on = "push"
  resolves = ["Docker Registry-1"]
}

action "Docker Registry-1" {
  uses = "./"
  args = "push son7211:0.1"
}
