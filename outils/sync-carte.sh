#!/bin/sh
# Le moteur de carte existe à deux adresses :
#   /carte/        — l'adresse de travail, pour tous les restaurants (?r=slug)
#   /carte-demo/   — l'adresse historique, citée dans les messages et sur le site
# Les deux fichiers doivent rester identiques. Source de vérité : /carte/index.html
set -e
cd "$(dirname "$0")/.."
cp carte/index.html carte-demo/index.html
echo "carte-demo synchronisée depuis carte/"
