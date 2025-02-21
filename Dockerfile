FROM caddy:latest AS caddy

COPY Caddyfile ./

RUN caddy fmt --overwrite Caddyfile

FROM listmonk/listmonk:latest

ARG SERVICE_FQDN_LISTMONK
ARG SERVICE_PASSWORD_POSTGRES
ARG SERVICE_USER_POSTGRES


RUN apk add --no-cache parallel openssl

COPY --from=caddy /srv/Caddyfile ./
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy

COPY --chmod=755 scripts/* ./

ENTRYPOINT ["/bin/sh"]

CMD ["start.sh"]
