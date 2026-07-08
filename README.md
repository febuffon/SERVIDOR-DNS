# FLEX-SERVIDOR-DNS

Servidor DNS recursivo e validador DNSSEC usando Unbound, pronto para produção com Docker.

## Estrutura

```
FLEX-SERVIDOR-DNS/
├── .env.example                # Variáveis de ambiente
├── README.md
└── SERVIDOR-UNBOUND/
    ├── docker-compose.yml      # Orquestração Docker
    ├── Dockerfile              # Imagem customizada do Unbound
    ├── Makefile                # Comandos úteis
    ├── unbound.conf            # Configuração principal
    ├── unbound.service         # Systemd (deploy bare-metal)
    ├── conf.d/                 # Configurações adicionais
    ├── local-data/             # Zonas locais e blocklists
    └── scripts/                # Utilitários
        ├── setup.sh
        └── update-root-hints.sh
```

## Quick Start

```bash
cd SERVIDOR-UNBOUND
cp ../.env.example .env
make prod
```

Verificar logs:

```bash
cd SERVIDOR-UNBOUND && make logs
```

## Deploy bare-metal (sem Docker)

```bash
sudo cp SERVIDOR-UNBOUND/unbound.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now unbound
```

## Monitoramento

Com Prometheus:
```bash
cd SERVIDOR-UNBOUND && make up
docker compose --profile monitoring up -d
```

## Comandos úteis

| Comando                  | Descrição                     |
|--------------------------|-------------------------------|
| `make -C SERVIDOR-UNBOUND stats`  | Estatísticas do servidor      |
| `make -C SERVIDOR-UNBOUND flush`  | Limpa cache                   |
| `make -C SERVIDOR-UNBOUND reload` | Recarrega configuração        |
| `make -C SERVIDOR-UNBOUND check`  | Valida configuração           |
| `make -C SERVIDOR-UNBOUND shell`  | Acessa o container            |
