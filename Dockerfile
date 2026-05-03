FROM alpine:3.23

RUN apk add --no-cache tor && \
  mkdir -p /run/tor && \
  chown -R tor:tor /var/lib/tor /run/tor && \
  chmod 0700 /var/lib/tor /run/tor

COPY --link entrypoint.sh /usr/local/bin/entrypoint.sh

ENV TOR_SocksPort=0.0.0.0:9050 \
  TOR_DataDirectory=/var/lib/tor

USER tor

EXPOSE 9050/tcp

ENTRYPOINT ["entrypoint.sh"]
CMD ["tor", "-f", "/run/tor/torrc"]
