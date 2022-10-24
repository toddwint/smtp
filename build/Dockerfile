FROM toddwint/mybaseimage
COPY app /opt/smtp
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    DOMAINNAME=test.lab \
    HTTPPORT1=8080 \
    HTTPPORT2=8081 \
    HTTPPORT3=8082 \
    HTTPPORT4=8083 \
    HOSTNAME=mailsrvr \
    APPNAME=smtp
RUN apt-get update \
    && \
    apt-get install -y \
    postfix \
    mailutils \
    && \
    echo $HOSTNAME > /etc/hostname \
    && \
    apt-get autoremove -y \
    && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /opt/smtp/debug
CMD ["/opt/smtp/scripts/startup.sh"]
