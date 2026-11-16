# TP-ADR-Bellagnech-Achemlal

TD2 d'Architecture logicielle (ENSIBS, 5A ICE) : **ADR et vues ArchiMate**.
Cas d'étude : un système de gestion de bibliothèque (emprunts, réservations, notifications).

## Structure du dépôt

```
.
├── README.md                    ce fichier
├── rapport/
│   ├── rapport.md               réponses aux Parties 1 et 5 (source)
│   └── rapport.pdf              rapport final
├── doc/
│   ├── adr/                     les 5 ADR + template + README de contribution
│   │   ├── 0001-choix-de-la-base-de-donnees.md
│   │   ├── 0002-style-d-architecture-microservices.md
│   │   ├── 0003-concurrence-sur-les-reservations.md
│   │   ├── 0004-notifications-par-file-de-messages.md
│   │   ├── 0005-authentification-et-rate-limiting-de-l-api-de-pret.md   (décision de sécurité)
│   │   ├── adr-template.md
│   │   ├── INDEX.md             sommaire généré par scripts/gen_adr_index.py (bonus)
│   │   └── README.md            comment contribuer aux ADR
│   └── archimate/
│       ├── bibliotheque.archimate   modèle Archi (2 vues)
│       ├── vue1-motivation-composant.png
│       └── vue2-chaine-du-risque.png
├── scripts/
│   ├── check_adr.sh             validation du template (utilisé par le hook et la CI)
│   ├── install_hooks.sh         active le hook pre-commit
│   ├── gen_adr_index.py         bonus : génère doc/adr/INDEX.md
│   └── make_views.py            génère les images des deux vues ArchiMate
├── hooks/pre-commit             hook Git de validation des ADR
└── .github/workflows/adr-lint.yml   même validation en CI
```

## Démarrage rapide

```bash
./scripts/install_hooks.sh        # active le hook pre-commit (une fois après le clone)
./scripts/check_adr.sh            # valide tous les ADR
./scripts/check_links.sh          # verifie les liens entre ADR
python3 scripts/gen_adr_index.py  # régénère doc/adr/INDEX.md
```

Les vues ArchiMate s'ouvrent avec [Archi](https://www.archimatetool.com/) (version ≥ 4.9) :
`File > Open > doc/archimate/bibliotheque.archimate`.

## Les décisions

| # | Décision | Choix retenu |
|---|----------|--------------|
| 1 | Base de données | PostgreSQL + réplication |
| 2 | Style d'architecture | Microservices par domaine métier |
| 3 | Concurrence sur les réservations | Verrouillage optimiste |
| 4 | Notifications | File de messages asynchrone (RabbitMQ) |
| 5 | **Sécurité** : API de prêt | OAuth2 + rate limiting |
| 6 | Audit des données personnelles | Journal d'audit centralisé |

Les deux vues ArchiMate reprennent mot pour mot le vocabulaire des ADR 2 et 5
(traçabilité ADR ↔ modèle).

## Convention de nommage

Dépôt : `TP-ADR-Nom1-Nom2`. Fichiers ADR : `NNNN-titre-en-minuscules.md`, numérotation
incrémentale, jamais réutilisée.
