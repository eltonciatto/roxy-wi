# Dockerfile para deploy no Coolify com Ubuntu 24.04
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    ROXY_WI_SECRET_PHRASE=_B8avTpFFL19M8P9VyTiX42NyeyUaneV26kyftB2E_4=

# 1. Instala dependências básicas
RUN apt-get update && \
    apt-get install -y \
      curl \
      ca-certificates \
      lsb-release \
      sudo \
      python3-pip \
      python3-setuptools && \
    rm -rf /var/lib/apt/lists/*

# 2. Adiciona repositório oficial do Roxy-WI (trusted para ignorar assinatura)
RUN echo "deb [arch=amd64, trusted=yes] https://repo.roxy-wi.org/ubuntu \
      mantic stable" \
    > /etc/apt/sources.list.d/roxy-wi.list

# 3. Instala Roxy-WI e módulos principais
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

# 4. Instala pacotes Python adicionais
RUN pip3 install --break-system-packages \
      setuptools_rust \
      paramiko-ng

# 5. Define volumes para persistência de dados e configurações
VOLUME ["/etc/roxy-wi", "/var/www/haproxy-wi", "/var/log/roxy-wi", "/var/lib/roxy-wi"]

# 6. Exponha portas HTTP, HTTPS e painel de API
EXPOSE 80 443 2019

# 7. Comando padrão
CMD ["roxy-wi"]
