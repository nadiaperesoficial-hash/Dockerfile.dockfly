FROM debian:stable-slim

# Instalação das dependências
RUN apt-get update && apt-get install -y \
    prosody \
    lua-sec \
    lua-socket \
    lua-expat \
    lua-filesystem \
    && rm -rf /var/lib/apt/lists/*

# Configuração de permissões e pastas
RUN mkdir -p /var/run/prosody /var/lib/prosody /var/log/prosody \
    && chown -R prosody:prosody \
       /var/run/prosody /var/lib/prosody \
       /var/log/prosody /etc/prosody

# Criação do arquivo de configuração (Corrigido para evitar "unknown instruction")
RUN echo 'admins = { "admin@prosody-server-23ae7ba5.dockfly.app" }' > /etc/prosody/prosody.cfg.lua && \
    echo 'modules_enabled = { "roster", "saslauth", "tls", "dialback", "disco", "posix", "private", "vcard", "http", "websocket", "carbons", "blocklist", "ping", "register" }' >> /etc/prosody/prosody.cfg.lua && \
    echo 'allow_registration = true' >> /etc/prosody/prosody.cfg.lua && \
    echo 'consider_websocket_secure = true' >> /etc/prosody/prosody.cfg.lua && \
    echo 'cross_domain_websocket = true' >> /etc/prosody/prosody.cfg.lua && \
    echo 'cross_domain_bosh = true' >> /etc/prosody/prosody.cfg.lua && \
    echo 'interfaces = { "0.0.0.0" }' >> /etc/prosody/prosody.cfg.lua && \
    echo 'http_ports = { 5280 }' >> /etc/prosody/prosody.cfg.lua && \
    echo 'http_interfaces = { "0.0.0.0" }' >> /etc/prosody/prosody.cfg.lua && \
    echo 'https_ports = {}' >> /etc/prosody/prosody.cfg.lua && \
    echo 'VirtualHost "prosody-server-23ae7ba5.dockfly.app"' >> /etc/prosody/prosody.cfg.lua && \
    echo '    http_paths = { websocket = "/xmpp-websocket" }' >> /etc/prosody/prosody.cfg.lua

# Finalização de permissões e execução
RUN chown prosody:prosody /etc/prosody/prosody.cfg.lua

USER prosody

EXPOSE 5280

CMD ["prosody", "-F"]

