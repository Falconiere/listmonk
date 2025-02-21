FROM caddy:latest AS caddy

COPY Caddyfile ./

RUN caddy fmt --overwrite Caddyfile

ENV LISTMONK_app__address="127.0.0.0:9000"

FROM listmonk/listmonk:latest

RUN apk add --no-cache parallel openssl



COPY --from=caddy /srv/Caddyfile ./
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy

COPY --chmod=755 scripts/* ./

ENTRYPOINT ["/bin/sh"]

CMD ["start.sh"]
