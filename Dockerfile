# Based on https://github.com/AnalogJ/docker-cron

FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y \
        busybox-static \
        geographiclib-tools \
        mariadb-client \
        jq \
        curl \
    && mkdir -p /var/spool/cron/crontabs && \
    rm -rf /etc/cron.*/* && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /blissey

ENTRYPOINT ["sh", "-c", " \
    env >> /etc/environment && \
    ./settings.run && \
    cat ./crontab.txt >> /var/spool/cron/crontabs/root && \
    echo \"$@\" && \
    exec \"$@\" \
", "--"]

CMD ["busybox", "crond", "-f", "-l", "2"]
