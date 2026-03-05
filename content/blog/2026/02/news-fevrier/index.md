---
title: Les news du mois de février 2026
draft: false
Date: 2026-03-05
author: David Drugeon-Hamon
description: Etcd craque sous la pression, la souveraineté numérique se construit brique par brique, et les agents IA affûtent leurs outils CLI. Ma sélection de février.
reading_time:
categories:
  - Veille Technologique
  - Newsletter
tags:
  - veille-mensuelle
  - kubernetes
  - ia
  - souverainete
  - rust
keywords:
ShowToc: true
TocOpen: false
ShowReadingTime: true
ShowShareButtons: true
ShowPostNavLinks: true
ShowBreadCrumbs: true
ShowCodeCopyButtons: false
ShowWordCount: true
comments: true
image:
created: 2026/02/28
statut: publié
modified: 2026-03-05T15:33:38+01:00
---

<img src="/blog/2026/02/news-fevrier/banner.avif" style="width: 100%; height: 400px; object-fit: cover; border-radius: 8px; margin-bottom: 2rem;">
<p style="font-size: 0.75rem; color: #666; margin-top: 0.5rem; margin-bottom: 2rem;">
Photo du Mont Blanc prises sur les pistes de ski de fond de la station des saisies @zebeurton
</p>
De retour de vacances où je me suis ressourcé à la montagne, il est temps pour moi de passer en revue les différents articles, podcasts ou vidéos YouTube que j'ai pu glaner au mois de février.

Au programme : des problématiques de production et de mise à l'échelle côté Kubernetes et observabilité, les enjeux toujours d'actualité de la souveraineté numérique, et un chapitre dédié à l'IA générative qui fait encore couler beaucoup d'encre. 

Bonne lecture !

## Sommaire du mois

- **Cloud Native** : Les limites d'etcd à grande échelle, la gestion des secrets avec ESO + SOPS, une stack de logging légère avec Vector + VictoriaLogs
- **Intelligence Artificielle** : Les outils CLI pour agents IA, pourquoi Claude est une app Electron, la critique du hype IA, Claude Code à $1B ARR, bonnes pratiques CLAUDE.md, combo IA pour architectes
- **Souveraineté** : Construire une startup 100% européenne, un retour d'expérience concret
- **Programmation** : Parse, don't validate — le design par les types en Rust, gestion d'erreurs dans les grands systèmes, réécrire un OS DOS-compatible en Rust
- **Carrière** : Les archétypes Staff+
- **Outils** : Slides as code avec SliDesk
- **Découvertes** : Les maths dans votre cuisine, comment arrêter d'être ennuyeux
- **Podcasts** : Marché dev post-IA, fin de l'âge d'or des devs
- **Coup de coeur** : La première trilogie de l'assassin royal

## ☁️ Cloud Native et Infrastructure

### Why Etcd Breaks at Scale in Kubernetes

Quand j'ai lu et entendu que CleverCloud implémentait leur propre stack Etcd en se basant sur leur base de données distribuée, je ne comprenais pas le besoin. Après avoir eu des problèmes en production, avec Etcd, j'ai enfin compris que c'était le point faible de kubernetes et pourtant c'est LA brique essentielle à son fonctionnement.

En recherchant plus de détails sur le fonctionnement d'Etcd, je suis tombé sur cet article : quelles sont les limitations d'Etcd quand notre cluster monte en charge. 

