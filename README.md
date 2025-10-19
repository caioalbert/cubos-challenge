# Desafio Técnico - Cubos DevOps

Este projeto implementa uma arquitetura segura com Docker e Terraform, incluindo redes internas e externas, proxy reverso e persistência de dados.

## Arquitetura

- **Frontend**: Aplicação HTML servida via nginx
- **Backend**: API Node.js que se conecta ao banco de dados
- **Database**: PostgreSQL 15.8 com dados persistidos
- **Proxy**: Nginx como proxy reverso
- **Redes**: 
  - Externa: Frontend e Proxy (acessível ao usuário)
  - Interna: Backend e Database (isolados)

## Dependências

- Docker
- Docker Compose (opcional)
- Terraform

### Instalação das Dependências

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install docker.io terraform

# Adicionar usuário ao grupo docker
sudo usermod -aG docker $USER
newgrp docker

# Verificar instalação
docker --version
terraform --version
```

## Inicialização

### Método 1: Terraform (Recomendado)

```bash
# Navegar para o diretório terraform
cd terraform

# Inicializar terraform
terraform init

# Aplicar configuração
terraform apply -auto-approve
```

### Método 2: Docker Compose (Alternativo)

```bash
# Na raiz do projeto
docker-compose up -d
```

**Nota**: O Docker Compose utiliza `dockerize` para garantir que o backend aguarde o database estar completamente pronto antes de iniciar.

## Acesso

Após a inicialização, acesse:
- **Aplicação**: http://localhost:8080
- **API direta**: http://localhost:8080/api
- **Métricas**: http://localhost:8080/api → backend:3000/metrics
- **Prometheus**: http://localhost:9090
- **Grafana**: http://localhost:3001 (admin/admin)

## Verificação

Para verificar se tudo está funcionando corretamente:

```bash
# Executar script de verificação
./verify.sh
```

## Comandos Úteis

### Verificar status dos containers
```bash
docker ps
```

### Ver logs
```bash
docker logs backend
docker logs database
docker logs proxy
```

### Parar ambiente
```bash
cd terraform
terraform destroy -auto-approve
```

### Rebuild (se necessário)
```bash
cd terraform
terraform destroy -auto-approve
terraform apply -auto-approve
```

## Estrutura do Projeto

```
.
├── backend/
│   ├── Dockerfile
│   ├── index.js
│   └── package.json
├── frontend/
│   ├── Dockerfile
│   └── index.html
├── proxy/
│   ├── Dockerfile
│   └── nginx.conf
├── sql/
│   └── script.sql
├── terraform/
│   ├── main.tf
│   ├── provider.tf
│   └── variables.tf
├── docker-compose.yml
└── README.md
```

## Funcionalidades

- Containers Docker para todos os serviços
- Redes internas e externas isoladas
- Proxy reverso com nginx
- Persistência de dados PostgreSQL
- Variáveis de ambiente para configuração
- Restart automático dos containers
- Infraestrutura como código com Terraform
- Monitoramento com Prometheus
- Observabilidade com Grafana
- Métricas customizadas da aplicação

## Troubleshooting

### Container não inicia
```bash
docker logs <container_name>
```

### Problemas de rede
```bash
docker network ls
docker network inspect internal
docker network inspect external
```

### Reset completo
```bash
cd terraform
terraform destroy -auto-approve
docker system prune -f
terraform apply -auto-approve
```