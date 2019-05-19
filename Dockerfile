FROM docker:stable

LABEL "name"="Docker publish"
LABEL "maintainer"="GitHub Actions <support+actions@github.com>"
LABEL "version"="0.0.1"

LABEL "com.github.actions.icon"="publish"
LABEL "com.github.actions.color"="magenta"
LABEL "com.github.actions.name"="Docker Registry"
LABEL "com.github.actions.description"="This is an Action to publish to Docker Hub."
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
