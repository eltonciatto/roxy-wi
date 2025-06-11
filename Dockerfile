FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    ROXY_WI_SECRET_PHRASE=_B8avTpFFL19M8P9VyTiX42NyeyUaneV26kyftB2E_4=

# 1. Dependências básicas + captool + policy-rc.d stub
RUN apt-get update && \
    apt-get install -y \
      curl ca-certificates lsb-release sudo python3-pip python3-setuptools \
      libcap2-bin && \
    # impede scripts de serviço durante o build
    printf '#!/bin/sh\nexit 101\n' > /usr/sbin/policy-rc.d && chmod +x /usr/sbin/policy-rc.d && \
    # cria o logDir antes da instalação
    mkdir -p /var/log/roxy-wi && \
    rm -rf /var/lib/apt/lists/*

# 2. Repositório Roxy-WI para Ubuntu 24.04 (noble)
RUN echo "deb [arch=amd64 trusted=yes] https://repo.roxy-wi.org/ubuntu noble stable" \
    > /etc/apt/sources.list.d/roxy-wi.list

# 3. Instala Roxy-WI e módulos
RUN apt-get update && \
    apt-get install -y \
      roxy-wi \
      roxy-wi-checker \
      roxy-wi-metrics \
      roxy-wi-smon \
      roxy-wi-portscanner \
      roxy-wi-keep-alive \
      roxy-wi-socket && \
    rm -rf /var/lib/apt/lists/*

# 4. Pip extras
RUN pip3 install --break-system-packages \
      setuptools_rust \
      paramiko-ng

# 5. Volumes para persistência
VOLUME ["/etc/roxy-wi", "/var/www/haproxy-wi", "/var/log/roxy-wi", "/var/lib/roxy-wi"]

# 6. Portas
EXPOSE 80 443 2019

# 7. Entrypoint
CMD ["roxy-wi"]
