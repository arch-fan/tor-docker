FROM alpine:3.18

RUN apk add --no-cache tor && \
  mkdir -p /etc/tor && \
  chown -R tor:tor /etc/tor


USER tor

COPY entrypoint.sh /entrypoint.sh

ENV TOR_SocksPort=0.0.0.0:9050 \
  TOR_RunAsDaemon=0 \
  TOR_ORPort=9001 \
  TOR_ORPort=[::]:9001 \
  TOR_DirPort=9030 \
  TOR_DataDir=/var/lib/tor

VOLUME ["/var/lib/tor"]
EXPOSE 9001/tcp 9030/tcp

ENTRYPOINT ["/entrypoint.sh"]
CMD ["tor", "-f", "/etc/tor/torrc"]

