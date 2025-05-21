# Tor For Docker

[![Docker Pulls](https://img.shields.io/docker/pulls/archhfan/tor-docker)](https://hub.docker.com/r/archhfan/tor-docker)
[![Docker Stars](https://img.shields.io/docker/stars/archhfan/tor-docker)](https://hub.docker.com/r/archhfan/tor-docker)

<div align="center">
  <img height="256" src="https://github.com/user-attachments/assets/c402eb46-c06e-4a98-a6be-7eba3d02581a">
</div>

You can configure your tor container with environment variables. Just write a `TOR_` prefix at your environment variables, and they will be translated into a `torrc` file at `/etc/tor/torrc` inside the container. For multiple settings with the same key, just prefix a number to the environment key like: `TOR_0_Foo`, `TOR_1_Foo`...

This container can work as a relay or a proxy, whatever you want to configure. Minimum requirements are to know how `torrc` file works (it's very easy, looking some examples below you will now hoy to use it)

Container works as proxy and relay by default. Override the configuration with environment variables and disable them.

## Docker Compose Example

A little example, using tor as relay and proxy at the same time.

```yaml
services:
  tor:
    image: archhfan/tor-docker:latest
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
| `TOR_0_ORPort`    | `ORPort`        | `9001`         | Enables IPv4 relay-to-relay (“onion routing”) on TCP port 9001. |
| `TOR_1_ORPort`    | `ORPort`        | `[::]:9001`    | Enables IPv6 relay-to-relay on TCP port 9001.                   |
| `TOR_DirPort`     | `DirPort`       | `9030`         | Serves directory information on TCP port 9030.                  |
| `TOR_DataDir`     | `DataDirectory` | `/var/lib/tor` | Places Tor’s state, keys, and caches under `/var/lib/tor`.      |

## Motivation

#### Spanish
---
Este repositorio viene gracias a que Javier Tebas, director de LaLiga, se dedica a cortar la conexión de CDNs famosas como Cloudflare, o de proveedores de servicio como Vercel o Netlify. Estos bloquean las CDNs los días que hay partidos de LaLiga, afectando a miles de usuarios de ciertas ISPs sobre las que tienen poder, haciendo que muchas páginas webs y servicios se queden inhabilitados para los usuarios finales.

No puede ser que en 2025, una empresa privada esté controlando el tráfico de un país solamente por un móvil económico, sin ningún tipo de motivo de peso. Por eso, decidí crear este repositorio y que cualquier persona tenga accesible la red tor de manera sencilla.

#### English
--- 
This repository exists because Javier Tebas, the president of LaLiga, has taken to cutting off connections to major CDNs like Cloudflare, as well as service providers such as Vercel and Netlify. These CDNs are blocked on match days, impacting thousands of users on certain ISPs under his influence, leaving many websites and services inaccessible to end users.

It’s unacceptable that in 2025, a private company can control the traffic of an entire country over something as trivial as a budget smartphone, without any valid justification. That’s why I created this repository—to give anyone easy access to the Tor network.

---

[#LaLigaGate](https://laligagate.com/)
