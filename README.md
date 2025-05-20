# Tor For Docker

You can configure your tor container with environment variables. Just write a `TOR_` prefix at your environment variables, and they will be translated into a `torrc` file at `/etc/tor/torrc` inside the container.

This container can work as a relay or a proxy, whatever you want to configure. Minimum requirements are to know how `torrc` file works (it's very easy, looking some examples below you will now hoy to use it)

Container works as proxy and relay by default. Override the configuration with environment variables and disable them.

## Docker Compose Example

A little example, using tor as relay and proxy at the same time.

```yaml
services:
  tor:
    image: archfan/tor-docker:latest
    environment:
      TOR_Nickname: MyRelayNick
      TOR_ContactInfo: mail@example.com
    volumes:
      - tor-data:/var/lib/tor

volumes:
  tor-data:
```

## Default Configuration

Default values of the environment variables with their respective directive.

ENV Variable      | torrc Directive | Value          | Effect                                                          |
| ----------------- | --------------- | -------------- | --------------------------------------------------------------- |
| `TOR_SocksPort`   | `SocksPort`     | `0.0.0.0:9050` | Opens a SOCKS listener on all interfaces for client use.        |
| `TOR_RunAsDaemon` | `RunAsDaemon`   | `0`            | Keeps Tor in the foreground (necessary in Docker containers).   |
| `TOR_ORPort`      | `ORPort`        | `9001`         | Enables IPv4 relay-to-relay (“onion routing”) on TCP port 9001. |
| `TOR_ORPort`      | `ORPort`        | `[::]:9001`    | Enables IPv6 relay-to-relay on TCP port 9001.                   |
| `TOR_DirPort`     | `DirPort`       | `9030`         | Serves directory information on TCP port 9030.                  |
| `TOR_DataDir`     | `DataDirectory` | `/var/lib/tor` | Places Tor’s state, keys, and caches under `/var/lib/tor`.      |
