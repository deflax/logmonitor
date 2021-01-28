FROM alpine:3

ENV S6_OVERLAY_VERSION 2.2.0.1
ENV S6_OVERLAY_MD5HASH a114568c94d06dc69fdb9d91ed3f7535

RUN apk add --no-cache wget ca-certificates && \
apk --no-cache --update upgrade && \
cd /tmp && \
wget https://github.com/just-containers/s6-overlay/releases/download/v$S6_OVERLAY_VERSION/s6-overlay-amd64.tar.gz && \
echo "$S6_OVERLAY_MD5HASH *s6-overlay-amd64.tar.gz" | md5sum -c - && \
tar xzf s6-overlay-amd64.tar.gz -C / && \
rm s6-overlay-amd64.tar.gz

RUN apk add --no-cache \
		libdbi-drivers \
		syslog-ng \
		syslog-ng-http \
		syslog-ng-json \
		syslog-ng-scl \
		syslog-ng-sql \
		syslog-ng-tags-parser

COPY /etc/ /etc/

EXPOSE 514/udp
EXPOSE 601/tcp
EXPOSE 6514/tcp

ENTRYPOINT ["/init"]