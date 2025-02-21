FROM caddy:latest AS caddy

COPY Caddyfile ./

RUN caddy fmt --overwrite Caddyfile

FROM listmonk/listmonk:latest

RUN apk add --no-cache parallel openssl

ARG SERVICE_USER_POSTGRES;
ENV SERVICE_USER_POSTGRES=$SERVICE_USER_POSTGRES

COPY --from=caddy /srv/Caddyfile ./
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy

COPY --chmod=755 scripts/* ./

ENTRYPOINT ["/bin/sh"]

CMD ["start.sh"]
