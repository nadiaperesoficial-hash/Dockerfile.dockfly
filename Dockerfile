FROM debian:stable-slim

# Instalação das dependências
RUN apt-get update && apt-get install -y \
    prosody \
    lua-sec \
    lua-socket \
    lua-expat \
    lua-filesystem \
    && rm -rf /var/lib/apt/lists/*

# Criação das pastas e correção imediata de dono e permissões
RUN mkdir -p /var/run/prosody /var/lib/prosody /var/log/prosody /etc/prosody \
    && chown -R prosody:prosody /var/run/prosody /var/lib/prosody /var/log/prosody /etc/prosody

# Criação do arquivo de configuração (usando caminhos absolutos e forçando permissões)
RUN echo 'admins = { "admin@prosody-server-23ae7ba5.dockfly.app" }' > /etc/prosody/prosody.cfg.lua && \
    echo 'modules_enabled = { "roster", "saslauth", "tls", "dialback", "disco", "posix", "private", "vcard", "http", "websocket", "carbons", "blocklist", "ping", "register" }' >> /etc/prosody/prosody.cfg.lua && \
    echo 'allow_registration = true' >> /etc/prosody/prosody.cfg.lua && \
    echo 'interfaces = { "0.0.0.0" }' >> /etc/prosody/prosody.cfg.lua && \
    echo 'http_ports = { 5280 }' >> /etc/prosody/prosody.cfg.lua && \
    echo 'VirtualHost "prosody-server-23ae7ba5.dockfly.app"' >> /etc/prosody/prosody.cfg.lua && \
    echo '    http_paths = { websocket = "/xmpp-websocket" }' >> /etc/prosody/prosody.cfg.lua

# Garante que o usuário prosody pode ler o arquivo de configuração
RUN chmod 644 /etc/prosody/prosody.cfg.lua && \
    chown prosody:prosody /etc/prosody/prosody.cfg.lua

# Expor a porta
EXPOSE 5280

# Mudar para o usuário prosody apenas no final
USER prosody

CMD ["prosody", "-F"]
