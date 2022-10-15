FROM toddwint/mybaseimage
COPY scripts /opt/smtp/scripts
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
    cd /opt \
    && \
    rm -rf /opt/mybaseimage \
    && \
    apt-get autoremove -y \
    && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /opt/smtp/scripts
CMD ["/opt/smtp/scripts/startup.sh"]