Etcd est une base distribuée qui assure que les données seront persistées et cohérentes à chaque écriture. Le cluster se base sur le protocole de consensus [RAFT](https://en.wikipedia.org/wiki/Raft_(algorithm)) Le problème fondamental est que **chaque écriture** passe par le leader du cluster. Ainsi, en ajoutant des noeuds au cluster, la capacité d'écriture est de plus en plus réduite vu qu'il faut attendre que tous les noeuds acquittent l'écriture de la donnée en base. 

> [!info]
> La base de données est limitée à 8 GiB au maximum (avec une valeur de 2 GiB par défaut).

Dans cet article, Daniele Polencic y décrit les différents symptômes qu'un cluster etcd peut avoir :
- **Compaction lag** : si le taux de mutation est trop élevé, le compactage ne suit plus et la base grossit jusqu'à l'alarme de quota;
- **Slow watches** : trop de watchers saturent le CPU et la bande passante du leader;
- **Snapshot pressure** : quand un follower prend du retard, le leader doit lui envoyer un snapshot de plusieurs gigaoctets;

Heureusement, il existe des alternatives comme **Kine** (utilisé par K3s) qui implémente un sous-ensemble de l'API etcd pour traduire les requêtes vers une base de données relationnelle (PostgreSQL, SQLite ou MySQL).

Comme le dit l'article :

> [!quote]
> *"It's cheaper to rewrite etcd than to rewrite Kubernetes."*

Comme quoi, il suffit de creuser pour enfin comprendre pourquoi certains fournisseurs préfèrent réécrire cette brique essentielle au fonctionnement du cluster kubernetes.

[Lire l'article complet](https://learnkube.com/etcd-breaks-at-scale)

### La gestion des secrets dans Kubernetes

Romain Boulanger nous rappelle une réalité que beaucoup oublient : **Kubernetes ne chiffre pas ses secrets nativement**. Les Secrets Kubernetes sont simplement encodés en base64, ce qui est loin d'être sécurisé. En contexte GitOps, c'est un **vrai problème** puisque les secrets seront stockés sur les dépôts Git en clair.

L'article présente une solution robuste en combinant deux outils :

- **External Secrets Operator (ESO)** 
- **Secrets OPerationS (SOPS)**

External Secrets Operator est un opérateur Kubernetes qui interagit avec des coffres-forts distants (HashiCorp Vault, AWS Secrets Manager, Azure Key Vault, etc.) via des CRD spécifiques `ExternalSecret`. L'opérateur est alors capable de récupérer dynamiquement les secrets depuis le coffre-fort pour les injecter dans le cluster sous forme de Secrets Kubernetes classiques.

> [!quote]
> *"L'objet PushSecret est un argument redoutable, notamment pour pousser des secrets générés au sein du cluster."*

Pour ma part, je l'ai utilisé sur plusieurs de mes infrastructures en m'appuyant aussi bien sur un AWS SecretManager ou encore un OpenBAO. C'est LA solution portable pour gérer ses secrets dans Kubernetes.

> [!quote]
> *"External Secrets ne résout pas le souci de ce tout premier secret à injecter au sein du cluster lors de son initialisation."*

Mais il reste un problème existentiel : comment créer le **premier secret** permettant à external secret operator de se connecter au coffre-fort. 

C'est là qu'intervient **SOPS** (Secrets OPerationS), un projet open source de la fondation Mozilla, qui permet de chiffrer ce premier secret directement dans votre dépôt Git.

Romain nous propose donc une combinaison ESO + SOPS nécessaire pour tout cluster Kubernetes en production.

[Lire l'article complet](https://blog.filador.ch/posts/la-gestion-des-secrets-dans-kubernetes/)

### Vector + VictoriaLogs + Grafana : une stack de logging légère

Dans mon article de janvier, je parlais déjà de VictoriaLogs comme alternative sérieuse à Loki pour stocker ses logs dans sa stack d'observabilité.

Ce mois-ci, dc-tech.work détaille une stack complète de logging légère sur Kubernetes : **Vector + VictoriaLogs + Grafana**.

L'architecture est simple et élégante :
- **Vector** est un agent proposé par Datadog permettant de récupérer les données d'observabilité pour les envoyer vers différentes stacks. Sur ce projet, il tourne en DaemonSet (un pod par noeud) pour lire les logs de tous les containers via le filesystem. 
- **VictoriaLogs** stocke les logs de manière efficace
- **Grafana** avec le plugin `victoriametrics-logs-datasource` pour la visualisation

> [!note]
> Pour avoir plus d'informations sur Vector, n'hésitez pas à lire mon article de blog sur [le blog de WeScale](https://blog.wescale.fr/vector-une-solution-pour-lobservabilit%C3%A9)

Le tout est géré avec **ArgoCD** en GitOps. Une approche que j'apprécie particulièrement pour sa simplicité comparée aux stacks ELK ou Loki qui peuvent devenir des cauchemars opérationnels (et je peux le témoigner avec mon expérience précédente).

[Lire l'article complet](https://blog.dc-tech.work/articles/vector-victorialogs-stack/)

## 🤖 Intelligence Artificielle

### Les outils CLI qui ont transformé mes agents IA

Mathieu Grenier a fait un travail remarquable d'audit de ses agents IA. Son constat de départ : ses agents consommaient trop de tokens en faisant des appels `Read` sur des fichiers JSON et YAML entiers pour n'en extraire qu'une seule valeur. C'est totalement overkill surtout avec les limitations des fenêtres de contexte disponibles en fonction du modèle.

La métaphore est parfaite :

> [!quote]
> *"Un chirurgien expert avec un couteau de cuisine reste limité."*

Son approche : remplacer les outils génériques par des outils CLI spécialisés :
- **jq** pour extraire précisément du JSON (800 tokens pour lire un `package.json` avec Read vs 40 tokens avec `jq`)
- **yq** pour le YAML, TOML et XML
- **rg** (ripgrep) pour la recherche textuelle dans les codebases
- **fd** pour la recherche de fichiers
- **grepai** pour la recherche sémantique

Il a trouvé **48 combinaisons d'outils** qui réduisent la consommation de tokens de plus de 50%. Il expose sa règle d'or :

> [!quote]
> *"Toute synergie qui économise plus de 50% de tokens doit devenir un skill dans les 10 minutes suivant sa découverte."*

Un article indispensable pour quiconque utilise des agents IA au quotidien et veut en limiter la consommation de tokens.


[Lire l'article complet](https://mathieugrenier.fr/blog/coder-avec-claude-c-est-facile-et-rapide-1/les-outils-cli-qui-ont-transforme-mes-agents-ia-audit-adoption-et-synergies-27)

### Why Is Claude an Electron App?

Drew Breunig pose une question qui résonne avec tout développeur : pourquoi Anthropic, l'un des leaders des outils de coding IA, utilise Electron pour son application desktop ? Si leurs propres agents IA sont si puissants, pourquoi ne pas créer des apps natives pour chaque plateforme ?

La réponse est plus nuancée qu'il n'y paraît :

> [!quote]
> *"Coding agents are really good at the first 90% of dev."*

Il a fait un constat simple : même si les agents IA sont excellents pour générer du code, il reste encore 10% du code qui n'est pas forcément automatisable : les décisions produit complexes, le polish, le support multi-plateforme... 

Et maintenir trois codebases natives (macOS, Windows, Linux) est un cauchemar opérationnel, même avec des agents IA.

> [!quote]
> *"Agents make it easier, sure, but hard product decisions become challenged and require human decisions."*

C'est un rappel salutaire : même les meilleurs outils IA ne remplacent pas le jugement humain. Ils amplifient nos capacités, mais les décisions d'architecture et de design restent encore les nôtres.

[Lire l'article](https://www.dbreunig.com/2026/02/21/why-is-claude-an-electron-app.html)

### Welcome to the Dumbest Timeline Yet

Kevin Wammer de Overkill apporte un regard critique et rafraîchissant sur le hype IA. Il met en lumière les dérives de la communauté, notamment avec OpenClaw, un agent LLM qui s'installe sur votre machine locale.

Le constat est cinglant :

> [!quote]
> *"They're burning millions of tokens, often paying several hundreds of dollars, to train LLMs to replace them and then proudly tweeting about it."*

Il y a quelque chose de profondément absurde dans cette course à l'automatisation à tout prix. Quel est le retour sur investissement réel quand on brûle autant de ressources ?

Un article qui invite à réfléchir sur l'utilisation de l'IA : Est-elle la solution à tous nos problèmes ?

[Lire l'article](https://overkill.wtf/133-2/)

### Anthropic Acquires Bun (et Claude Code à $1B ARR)

Une news que je n'avais pas vu passer : Claude Code dépasse **$1 milliard d'ARR (Annual Recurring Revenue) en seulement 6 mois**, et Anthropic acquiert **Bun**, le runtime JavaScript ultra-rapide. L'acquisition est stratégique : Bun n'est pas un produit IA, c'est de l'outillage pour accélérer le développement d'agents en JavaScript.

> [!quote]
> *"Bun is not an AI product. It's tooling that will help them build AI products faster."*

Ce rapprochement entre l'écosystème Javascript et les agents IA est logique : Claude Code s'appuie de plus en plus sur des outils CLI, et Bun est l'un des runtimes les plus populaires pour ce type d'usage. Une acquisition qui en dit long sur la direction qu'Anthropic entend prendre pour ses agents.

[Lire l'article](https://simonwillison.net/2025/Dec/2/)

### How I Use Every Claude Code Feature + Writing a Good CLAUDE.md

Deux ressources complémentaires sur les meilleures pratiques Claude Code.

Le premier article passe en revue les fonctionnalités avancées : hooks, subagents, SDK. 

Le second détaille comment écrire un `CLAUDE.md` efficace, ce fichier d'instructions qui guide l'agent dans chaque projet.

Les principes clés pour un bon `CLAUDE.md` :

> [!quote]
> *"Keep it under 300 lines, use progressive disclosure, and don't run your linter inside the LLM."*

L'idée de **progressive disclosure** est particulièrement pertinente : charger uniquement les instructions nécessaires selon le contexte, plutôt que de tout mettre dans un seul fichier monolithique. Un CLAUDE.md trop long est contre-productif — l'agent se perd dans les instructions.

Ces deux lectures ont directement influencé ma configuration personnelle de Claude Code.

[Lire le premier article](https://simonwillison.net/2025/Nov/2/how-i-use-every-claude-code-feature) et le [second](https://www.humanlayer.dev/blog/writing-a-good-claude-md)
### AI Toolset for Software Architects (2025)

handsonarchitects.com propose un combo d'outils IA adapté aux architectes logiciels en 2025 : **Perplexity** pour la recherche rapide, **ChatGPT** pour les synthèses et la vulgarisation, **Claude Code** pour le travail technique en profondeur.

> [!quote]
> *"The right tool for the right job — don't use a hammer for every nail, even if the hammer is AI."*

Ce qui m'a frappé, c'est la distinction entre les usages : Perplexity pour l'exploration rapide (sans hallucinations grâce aux sources), ChatGPT pour la communication (reformuler pour différents publics), Claude pour le travail d'architecture détaillé. Chaque outil a sa place dans le flux de travail d'un architecte.

[Lire l'article](https://handsonarchitects.com/blog/2026/ai-toolset-for-software-architect-2026q1/)

### Quand le permacodeur s'essaie au vibe coding

Mon ancien collègue Stéphane Trébel alias **le permacodeur** a ouvert depuis plus d'un an une chaîne Twitch où il fait des revues de presse, des sessions de codage (surtout en rust) et des parties de jeux vidéos. Malheureusement, je ne peux pas assister à tous ces lives mais les replays sont disponibles sur sa chaîne [YouTube](https://www.youtube.com/@permacodeur).

Depuis plus d'un mois, Stéphane s'essaie au vibe coding. C'est toujours intéressant de voir ses réactions et ses interrogations. Bref, je recommande cette série de [vidéos](https://youtu.be/vo9WsJSgls0)

## 🇪🇺 Souveraineté numérique

### Made in EU : plus difficile que prévu

Robert, fondateur de startup, raconte son expérience pour construire un produit **100% sur une infrastructure européenne**. C'est possible, mais c'est nettement plus difficile que prévu.

> [!quote]
> *"The EU has real infrastructure companies building serious products."*

Voici la stack européenne qu'il a assemblée :
- **Bunny.net** : CDN, stockage distribué, DNS, optimisation d'images, WAF et protection DDoS. Ce n'est pas la première fois que j'en ai entendu parler, mais c'est une alternative sérieuse à Cloudflare.
- **Nebius** : inférence IA
- **Hanko** : authentification et identité
- **Gitea** : contrôle de version. Je préférerais **Forgejo** pour le remplacer
- **Plausible** : analytics respectueux de la vie privée, une alternative à Google Analytics
- **Infisical** : gestion des secrets
- **Bugsink** : suivi de bugs

Mais il reste des zones grises. La connexion via les réseaux sociaux passe forcément par Google, Facebook ou Apple. Et surtout :

> [!quote]
> *"There is no European alternative to the App Store or Play Store."*

L'effort en vaut la chandelle pour la souveraineté des données et les coûts souvent plus bas, mais il faut accepter de mettre les mains dans le cambouis.

[Lire l'article complet](https://www.coinerella.com/made-in-eu-it-was-harder-than-i-thought/)

## 💻 Programmation

### Parse, Don't Validate : le design par les types en Rust

Gio Genre De Asis applique le principe "Parse, don't validate" en Rust. L'idée est puissante : plutôt que de valider les données à l'exécution avec des `if` partout, on encode les règles directement dans le système de types.

> [!quote]
> *"Shotgun parsing is a programming antipattern whereby parsing and input-validating code is mixed with and spread across processing code."*

Concrètement, au lieu de passer un `f32` partout et vérifier qu'il n'est pas zéro à chaque utilisation, on crée un type `NonZeroF32` qui **garantit par construction** que la valeur n'est jamais nulle. Si le code compile, la contrainte est respectée.

L'approche se résume en trois principes :
1. **Centraliser le parsing** : convertir les entrées brutes en types du domaine une seule fois, à la frontière du système
2. **Modéliser les invariants avec les types** : utiliser des newtypes, enums et constructeurs intelligents pour rendre les états invalides non représentables
3. **Garder le traitement pur** : le code en aval travaille sur des types validés, sans vérifications répétées

Un article intéressant à tout point de vue pour alléger le code. Ces principes peuvent être repris pour d'autres langages typés.

[Lire l'article](https://www.harudagondi.space/blog/parse-dont-validate-and-type-driven-design-in-rust/)

### What Now? Handling Errors in Large Systems

Marc Brooker (AWS) déconstruit une idée reçue fondamentale : la gestion d'erreurs n'est pas une propriété locale d'une fonction, c'est une **propriété globale du système**. Ce que votre code fait quand il échoue impacte tout le reste.

> [!quote]
> *"Error handling is a system-level property, not a function-level property."*

Son concept de **blast-radius reduction** est particulièrement puissant : quand une erreur survient, combien de clients, de services, de données sont impactés ? La conception du système doit minimiser ce rayon d'explosion. 

Quelques principes concrets :
- Les erreurs doivent être **rapides et bruyantes** plutôt que silencieuses et lentes
- Les retry storms sont souvent pires que la panne initiale
- Circuit breakers et jitter exponentiel ne sont pas des optimisations, ils sont essentiels

Un article dense qui change la façon de penser l'architecture des systèmes distribués.

[Lire l'article](https://brooker.co.za/blog/2025/11/20/what-now)

### Writing a DOS Clone in 2019 (en Rust)

Andrew Imm raconte l'aventure de réécrire un OS DOS-compatible from scratch en **Rust**. Un projet de bas niveau, fascinant pour quiconque s'intéresse à ce qui se passe sous les abstractions modernes.

> [!quote]
> *"Writing an OS is the best way to understand why everything above it works the way it does."*

Ce qui rend cet article particulièrement intéressant : l'usage de `unsafe` en Rust pour les accès directs au matériel, la gestion manuelle de la mémoire, les interruptions. Rust n'est pas qu'un langage de systems programming moderne — c'est aussi un excellent choix pour les projets rétro et le low-level hacking.

Un projet qui prouve que la curiosité technique n'a pas de limites, et que Rust peut remplacer C même dans les contextes les plus bas niveau.

[Lire l'article](https://medium.com/@andrewimm/writing-a-dos-clone-in-2019-70eac97ec3e1)

## 💼 Carrière

### Staff Archetypes : les quatre visages de l'ingénieur Staff+

Will Larson (staffeng.com) décrit les **quatre archétypes** des ingénieurs Staff+ qui sont souvent confondus alors qu'ils répondent à des besoins très différents :

- **Tech Lead** : guide une équipe sur les décisions techniques, aligne la tech avec les objectifs produit
- **Architect** : responsable de la direction technique à travers plusieurs équipes ou systèmes
- **Solver** : plonge dans les problèmes les plus complexes, passe d'un problème à l'autre selon les besoins de l'organisation
- **Right Hand** : étend l'influence d'un dirigeant senior, agit comme délégué avec une large autorité

> [!quote]
> *"Most folks operate in a single archetype, but the most effective Staff engineers can shift between them as the organization needs."*

Ce qui m'a frappé : beaucoup d'ingénieurs pensent que "Staff+" signifie automatiquement "Tech Lead". En réalité, les quatre archétypes sont également légitimes, mais pas interchangeables. Comprendre lequel on est (ou on veut être) est essentiel pour progresser dans sa carrière.

[Lire l'article](https://staffeng.com/guides/staff-archetypes/)

## 🛠️ Outils

### Slides as Code avec SliDesk

Je cherchais une solution pour proposer mes slides en Markdown. Plusieurs solutions existent sur le marché comme Reveal.js, Marp etc... Dans ma quête pour un outil simple, je suis tombé sur **SliDesk**, un outil développé par Sylvain Gougouzian.

Dans son article, Stéphane Philippart présente cet outil. L'idée : vos slides vivent dans des fichiers Markdown, sont versionnés avec Git, et peuvent être stylisés et animés avec du CSS et JavaScript.

> [!quote]
> *"Quand vos slides sont du code, vous n'avez plus peur de les modifier, de les versionner, ou de les partager."*

SliDesk, contrairement à ses rivaux, apporte une organisation en chapitres et une syntaxe simple. Ce qui m'intéresse particulièrement : la liberté de structure. Pas de contrainte de template imposé par l'outil, juste des fichiers Markdown avec toute la puissance du CSS. Et en plus, il y a la possibilité d'ajouter et de développer des plugins facilement.

[Lire l'article](https://philippart-s.github.io/blog/2024-03-09-slidesk-discovery/)

## 🎲 Découvertes insolites

### Votre cuisine est pleine de maths

Dans cet article, le CNRS nous emmène dans un voyage surprenant : les mathématiques se cachent partout dans votre cuisine. Couper, ranger, organiser... ce sont des opérations centrales en mathématiques et en informatique.

> [!quote]
> *"Quasiment n'importe quelle activité de la cuisine peut faire penser à des mathématiques ou de l'informatique."*

Quelques exemples fascinants :
- Une recette est un **algorithme** avec des étapes ordonnées. Mais si on change l'ordre des étapes, est-ce que le résultat change ? C'est la notion d'**entropie** qui entre en jeu.
- Couper une pizza en parts égales ? C'est de la **trigonométrie** appliquée.
- Organiser un plan de table ? C'est un problème de **combinatoire**.

Un article parfait pour donner envie aux plus jeunes de s'intéresser aux sciences. D'ailleurs une exposition est en cours à Lyon permettant d'expérimenter différents concepts mathématiques en cuisine. Dommage que je ne puisse pas aller voir cette exposition avec mes enfants.

[Lire l'article](https://lejournal.cnrs.fr/articles/votre-cuisine-est-pleine-de-maths)

### How to Stop Being Boring

Joan Westenberg nous pousse à la réflexion : et si être ennuyeux venait simplement du fait qu'on cache qui on est vraiment ? Son conseil est radical mais efficace :

> [!quote]
> *"Make a list of everything you've stopped saying or admitting to because you worried it was embarrassing."*

C'est ce qu'elle appelle la "cringe list" — la liste de tout ce qu'on a arrêté de dire par peur du jugement des autres. L'opinion qu'on ne partage plus, la passion qu'on tait, l'avis impopulaire qu'on garde pour soi.

Un article qui s'applique autant dans la vie personnelle que professionnelle. Combien de développeurs cachent leurs passions "non-tech" par peur de ne pas être pris au sérieux ?

[Lire l'article](https://www.joanwestenberg.com/how-to-stop-being-boring/)

## 🎙️ Podcasts

### IA De l'Actu — Adoption réelle vs hype

Le podcast "IA pas que la Data" est un excellent podcast que j'écoute toujours avec plaisir. Dans son dernier épisode, ils ont de la lucidité sur l'actualité IA : OpenAI qui n'a toujours pas de modèle économique clair, Nvidia dans une potentielle bulle spéculative, et surtout la **réalité de l'adoption IA en entreprise** — bien loin des promesses marketing.

> [!quote]
> *"La vraie adoption de l'IA en entreprise, c'est beaucoup plus lent et beaucoup plus difficile que ce qu'on lit sur LinkedIn."*

L'épisode est particulièrement intéressant sur la distinction entre les early adopters qui font des POCs et les entreprises qui ont réellement mis l'IA en production à grande échelle. Le fossé est immense. Un podcast qui donne de la perspective dans un domaine où le bruit est assourdissant.

[Écouter le podcast](https://youtu.be/UYbzwEn9Ywc)

### \#320.exe — Fin de l'Âge d'Or des devs ?

IFTTD (If This Then Dev) aborde un sujet sensible : le marché des développeurs post-COVID + post-IA. L'écrémage entre les passionnés et les opportunistes qui avaient rejoint le secteur pour les salaires.

> [!quote]
> *"L'IA ne remplace pas les développeurs. Elle écrème. Ceux qui restent sont meilleurs, ou plus passionnés, ou les deux."*

L'épisode propose aussi une réflexion pragmatique sur **comment se former à l'IA** sans tomber dans les pièges : choisir les bons outils, éviter la formation théorique pure, privilégier la pratique. Ce qui m'a marqué : la distinction entre "savoir utiliser les LLMs" et "comprendre leurs limites pour mieux les cadrer".

Un épisode qui rassure et qui challenge en même temps.

[Écouter le podcast](https://www.ifttd.io/episodes/fin-de-l-age-d-or)

## 📊 Ma veille en chiffres (février)

- **Articles lus** : 17 articles
- **Podcasts écoutés** : 11 podcasts
- **Vidéos Youtubes:**  25 vidéos ou conférences
- **Thème dominant** : Cloud Native à grande échelle, souveraineté numérique et outils IA pour développeurs

## ❤️ Mon coup de coeur du mois

### La première trilogie de l'assassin royal

Cela faisait un moment que j'avais dans ma liste de lecture la première trilogie de l'assassin royal de Robin Hobb — et je dois être honnête : je n'ai pas accroché tout de suite.

L'univers déroute au départ. Les personnages portent des noms qui désignent leurs qualités (*Patience*, *Subtilité*, *Vaillance*...), la famille royale est tentaculaire, et il faut du temps pour démêler qui est qui. À cela s'ajoutent deux systèmes de magie — l'Art et le Vif — dont j'ai mis du temps à saisir les contours. Et en toile de fond, le royaume est menacé par des raiders pirates qui ravagent les côtes, laissant dans leur sillage des survivants étrangement vidés de toute humanité.

Ce qui m'a finalement accroché, c'est la fin du premier tome, quand Fitz se fait piéger dans sa mission. À partir de là, impossible de lâcher. Et surtout : j'ai adoré la relation entre Fitz et son loup Oeil-de-Nuit. Les voir grandir ensemble, développer ce lien animal et instinctif, c'est ce que Hobb fait de mieux.

Mon personnage préféré reste le Fou du roi : à la fois bouffon et confident, il flatte son roi en public mais sait tout ce qui se trame en coulisses. Un personnage à double fond, fascinant.

Le deuxième tome m'a semblé trop long. Mais le troisième rattrape tout avec ses enjeux politiques et ses luttes de pouvoir pour le trône. On pense à Game of Thrones, mais en plus posé et moins hollywoodien : pas de scènes de sexe ou de violence gratuite, l'histoire prend son temps — ce qui la rend d'ailleurs plus abordable pour ceux qui auraient peur de l'univers de Martin. La relation avec Molly est touchante et douloureuse à la fois : on se sent impuissant face à ce qui leur arrive.

> [!quote]
> Ce n'est pas le travail qui fait qu'on est fier ou pas ; c'est la façon de le faire

En tant que pratiquant d'escrime de spectacle, les univers médiévaux-fantastiques me parlent naturellement — et celui de Robin Hobb a de la profondeur. J'ai hâte de lire la suite des 19 tomes que compte cet univers — d'autant que j'ai fait découvrir la saga à mon ami Henri Gomez, qui lui a déjà dévoré les treize premiers. Autant dire qu'il va mettre les bouchées doubles pour le rattraper.

Plus d'infos sur [babelio](https://www.babelio.com/livres/Hobb-Lassassin-royal-Premiere-Epoque-Integrale-tom/919522)

## Pour conclure

Ce mois a été plutôt riche dans ma veille techno — entre les limites d'etcd en production, les outils CLI qui transforment les agents IA, et les réflexions sur la souveraineté numérique, il y a tant de sujets que c'est difficile de tout couvrir. J'espère néanmoins que cette sélection vous fera découvrir quelques pépites qui alimenteront votre propre réflexion.

Je remercie d'ailleurs Julien Wittouck d'avoir mentionné mon dernier article dans sa revue de presse du mois de février.

À dans un mois pour la prochaine édition de ma veille techno !

---

**À lire aussi :** mes précédents articles sur [le blog](/blog/)
