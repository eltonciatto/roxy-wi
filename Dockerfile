# Use uma base Debian/Ubuntu compatível
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    ROXY_WI_SECRET_PHRASE=_B8avTpFFL19M8P9VyTiX42NyeyUaneV26kyftB2E_4=

# 1. Instala dependências básicas
RUN apt-get update && \
    apt-get install -y \
      curl gnupg2 ca-certificates lsb-release sudo python3-pip python3-setuptools

# 2. Adicionar repositório oficial do Roxy-WI
RUN echo "deb [arch=amd64, trusted=yes] https://repo.roxy-wi.org/ubuntu \
      jammy stable" \
    > /etc/apt/sources.list.d/roxy-wi.list && \
    curl -fsSL https://repo.roxy-wi.org/roxy-wi-public.key | apt-key add -

# 3. Instalar o Roxy-WI e módulos
RUN apt-get update && \
    apt-get install -y \
      roxy-wi \
      roxy-wi-checker \
      roxy-wi-metrics \
      roxy-wi-smon \
      roxy-wi-portscanner \
      roxy-wi-keep-alive \
      roxy-wi-socket

# 4. Instalar pacotes Python adicionais
RUN pip3 install --break-system-packages \
      setuptools_rust \
      paramiko-ng

# 5. Volumes para dados e configurações
VOLUME ["/etc/roxy-wi", "/var/www/haproxy-wi", "/var/log/roxy-wi", "/var/lib/roxy-wi"]

# 6. Expor portas HTTP/HTTPS e painel
EXPOSE 80 443 2019

# 7. Comando padrão
CMD ["roxy-wi"]
