---
title: "Warpgate - You shall not pass!"
date: 2025-11-04T23:08:00+01:00
draft: false
author: David Drugeon-Hamon
tags:
  - warpgate
  - rust
  - DevOps
  - kubernetes
  - open-source
categories:
  - Infrastructure
  - Sécurité
description: Découvrez Warpgate, le bastion open-source en Rust qui implémente le Zero Trust pour sécuriser votre infrastructure. Analyse approfondie, limitations et retour d'expérience.
keywords:
  - Warpgate
  - bastion
  - Zero Trust
  - Rust
  - SSH
  - sécurité
  - DevOps
  - infrastructure
ShowToc: true
TocOpen: false
ShowReadingTime: true
ShowShareButtons: true
ShowPostNavLinks: true
ShowBreadCrumbs: true
ShowCodeCopyButtons: false
ShowWordCount: true
comments: false
---

<img src="/blog/2025/11/warpgate/warpgate-portal.avif" style="width: 100%; height: 400px; object-fit: cover; border-radius: 8px; margin-bottom: 2rem;">
<p style="font-size: 0.75rem; color: #666; margin-top: 0.5rem; margin-bottom: 2rem;">
Photo prise pendant mes vacances dans le Périgord à Sarlat la Cadéna - août 2025
</p>


Il fut un temps où le VPN était le Saint Graal pour sécuriser l'accès à nos infrastructures et nos serveurs. Tout semblait parfait : connexion chiffrée, authentification forte requise...  Malheureusement, une fois entré dans la forteresse, toute personne pouvait faire ce que bon lui semblait dans le royaume sans contrôle ni traçabilité.

Avec l'avènement du Bring Your Own Device et du télétravail, il était nécessaire de changer de paradigme : ne plus faire confiance à personne, vérifier les actions faites. C'est la philosophie du "**Zero Trust**" : chaque accès doit être authentifié, autorisé et audité. Mais comment implémenter cette solution au quotidien sans complexifier la vie de nos collaborateurs ?

Le plus simple à mettre en œuvre est d'ajouter un point unique dans notre infrastructure qui servira de gardien du pont tel un Gandalf devant le Balrog. C'est ce que nous appelons un bastion (également appelé jump host). Ce gardien filtre les accès à notre infrastructure en fonction des droits accordés à l'utilisateur authentifié.

Plusieurs solutions existent sur le marché pour implémenter cette philosophie comme **Boundary d'Hashicorp**, **Teleport** mais une solution plus simple, écrite en Rust, existe. Voilà que rentre en scène notre mage : **Warpgate**.

## Warpgate, un bastion pas comme les autres

Warpgate est un projet open source, sous licence Apache 2.0, développé par l'organisation Warp-tech. Il est écrit entièrement en Rust ce qui garantit de bonnes performances et une sécurité accrue. C'est un bastion qui supporte nativement ces protocoles: **SSH, HTTP/HTTPS, MySQL et PostgreSQL**.

![Warpgate Architecture](/blog/2025/11/warpgate/warpgate-architecture.avif)
*Architecture simplifiée de Warpgate : un point d'entrée unique pour tous vos protocoles*

Sa force ? Contrairement aux solutions concurrentes, il n'est pas nécessaire d'installer un agent sur les machines cibles. Warpgate propose un binaire unique qui s'installe en quelques minutes sur un serveur. A noter qu'il peut aussi être exécuté sous forme d'un conteneur Docker. Vos utilisateurs vous remercieront car ils pourront utiliser leurs logiciels habituels pour se connecter aux machines.

{{< callout type="info">}}
Cette solution est facilement déployable sur un cluster Kubernetes. Un collègue a proposé d'ailleurs une charte Helm qui est maintenant disponible sur le repo GitHub du projet.
{{< /callout >}}

Comme toute solution de Zero Trust, Warpgate enregistre toutes les actions réalisées par les utilisateurs sur les serveurs cibles. Chaque requête, chaque action est tracée : l'audit post-incident devient un jeu d'enfant : vous pouvez rejouer les actions faites sur le serveur.

Warpgate propose un système de gestions de rôles, de droits sur une cible et d'utilisateurs pour segmenter les droits. Et il s'intègre à votre SSO existant à l'aide du protocole OpenID Connect. Que demander de plus ?

Tel Gandalf sur le pont de Khazad-dûm, Warpgate devient le protecteur de votre royaume : **"You shall not pass!"**


