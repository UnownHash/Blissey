# Pulling Ubuntu image
FROM ubuntu:22.04

# Updating packages and installing cron
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y cron geographiclib-tools mariadb-client jq curl && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /etc/cron.*/* 

WORKDIR /blissey
COPY . .

ENTRYPOINT ["/blissey/default_files/entrypoint.sh"]
CMD ["cron", "-f", "-L", "3"]