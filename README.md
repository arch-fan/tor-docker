# Tor For Docker

[#LaLigaGate](https://laligagate.com/)

[![Docker Pulls](https://img.shields.io/docker/pulls/archhfan/tor-docker)](https://hub.docker.com/r/archhfan/tor-docker)
[![Docker Stars](https://img.shields.io/docker/stars/archhfan/tor-docker)](https://hub.docker.com/r/archhfan/tor-docker)

<div align="center">
  <img height="256" src="https://github.com/user-attachments/assets/c402eb46-c06e-4a98-a6be-7eba3d02581a">
</div>

You can configure your tor container with environment variables. Just write a `TOR_` prefix at your environment variables and they will be translated into a `torrc` file at `/etc/tor/torrc` inside the container. For multiple settings with the same directive, prefix a number like `TOR_0_ORPort`, `TOR_1_ORPort` and so on (the entrypoint sorts the variables to keep ordering stable).

This container can work as a relay or a proxy, whatever you want to configure. Minimum requirements are to know how `torrc` works (it's very easy—looking at the examples below you will know how to use it).

Container works as proxy and relay by default. Override the configuration with environment variables to disable or change ports.

## Docker Compose Example

A little example, using tor as relay and proxy at the same time.

```yaml
services:
  tor:
    image: archhfan/tor-docker:latest
    environment:
      TOR_Nickname: MyRelayNick
      TOR_ContactInfo: mail@example.com
      TOR_ORPort: 9001
      # Not necessary, because service acts as a proxy by default
      # TOR_SocksPort: 0.0.0.0:9050
    volumes:
      - tor-data:/var/lib/tor
    ports:
      - "9001:9001"   # Relay ORPort
      - "127.0.0.1:9050:9050" # Local SOCKS proxy

volumes:
  tor-data:
```

## Default Configuration

Default values of the environment variables with their respective directive.

ENV Variable      | torrc Directive | Value          | Effect                                                          |
| ----------------- | --------------- | -------------- | --------------------------------------------------------------- |
| `TOR_SocksPort`   | `SocksPort`     | `0.0.0.0:9050` | Opens a SOCKS listener on all interfaces for client use.        |
| `TOR_DataDirectory` | `DataDirectory` | `/var/lib/tor` | Places Tor’s state, keys, and caches under `/var/lib/tor`.      |

### How the entrypoint works
- At startup the entrypoint rewrites `/etc/tor/torrc` using every environment variable prefixed with `TOR_`.
- Variables are sorted before writing; if you need a specific order for repeated directives, number them (`TOR_0_ORPort`, `TOR_1_ORPort`). For more than nine entries, zero‑pad numbers (`TOR_00_...`).
- Empty values are skipped to avoid generating invalid `torrc` lines.

## Motivation

### Spanish
Este repositorio viene gracias a que Javier Tebas, director de LaLiga, se dedica a cortar la conexión de CDNs famosas como Cloudflare, o de proveedores de servicio como Vercel o Netlify. Estos bloquean las CDNs los días que hay partidos de LaLiga, afectando a miles de usuarios de ciertas ISPs sobre las que tienen poder, haciendo que muchas páginas webs y servicios se queden inhabilitados para los usuarios finales.

No puede ser que en 2026, una empresa privada esté controlando el tráfico de un país solamente por un móvil económico, sin ningún tipo de motivo de peso. Por eso, decidí crear este repositorio y que cualquier persona tenga accesible la red tor de manera sencilla.

> [!NOTE]
> El Congreso de los Diputados tramitó la PNL 161/002757 para revisar los bloqueos de IP ordenados judicialmente y evitar que afecten a servicios legítimos o a terceros ajenos. La iniciativa cita expresamente los bloqueos vinculados a LaLiga, IPs compartidas como Cloudflare y casos como Transporta’m.  
> Fuente oficial: [BOCG, Serie D, núm. 443, PNL 161/002757](https://www.congreso.es/public_oficiales/L15/CONG/BOCG/D/BOCG-15-D-443.PDF).  
> Contexto sobre su aprobación: [Demócrata — El Congreso actuará contra los bloqueos masivos de IP por parte de LaLiga](https://www.democrata.es/politica/congreso-y-senado/congreso-bloqueo-ip-la-liga/).

### English
This repository exists because Javier Tebas, the president of LaLiga, has taken to cutting off connections to major CDNs like Cloudflare, as well as service providers such as Vercel and Netlify. These CDNs are blocked on match days, impacting thousands of users on certain ISPs under his influence, leaving many websites and services inaccessible to end users.

It’s unacceptable that in 2026, a private company can control the traffic of an entire country over something as trivial as a budget smartphone, without any valid justification. That’s why I created this repository—to give anyone easy access to the Tor network.

> [!NOTE]
> The Spanish Congress of Deputies processed PNL 161/002757 to review court-ordered IP blocking measures and prevent them from affecting legitimate services or unrelated third parties. The proposal explicitly mentions blocking measures linked to LaLiga, shared IPs such as Cloudflare’s, and cases such as Transporta’m.  
> Official source: [BOCG, Series D, no. 443, PNL 161/002757](https://www.congreso.es/public_oficiales/L15/CONG/BOCG/D/BOCG-15-D-443.PDF).  
> Context on its approval: [Demócrata — The Congress will act against LaLiga’s mass IP blocking](https://www.democrata.es/politica/congreso-y-senado/congreso-bloqueo-ip-la-liga/).