## Warpgate : quelles sont ses limites ?


Warpgate semble être la solution parfaite pour garder votre infrastructure mais il faut en connaître ses limitations avant d'avoir de mauvaises surprises en production. Voici les différentes contraintes que j'ai identifiées.

### Le défi de la haute disponibilité

Warpgate est une application **stateful** : Les sessions actives sont stockées en mémoire sur l'instance qui gère la connexion.

C'est le principal défi pour la scalabilité et la haute disponibilité :
- ❌ Si un **pod ou un serveur crash**, toutes les sessions actives sur cette instance sont perdues.
- ⚠️ Le load balancing entre les différentes instances nécessite la configuration d'un **sticky session** basé sur l'adresse IP du client (Client IP).
- ⚠️ **La répartition de charge n'est pas optimale**. Par défaut, Warpgate utilise une base de données locale basée sur SQLite pour stocker les données (Les machines cibles, les clés ssh etc...). Pour une meilleure scalabilité, il est nécessaire de s'appuyer sur un cluster de base de données externe. Warpgate supporte aussi bien MySQL que PostgreSQL.

**Verdict:** La haute disponibilité n'est pas acquise facilement. Il est nécessaire d'accepter de perdre sa connexion en cas de défaillance d'une instance.

### Tous les protocoles ne sont pas supportés

Warpgate se concentre sur les protocoles Unix et les bases de données.

Actuellement, des protocoles couramment utilisés ne sont pas supportés :
- ❌ **RDP** (Remote Desktop Protocol)
- ❌ **VNC** (Virtual Network Computing)
- ❌ **Redis** (bases de données clé-valeur)
- ❌ **Kubernetes** (accès aux API Serveurs)

{{< callout type="info">}}
Des issues sont déjà ouvertes à ce sujet.

Certains protocoles sont facilement implémentables comme celui de Redis car il suffit de reprendre ce qui a été implémenté pour PostgreSQL ou MySQL.

Par contre, la prise en charge de RDP est plus complexe et n'est pas la priorité de la communauté. L'issue est ouverte depuis 2023.

Concernant la connexion à un cluster Kubernetes, un collègue a fait une MR pour ajouter cette feature au projet. À ce jour, la MR est toujours ouverte et en attente de validation.
{{< /callout >}}


**Verdict :** Si vous avez besoin de supporter les différents protocoles de desktop à distance, Warpgate n'est pas fait pour vous. D'autres solutions Open Source comme **Apache Guacamole** ou **Apache Reverse Proxy** les prennent en charge.

### Une API REST disponible mais non documentée

Warpgate expose une API Rest pour faciliter la configuration des machines cibles, la gestion des utilisateurs ou encore des clés SSH autorisées.

**Le problème ?** Cette API n'est pas documentée officiellement. J'ai en effet dû faire du reverse engineering pour comprendre comment piloter la configuration des machines cibles depuis un controller Kubernetes custom.

**Ce que j'ai découvert:**
- **Endpoint** L'API est disponible à l'endpoint  `https://warpgate.votredomaine.com/@warpgate/admin/api`
- **Authentification:** Toutes les requêtes sont protégées par un token d'authentification. Il doit être créé via l'interface Web et doit être mis dans le header HTTP  `X-Warpgate-Token`

_Exemple pour récupérer la liste des cibles déjà enregistrées:_
```bash
curl https://warpgate.example.com/@warpgate/admin/api/targets -H 'X-Warpgate-Token: xxx' -H 'Accept: application/json'
```

Facile à deviner, non ?

{{< callout type="info">}}
Le seul moyen de créer cet API Token est de se connecter sur le portail d'administration, puis de cliquer sur son compte pour accéder aux tokens. Une issue est ouverte à ce sujet : https://github.com/warp-tech/warpgate/issues/1541
{{< /callout >}}

**Verdict :** C'est faisable, mais mal documenté. Heureusement que la communauté GitHub est présente pour vous aider.

### Une approche du support qui fait la différence

Warpgate propose un support professionnal qui permet de financer le projet.

L'offre Pro Support (750$/mois) inclut à ce jour:
- ✅ 2 heures de support email mensuel avec SLA de 24h
- ✅ Appel Zoom de présentation avec votre équipe ops
- ✅ Traitement prioritaire de vos issues GitHub
- ✅ Accès au développement de features custom (facturation séparée par projet)

