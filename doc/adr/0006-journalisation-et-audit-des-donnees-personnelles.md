# 6. Journalisation et audit des accès aux données personnelles

## Statut
Accepte

## Contexte
Les services du système ([ADR 2](0002-style-d-architecture-microservices.md)) manipulent des
données personnelles d'usagers (identité, historique d'emprunt) stockées dans PostgreSQL
([ADR 1](0001-choix-de-la-base-de-donnees.md)). En cas d'incident ou de demande de la CNIL,
il faut pouvoir dire qui a consulté ou modifié quelle donnée, et quand. L'authentification
de l'API ([ADR 5](0005-authentification-et-rate-limiting-de-l-api-de-pret.md)) identifie les
clients, mais ne laisse aucune trace exploitable des accès eux-mêmes.

## Decision
**Décision retenue : Journaliser chaque accès aux données personnelles dans un journal d'audit centralisé et en ajout seul.**

Chaque service émet un événement d'audit (identifiant du client, action, ressource, date)
à chaque lecture ou modification d'une donnée personnelle. Les événements sont envoyés vers
un stockage centralisé en écriture seule, avec une durée de conservation limitée à 12 mois.
Aucune donnée personnelle n'est écrite en clair dans les journaux (identifiants seulement).

## Alternatives envisagees
- **Journaux applicatifs classiques par service** : rejetés car dispersés, modifiables et
  difficiles à corréler entre services.
- **Triggers d'audit dans PostgreSQL** : rejetés car ils ne voient pas l'identité du client
  de l'API et ne couvrent pas les services qui n'utilisent pas cette base.
- **Aucune journalisation** : rejetée car incompatible avec l'obligation de pouvoir
  justifier les accès (RGPD art. 5 et 32).

## Consequences
- **Positives** : traçabilité des accès, enquête facilitée après un incident, preuve de
  conformité lors d'un audit.
- **Negatives** : volume de logs à stocker et à purger, légère latence ajoutée à chaque
  accès, nouveau composant à exploiter et à protéger.
