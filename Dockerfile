

FROM mcr.microsoft.com/azure-cli

LABEL "com.github.actions.name"="purview-custom-permissions"
LABEL "com.github.actions.description"="Set permissions for purview"
LABEL "com.github.actions.icon"="table"
LABEL "com.github.actions.color"="blue"
LABEL "repository"="https://github.com/abeebu/purview-custom-permissions"
LABEL "homepage"="https://github.com/abeebu/purview-custom-permissions"

RUN	apk add --no-cache \
  bash \
  ca-certificates \
  curl \
  jq

COPY entrypoint.sh /entrypoint.sh
COPY functions-lib-to-set-purview-permissions.sh /functions-lib-to-set-purview-permissions.sh

RUN chmod +x /entrypoint.sh
RUN chmod +x /functions-lib-to-set-purview-permissions.sh

ENTRYPOINT ["/entrypoint.sh"]