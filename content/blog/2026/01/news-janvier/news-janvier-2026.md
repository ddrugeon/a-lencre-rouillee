---
title: Les news du mois de janvier 2026
draft: false
Date: 2026-01-31
author: David Drugeon-Hamon
description: Ingress NGINX tire sa révérence, la souveraineté numérique devient mainstream, et l'IA continue de transformer le métier de développeur. Ma sélection de janvier.
reading_time:
categories:
  - Veille Technologique
  - Newsletter
tags:
  - veille-mensuelle
  - kubernetes
  - securite
  - souverainete
  - ia
  - carriere
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
created: 2026/01/31
statut: publié
---

<img src="/blog/2026/01/news-janvier/banner.jpg" style="width: 100%; height: 400px; object-fit: cover; border-radius: 8px; margin-bottom: 2rem;">
<p style="font-size: 0.75rem; color: #666; margin-top: 0.5rem; margin-bottom: 2rem;">
Photo de <a href="https://unsplash.com/@chatelp" target="_blank" style="color: #999;">Pierre Châtel-Innocenti</a> sur <a href="https://unsplash.com/photos/pxoZSTdAzeU" target="_blank" style="color: #999;">Unsplash</a>
</p>
Le mois de janvier a été pour moi le commencement d'une nouvelle aventure professionnelle. Une phase de découverte et d'apprentissage sur différents sujets. C'est l'occasion de se remettre en question et prendre de nouveaux défis. Ceci n'est pas une raison pour ne pas continuer ma veille quotidienne. Je vous partage donc les articles de blogs, les news, les podcasts ou vidéos YouTube qui m'ont marqué ce mois-ci.

Cela fait plusieurs années que je travaille sur la souveraineté numérique que ce soit en ayant travaillé sur Gaia-X (souveraineté des données et leur utilisation) ou encore pour construire un nouvel acteur du cloud français. L'actualité récente nous force aussi à repenser notre dépendances aux services des géants de la tech. C'est un thème qui est de plus en plus présent dans les médias tech mais aussi dans les médias traditionnels. Je vous partage les articles que j'ai appréciés sur ce sujet.

Un autre thème qui a émergé de ma veille est la gestion de carrière de développeur avec les différentes possibilités proposées d'évolution (il est bien loin le temps où seule la voie managériale était la seule possibilité d'évoluer) mais aussi le questionnement de plus en plus présent sur la place de l'humain face à la machine pour le développement logiciel.

Enfin une dernière thématique autour de kubernetes, toujours et encore avec la fin de vie programmée pour mars de nginx ingress controller. Ce n'est pas comme si nous n'étions pas prévenu depuis deux ans...

Bonne lecture.
## Sommaire du mois

- **Cloud Native** : Ingress NGINX tire sa révérence, sécuriser un cluster K8s on-premise
- **Souveraineté** : L'Europe se réveille, la dette technique des standards
- **IA** : L'impact sur le métier de dev, MCP et sécurité, mémoire projet avec Claude Code
- **Carrière** : Staff Archetypes, polyvalence, leadership et problem solving
- **Coup de cœur** : Un système anti-sangliers avec VLM

## Cloud Native et Infrastructure

### Alerte : Ingress NGINX va mourir

Le monde de l'open source se base sur des passionnés qui sur leur temps libre créent ou contribuent. Faute de volontaires, de nombreux projets peuvent s'arrêter du jour au lendemain et là c'est le drame. C'est ce qui arrive pour le projet **NGINX ingress controller** qui est un des plus populaires ingress controller déployés. C'est donc officiel : **le projet sera retiré en mars 2026**. Qu'est ce que cela veut dire : Plus de bugfixes, plus de patches de sécurité. Néanmoins, les déploiements existants continueront de fonctionner, mais vous êtes **prévenus**.

> [!quote]
> *"Ingress NGINX has always struggled with insufficient or barely-sufficient maintainership"*

