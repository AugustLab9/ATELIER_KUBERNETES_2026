#!/usr/bin/env bash
# Préparation de l'environnement de l'atelier (exécuté une seule fois à la création du Codespace)
set -euo pipefail

echo "==> Installation de k3d"
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

echo "==> Autocomplétion et alias 'k' pour kubectl"
{
  echo 'source <(kubectl completion bash)'
  echo 'source <(k3d completion bash)'
  echo 'alias k=kubectl'
  echo 'complete -o default -F __start_kubectl k'
} >> ~/.bashrc

chmod +x scripts/*.sh 2>/dev/null || true

echo "==> Environnement prêt :"
k3d version
kubectl version --client
