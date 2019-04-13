workflow "Build and push" {
  on = "push"
  resolves = [
    "Login to Docker Hub",
    "Push image to Docker Hub",
  ]
}

action "Build image" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "build -t bfg ."
}

action "Tag and push branch filter" {
  uses = "actions/bin/filter@4227a6636cb419f91a0d1afb1216ecfab99e433a"
  args = "branch master"
  needs = ["Build image"]
}

action "Login to Docker Hub" {
  uses = "actions/docker/login@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Tag image" {
  uses = "actions/docker/tag@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "bfg koenrh/bfg"
  needs = [
    "Login to Docker Hub",
    "Tag and push branch filter",
  ]
}

action "Push image to Docker Hub" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  needs = ["Tag image"]
  args = "push koenrh/bfg"
  secrets = ["DOCKER_PASSWORD", "DOCKER_USERNAME"]
}