**Action recommandée** : commencer dès maintenant la migration vers [Gateway API](https://gateway-api.sigs.k8s.io/guides/) ou un autre Ingress controller supporté.

[Lire l'annonce officielle](https://www.kubernetes.dev/blog/2025/11/12/ingress-nginx-retirement/)

### Sécuriser un cluster Kubernetes on-premise

Jusqu'à présent, j'ai surtout travaillé sur des clusters kubernetes déployés sur un cloud provider public que ce soit en managé chez OVHCloud ou via Cluster API sur Outscale. Je n'avais jamais été confronté au déploiement sur du bare metal et on premise.

Pour comprendre les enjeux de ce type de déploiement, j'ai trouvé cet excellent article de Thibault Buze.
À travers cet article, Thibault nous rappelle cette évidence souvent oubliée :

> *"On-premise ne veut pas dire isolé"*

La politique du zéro trust s'applique aussi à vos clusters Kubernetes déployés on premise. Il présente les 5 couches de sécurité à mettre en place :

1. **Filtrage réseau strict** : NetworkPolicies avec Calico ou Cilium pour définir qui peut parler à qui
2. **Pods avec minimum de permissions** : security context, pas de root, suppression des capacités Linux inutiles
3. **Ne pas monter de jeton K8s si pas nécessaire** : `automountServiceAccountToken: false` — beaucoup de pods ont un jeton sans en avoir besoin
4. **Scanner les fichiers uploadés** : flux antivirus sur les PVC avec zone de quarantaine
5. **Audit continu** : Trivy, benchmark CIS Kubernetes, recommandations NSA/CISA

Je connaissais de nombreux facettes de la sécurisation de clusters kubernetes mais j'avais oublié que la majorité des applications peuvent appeler l'API Kubernetes à l'aide d'un jeton d'authentification sans en avoir besoin. C'est une surface d'attaque inutile qu'il faut absolument résoudre.

[Lire l'article complet](https://thibault-buze.medium.com/s%C3%A9curiser-nos-clusters-kubernetes-on-premise-8418e1940388)

### VictoriaLogs sur Kubernetes

Dans ma mission précédente, nous avions mis en place un serveur Loki pour stocker les logs applicatifs. Nous avons eu de nombreux problèmes de scalabilité et opérationnels pour garantir la disponibilité du service. J'avais entendu parler de VictoriaLogs qui est une alternative beaucoup plus simple à mettre en place. Cet article détaille les gotchas de VictoriaLogs en single-server sur K8s avec entre autres ces bons conseils:

- Allouez un **node dédié** avec stockage **NVMe**
- Attention à la cardinalité si vous utilisez Vector avec les métadonnées Kubernetes
- Déployez une instance **VMAlert dédiée** pour VictoriaLogs

Une piste nouvelle à explorer.

[Lire l'article](https://davidhernandez21.github.io/posts/Victorialogs-k8s-stack-gotchas/)

## Intelligence Artificielle

### L'IA transforme le métier de développeur

C'est vrai que depuis plus d'un an je m'intéresse à la révolution qu'apportent les LLM dans le monde du développement. J'ai bien aimé le point de vue d'Alexis Ducarouge (Glimmer) dans le podcast IFTTD. Il offre une analyse lucide de l'impact de l'IA sur notre métier.

En effet le marché a changé depuis la crise du covid 19. En 2022, c'était l'âge d'or du développement où pour une fois les développeurs étaient les rois du pétrole. Il n'était pas rare d'avoir plusieurs propositions d'emplois et avec des salaires mirobolants. Maintenant, la tendance s'est inversée.

> [!quote]
> > *"Je ne vibe code pas. Je suis un vieux schnock. Par contre, j'utilise la complétion intelligente augmentée."*

**Son conseil** : formez-vous à l'IA, même si ce n'est que pour utiliser des API et du prompting de qualité afin d'éviter d'être mis sur le carreau.

[Écouter le podcast](https://share.snipd.com/episode/8c8cef2a-4c7c-4eed-a4f1-ddb2908b600e)

### MCP et sécurité : la leçon d'Elastic

Dans le podcast Tranches de tech, Sylvain Valèze revient sur la création du serveur MCP que son équipe a codé pour Elastic. 

> [!quote]
> > *"Il y a des gens qui disaient 'il faudrait ouvrir toutes les API pour faire de la maintenance du cluster'. La fausse bonne idée."*

En effet, il explique pourquoi le serveur MCP pour Elasticsearch a été **volontairement limité en read-only**.
- Qui est responsable si l'agent met la prod par terre ?
- La personne qui a mal rédigé son prompt ? Le LLM ? Le serveur MCP ?

**Son conseil** : toujours activer la **validation humaine** pour les actions destructives.

[Écouter le podcast Tranches de Tech](https://share.snipd.com/episode/9812f1cf-b994-426b-8de5-a13c564f7a6f)

### Les chiffres qui donnent le vertige

J'aime bien écouter le podcast "IA pas que de la data" qui aborde un point de vue différent sur l'IA car vue de l'intérieur. Dans cet épisode, ils décortiquent l'économie de l'IA et nous apprenons ces chiffres vertigineux:

- **OpenAI** : 4.3 milliards de revenus, 2.5 milliards de cash burn
- **Nvidia** : 5 trillions de capitalisation (plus que le PIB France + Espagne)

Et en parallèle, la réalité en entreprise :

> [!quote]
> > *"La valeur des chatbots et des RAG est souvent difficilement prouvable. Ce n'est pas la baguette magique d'Harry Potter."*

Bref, l'IA que nous vend les géants de la tech est-elle une révolution ou au contraire une technologie qu'ils veulent imposer sans avoir derrière l'utilité ?

[Écouter le podcast](https://share.snipd.com/episode/fc72b161-d800-4865-87a1-ce501831e453)

### Créer un système de mémoire projet avec Claude Code

Qui n'a pas été confronté à l'amnésie de son agent de code entre deux sessions ? L'agent a oublié les bonnes pratiques que nous lui avons dites ou qu'il a déjà corrigé un bug similaire.

Dans cet article, Rick Hightower propose un guide pratique pour créer une skill Claude Code qui résout ce problème.

**Le concept** : maintenir 4 fichiers markdown dans votre projet pour capitaliser la connaissance :
- `bugs.md` : les bugs résolus avec Issue, Root Cause, Solution, Prevention
- `decisions.md` : les ADR (Architecture Decision Records)
- `key_facts.md` : la configuration et les faits importants
- `issues.md` : l'historique du travail

Et pour pérenniser le travail, il préconise ces conseils:
- Après chaque bug fix, demander à Claude : *"Log this in bugs.md"*
- Garder chaque entrée **scannable en 30 secondes**
- **Ne jamais stocker de secrets** dans ces fichiers (ils sont versionnés)
- Générer automatiquement une table des matières quand le fichier dépasse 20 entrées
- Revoir les décisions **trimestriellement** et marquer les obsolètes comme "Superseded by ADR-XXX"

> [!quote]
> > *"Knowledge capture pays back with compound interest."*

**Bonus** : les skills sont devenues universelles — elles fonctionnent avec d'autres assistants IA comme Gemini CLI ou OpenCode par exemple.

[Lire l'article](https://medium.com/@richardhightower/build-your-first-claude-code-skill-a-simple-project-memory-system-that-saves-hours-1d13f21aff9e)

## Programmation

### Souveraineté numérique : l'Europe se réveille

Le podcast MACI #152 avec François Fouquet (DataThings) aborde un sujet devenu brûlant : la dépendance technologique européenne.

> [!quote]
> > *"Il y a peut-être dix ans, on était pris pour des fous furieux. Il y a trois ans encore, on était traités gentiment de complotistes."*

Dans le podcast, ils rappellent que les États-Unis peuvent déjà imposer des restrictions envers des personnes :
- par exemple, les contributeurs iraniens coupés de GitHub (sanctions)
- ou encore les juges de la Cour Pénale Internationale sortis de **tous** les produits américains (compte Google, mais surtout du système bancaire)

La Commission Européenne se saisit du sujet et lance un **call for evidence sur l'open source**

Un très bon épisode qui rappelle les enjeux pour devenir indépendant vis-à-vis des Etats-Unis.

[Écouter le podcast](https://share.snipd.com/episode/ec53849d-3bba-4bed-99b8-c556ca04aa93)

### La dette technique des standards

Toujours dans le même épisode de podcast, une réflexion qui résonne avec ma devise KISS :

> [!quote]
> > *"Mon blog statique, il faut qu'il soit géo-répliqué ? Déployé sous Kubernetes ?"*

Est-il nécessaire de vouloir toujours de la haute disponibilité et de la résilience pour tous nos projets ?

Par exemple, Google a mis des **horloges atomiques** pour synchroniser Google Docs. Mais est-ce nécessaire pour vos déploiements ?

La faille React Server Components a cassé des milliers de sites qui **n'utilisaient même pas cette fonctionnalité** — embarquée par défaut dans Nuxt.

Un intervenant prends exemple de l'industrie du nucléaire :  une centrale doit avoir de la  redondance ET de la diversification pour son système de refroidissement. Il ne faut pas juste dupliquer le même système, mais changer  de technique pour éviter la surchauffe. En IT, on fait totalement l'inverse. Nous faisons des systèmes distribués et hautement disponibles en reproduisant des clusters homogènes mais qui peuvent tomber tous en même temps. Serait-il temps de s'inspirer d'autres systèmes d'ingénierie ?

### Leadership et Problem Solving

Un article de thelearning.tech à destinations des tech leads sur la résolution de problèmes :

> [!quote]
> > *"Top missing skill is complex problem solving"* — World Economic Forum

Notre cerveau a des biais cognitifs qui peuvent nous jouer des tours. Un exemple : "On a des bugs → il faut plus de testeurs" au lieu d'analyser les causes. Est-ce qu'une maison ayant des murs qui ne sont pas droits nécessite plus de maçons pour rectifier le tir ?

Cet article détaille **La méthode PDCA** pour résoudre des problèmes efficacement:
1. **Plan** : un problème = un écart mesurable, pas une opinion. Utiliser les "5 pourquoi" pour trouver les causes racines.
2. **Do** : tester des contre-mesures (pas des "solutions"), chacune avec un owner
3. **Check** : l'écart a-t-il disparu ?
4. **Act** : ancrer les apprentissages (daily, dojo, article interne)

Je vous laisse découvrir le reste de l'article qui est vraiment intéressant pour devenir un bon tech lead.

[Lire l'article](https://thelearning.tech/leadership-tech-transformer-les-problemes-en-apprentissages/)

### Carrière : ne vous limitez pas à une spécialité

Deux lectures complémentaires ce mois-ci :

**Staff Archetypes** (staffeng.com) définit les 4 archétypes des ingénieurs Staff+ : Tech Lead, Architect, Solver, Right Hand. Chacun a son scope et ses trade-offs.

> [!quote]
> > *"The joy of these roles is that you only work on essential problems. The tragedy is that you're always on to the next issue."*

**Ne pas se limiter à une spécialité** (mcorbin) plaide pour les profils en "n" ou "m" plutôt qu'en T :

> [!quote]
> > *"Une carrière, ça dure 43 ans. Ce serait dommage de se cantonner à une seule spécialité."*

Ces deux articles sont intéressants à tout point de vue pour gérer sa carrière.

[Staff Archetypes](https://staffeng.com/guides/staff-archetypes/) | [Article mcorbin](https://mcorbin.fr/posts/2026-01-18-carriere-dev-sre/)

## Découvertes insolites

### File Over App

Steph Ango, CEO d'Obsidian, rappelle une évidence :

> [!quote]
> > *"The files you create are more important than the tools you use to create them."*

En effet, nous pouvons (moi le premier) passer plus de temps à peaufiner les outils que nous utilisons qu'à produire. Il rappelle une évidence : Choisir un format de fichier simple et qui puisse être lu aussi bien sur un ordinateur des années 80 que sur un ordinateur de 2060 : Plain text, formats ouverts, pérennité.

[Lire l'article](https://stephango.com/file-over-app)

### La Track qu'il manque en conférence

mcorbin propose l'idée d'une **"Dette Technique Conf"** où l'on parlerait enfin de ce qui ne marche pas. En effet, pourquoi tout se passe-t-il toujours bien en conférence, sans jamais de retour d'expérience quand tout va mal ?

> [!quote]
> > *"Le coq est seul oiseau qui arrive à chanter les pieds dans la merde."*

Les vraies discussions se font lors des afters au bar, pas sur scène. Pourquoi ne pas formaliser ça ?

[Lire l'article](https://mcorbin.fr/posts/2025-01-12-conf-dette/)

## Ma veille en chiffres (janvier)

- **Articles lus** : 31
- **Podcasts écoutés** : 27
- **Thème dominant** : Sécurité Kubernetes et souveraineté numérique

## Mon coup de cœur du mois

### Sanglicam : la domotique anti-sangliers

Dans le podcast Tranches de Tech, Sylvain Valèze raconte sa lutte contre les sangliers qui ravagent son jardin toulousain.

Il a mis en place à l'aide de son système domotique un système de détection et d'alarmes pour effrayer les animaux indésirables.

**Le stack** :
- Capteurs de mouvement Zigbee
- Caméras infrarouges
- Klaxon et barres LED de police
- Modèle de vision **MoonDream** pour détecter les sangliers sur images dégueulasses

Le plus surprenant : un VLM arrive à identifier les sangliers sur des images infrarouges de nuit.

La tech au service du quotidien, même improbable.

[Écouter le podcast](https://share.snipd.com/episode/9812f1cf-b994-426b-8de5-a13c564f7a6f)

## Pour conclure

Une année qui démarre sur les chapeaux de roue avec toutes ses interrogations. 
La souveraineté numérique, en tant qu'européen, nous concerne tous aussi bien en tant que particulier que professionnel. Je me pose de plus en plus de questions sur comment basculer sur des services indépendants des services US que j'utilise au quotidien.

> [!info]
> Pour m'aider à diagnostiquer une base de code Ansible, j'ai développé une compétence pour Claude pour qu'il me produise des rapports d'audit sur des rôles Ansible. Cette compétence est disponible sur mon dépôt [Github](https://github.com/ddrugeon/devops-skills)

---

**À lire aussi :** mes précédents articles sur [le blog](/blog/)
