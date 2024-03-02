# Pulling Alpine image
FROM alpine:3

# Updating packages and installing cron

RUN apk update && \
    apk add --no-cache tzdata bash gzip grep coreutils mariadb-client jq curl && \
    rm -rf /etc/cron.*/*

WORKDIR /blissey
COPY . .

ENTRYPOINT ["/blissey/default_files/entrypoint.sh"]
CMD ["crond", "-f", "-l", "1"]