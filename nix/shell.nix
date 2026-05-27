# Arquivo de compatibilidade para quem usa apenas 'nix-shell' ao invés de Flakes
let
  pkgs = import <nixpkgs> {};
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    # Dependências do Backend
    php84
    php84Packages.composer

    # Dependências do Frontend
    nodejs_20

    # Utilitários
    docker-compose
    podman-compose
  ];

  shellHook = ''
    echo "=========================================================="
    echo " Bem-vindo ao Ambiente de Desenvolvimento PIE (nix-shell)!"
    echo "=========================================================="
    echo "Ferramentas injetadas:"
    echo " - PHP 8.4 e Composer"
    echo " - Node.js 20"
    echo " - Docker Compose"
    echo ""
    echo "Para rodar APENAS o banco de dados via docker, use o comando na raiz:"
    echo " docker compose up -d postgres"
    echo ""
    echo "Dicas para desenvolvimento:"
    echo " [Frontend] cd frontend && npm install && npm run dev"
    echo " [Backend]  cd backend && composer install && php artisan serve"
    echo "=========================================================="
  '';
}
