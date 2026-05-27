{
  description = "Ambiente de Desenvolvimento PIE (Frontend + Backend)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Backend (PHP 8.4 + Composer)
            php84
            php84Packages.composer

            # Frontend (Node 20)
            nodejs_20

            # Utilitários de Container para rodar apenas o Postgres
            docker-compose
            podman-compose
          ];

          shellHook = ''
            echo "=========================================================="
            echo " Bem-vindo ao Ambiente de Desenvolvimento PIE (Flake)!"
            echo "=========================================================="
            echo "Ferramentas injetadas:"
            echo " - PHP 8.4 e Composer"
            echo " - Node.js 20"
            echo " - Docker Compose"
            echo ""
            echo "Para rodar APENAS o banco de dados via docker, volte à raiz e use:"
            echo " docker compose up -d postgres"
            echo ""
            echo "Para desenvolvimento local (abra abas separadas no terminal):"
            echo " [Frontend] cd frontend && npm install && npm run dev"
            echo " [Backend]  cd backend && composer install && php artisan serve"
            echo "=========================================================="
          '';
        };
      }
    );
}