Comparé à des projets concurrents comme **Téléport Entreprise (entre 150$ et 200 / utilisateur / an)** ou **Boundary Entreprise (Tarification à demander mais c'est équivalent à Téléport)**, c'est relativement bas.

**Verdict:** Le choix de l'équipe projet de Warpgate est de proposer une solution totalement open-source avec la Licence Apache v2.0. Il est totalement possible de déployer le projet dans votre infrastructure sans lock-in ou autre fonctionnalité cachée.

> *"This funding model allows Warpgate to stay what it was always meant to be: a secure, open and robust gatekeeper at the edge of your infrastructure."*
### Setup initial : interactif ou automatisé

La configuration de Warpgate se fait à l'aide de deux commandes à exécuter avant son démarrage.
- Une commande interactive:

```bash
warpgate setup
```

- Une commande permettant de générer la configuration de manière non interactive. C'est pratique pour setup le projet de manière automatisée :

```bash
warpgate unattended-setup --database-url url --data-path path --http-port port --ssh-port port --mysql-port port --postgres-port port --record-sessions --admin-password password --external-host host --data-path path
```

A l'aide de ces deux commandes, le fichier de configuration sera alors généré. C'est d'ailleurs le seul moyen d'initialiser le mot de passe de l'administrateur de Warpgate.

{{< callout type="info">}}
Dans la charte Helm du repo, un setup job permet de configurer ce fichier de conf à l'aide des valeurs soumises à l'installation de la charte.
{{< /callout >}}

**Verdict :** Les deux modes (interactif et automatisé) couvrent bien les besoins. Le mode `unattended-setup` est parfait pour une installation avec Docker ou Kubernetes. Seul bémol : impossible de changer le mot de passe admin sans régénérer la config.

## Et au final, qu'est ce que j'en pense ?

J'ai découvert Warpgate lors d'un daily quand une collègue nous a suggéré cette solution pour remplacer Teleport, suite à un problème de licence. En explorant le projet, j'ai été surpris par la richesse des fonctionnalités présentes dans la version communautaire.  Elles sont toutes présentes, sans marketing aggressif ou autres fioritures !

J'ai développé un contrôleur Kubernetes custom qui crée et supprime automatiquement les cibles Warpgate quand des machines sont provisionnées par Cluster API. Et Oui, j'ai dû faire du reverse engineering de l'API non documentée, pour découvrir comment Warpgate fonctionne. Le contrôleur est déjà déployé en production mais il reste encore quelques bugs à corriger.

**Les points forts qui m'ont convaincu :**
- ✅ **Simplicité** : Un binaire et une base de données : voilà c'est up & running
- ✅ **Transparence totale** : Les équipes utilisent leurs outils habituels (ssh, mysql, psql)
- ✅ **Audit sans effort** : Chaque session enregistrée, rejouable à volonté
- ✅ **Open source pur** : Pas de lock-in
- ✅  **Robustesse** : merci 🦀 Rust pour la stabilité et l'efficacité.

**Les compromis acceptés :**
- ⚠️ **Pas de clustering natif** : Obligation d'utiliser des sticky sessions.
- ⚠️ **API non documentée** : J'ai dû explorer le projet et comprendre comment il fonctionne.
- ⚠️ **Sessions perdues en cas de crash** : L'utilisateur doit se reconnecter à son serveur, c'est acceptable même si perturbant.

Prêt à tester ? Rendez-vous sur le "Getting started" du projet et faites vous une opinion en moins de 30 minutes

**Au final, le Balrog pourra traverser le pont de Khazad-dûm que si il a les bons droits évidemment.**


---

{{< callout emoji="🌐" type="info">}}
Références pour en savoir plus:
- 📦 [GitHub Warpgate](https://github.com/warp-tech/warpgate)
- 📚 [Documentation officielle](https://warpgate.null.page)
- ⚓ [Charte Helm officielle](https://github.com/warp-tech/warpgate/tree/main/helm/warpgate)
- 🎭 [Vidéo expliquant comment l'installer](https://youtu.be/xHgwbRnlxCY)
{{< /callout >}}

{{< callout emoji="📷" >}}
- Photo de couverture : Prise personnelle, Sarlat la Cadéna, Périgord (août 2025)
- Diagramme d'architecture : Créé avec Excalidraw
{{< /callout >}}
