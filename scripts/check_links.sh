#!/usr/bin/env bash
# Verifie que les liens Markdown relatifs entre ADR pointent vers des fichiers existants.
# Usage : scripts/check_links.sh   (code de sortie 1 si un lien est casse)
set -u
status=0
for f in doc/adr/*.md; do
  dir=$(dirname "$f")
  while IFS= read -r target; do
    case "$target" in http*|\#*|mailto:*) continue ;; esac
    path="${target%%#*}"
    if [ ! -e "$dir/$path" ]; then
      echo "ERREUR: $f : lien casse -> $target"
      status=1
    fi
  done < <(grep -oE '\]\([^)]+\)' "$f" | sed -E 's/^\]\((.*)\)$/\1/')
done
[ "$status" -eq 0 ] && echo "OK : tous les liens entre ADR sont valides."
exit $status
