FROM alpine:3.23

RUN apk add --no-cache tor su-exec && \
  mkdir -p /var/lib/tor && \
  chown -R tor:nogroup /etc/tor /var/lib/tor

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV TOR_SocksPort=0.0.0.0:9050 \
  TOR_RunAsDaemon=0 \
  TOR_0_ORPort=9001 \
  TOR_1_ORPort=[::]:9001 \
  TOR_DirPort=9030 \
  TOR_DataDirectory=/var/lib/tor

ENTRYPOINT ["/entrypoint.sh"]
CMD ["tor", "-f", "/etc/tor/torrc"]
