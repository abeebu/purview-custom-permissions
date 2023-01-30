FROM mcr.microsoft.com/azure-cli

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