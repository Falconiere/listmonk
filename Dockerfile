FROM caddy:latest AS caddy

COPY Caddyfile ./

RUN caddy fmt --overwrite Caddyfile

FROM listmonk/listmonk:latest

RUN apk add --no-cache parallel openssl



COPY --from=caddy /srv/Caddyfile ./
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy

COPY --chmod=755 scripts/* ./
# Expose the application port
EXPOSE 9000

ENTRYPOINT ["/bin/sh"]

CMD ["start.sh"]
