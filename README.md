# Repositório de Deploy - PIE

Deployment unificado via Docker Compose para a plataforma PIE. Este repositório atua como o centralizador do deploy, gerenciando o frontend e o backend como submódulos do Git. Detalhes profundos de código estão nos repositórios originais.

## Arquitetura

- **Nginx (Proxy Reverso)** (porta 80) — Único serviço exposto publicamente.
- **Frontend** (Next.js, interno).
- **Backend** (API Laravel, interno).
- **PostgreSQL** (Banco de dados, interno).
- **Autoheal** (Reinicia automaticamente contêineres com falhas).

Todos os serviços comunicam-se de forma privada por uma rede Docker (`app-network`).

## Como Executar

**Use apenas o `docker-compose.yml` da raiz deste repositório.** Não rode os composes dos submódulos individualmente.

### 1. Pré-requisitos
Inicialize os submódulos:
```bash
git submodule update --init --recursive
```
Crie um arquivo `.env` na raiz:
```env
DB_USERNAME=docker
DB_PASSWORD=docker
DB_DATABASE=postgres
```
*(Crie também um `.env` dentro da pasta `backend/`)*

### 2. Rodando
```bash
docker compose up --build -d
```

## Deploy no Coolify

1. Aponte o Coolify para este repositório e selecione o tipo **Docker Compose**.
2. **Clonagem Recursiva:** O Coolify precisa inicializar os submódulos. Adicione este comando na seção de "Pre-build / Pre-deployment" do Coolify: `git submodule update --init --recursive`.
3. **Automação de Deploy:** Para que o build inicie com commits em qualquer repositório, você deve pegar a URL de Webhook do projeto no Coolify e adicioná-la nas configurações de Webhooks do GitHub/GitLab tanto do repositório de Deploy, quanto dos de Frontend e Backend.
4. O Nginx gerenciará a porta 80 automaticamente no Coolify.

## Fluxo de Atualização (Submódulos)

Não é mais necessário criar PRs para adicionar Dockerfiles no Frontend ou Backend, pois agora as configurações de deploy estão centralizadas na pasta `docker/` deste repositório. O compose já injeta as variáveis corretamente (`NEXT_PUBLIC_API_URL=/api` para o Next.js conversar via Nginx).

**Atualização do Código em Produção:**
Quando houver atualizações nos projetos originais e você quiser colocar no ar, apenas atualize as referências dos submódulos aqui:

```bash
# Baixa o código mais recente do Frontend/Backend
git submodule update --remote

# Atualiza as referências neste repositório de Deploy
git add frontend backend
git commit -m "Atualiza referências do frontend e backend"
git push
```
