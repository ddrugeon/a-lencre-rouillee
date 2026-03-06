---
title: Les news du mois de novembre 2025
draft: false
author: David Drugeon-Hamon
description: "Ma veille technologique de novembre 2025 : pannes cloud chez Azure et Cloudflare, nouveaux modèles IA Gemini 3 et Claude Opus 4.5, Spring Boot 4, et plus encore."
reading_time:
categories:
  - Veille Technologique
  - Newsletter
tags:
  - veille-mensuelle
keywords:
  - veille technologique
  - cloud computing
  - Azure
  - Cloudflare
  - intelligence artificielle
  - Claude
  - Gemini
  - Rust
  - Spring Boot
  - observabilité
  - VictoriaMetrics
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
modified: 2025-12-02
created: 2025-11-24
statut: publié
---

<img src="/blog/2025/11/news-novembre/banner.avif" style="width: 100%; height: 400px; object-fit: cover; border-radius: 8px; margin-bottom: 2rem;">
<p style="font-size: 0.75rem; color: #666; margin-top: 0.5rem; margin-bottom: 2rem;">
<a href="https://unsplash.com/fr/@ryancuerden" target="_blank" style="color: #999;">Ryan Cuerden</a> sur Unsplash
</p>
Les feuilles mortes se ramassent à la pelle... Le mois de novembre est déjà terminé, et j'ai glané différents articles et autres nouvelles qui m'ont marqués pendant ce mois.

## 📖 Sommaire du mois

- **Cloud Native et Infrastructure** : Pannes mondiales chez Azure et Cloudflare, observabilité avec VictoriaMetrics, et certification Clever Cloud
- **Intelligence Artificielle** : Outils IA pour architectes, génération de diagrammes AWS avec MCP, bonnes pratiques Claude Code, Anthropic en Europe, et nouveaux modèles Gemini 3 et Claude Opus 4.5
- **Programmation** : Retour d'expérience Rust dans le gamedev, clone DOS en Rust, GPU UI de Zed en open source, et Spring Boot 4
- **Découvertes insolites** : La piraterie et les armes du 17ème siècle
- **Mon coup de cœur** : Les conférences sur les échecs et retours d'expérience

## ☁️ Cloud Native et Infrastructure

Azure a aussi connu sa panne mondiale deux semaines après celle d'AWS fin octobre. La root cause a été identifiée et c'était une erreur de configuration de leur Azure Frontdoor (le CDN, il me semble mais je ne suis pas un spécialiste d'Azure). Dans cet [article](https://www.forbes.com/sites/sanjitsinghdang/2025/11/27/aws-and-azure-failures-raise-questions-about-cloud-reliability/), l'auteur s'interroge sur notre dépendance aux clouds publics qui au final se concentre sur trois voire quatre acteurs principaux.

En parlant de panne mondiale, Cloudflare a aussi connu une indisponibilité pendant plusieurs heures. Cloudflare est un fournisseur de CDN les plus utilisés dans le monde des applis web. Leur [post-mortem](https://blog.cloudflare.com/18-november-2025-outage/) est exemplaire et explique de manière didactique mais aussi en entrant dans la technique la cause de leur indisponibilité.

L'observabilité de nos applications est de nos jours primordiale. La solution la plus simple est de déployer la stack Prometheus/Loki/Mimir/Tempo/Grafana sur nos clusters kubernetes. Mais l'ayant vécu, la stack Loki / Mimir peut vite être une sinécure à opérer. Je regarde de plus en plus la stack VictoriaMetrics / VictoriaLogs qui semblent être plus facile et pérenne à opérer. Dans cet [article](https://davidhernandez21.github.io/posts/Victorialogs-k8s-stack-gotchas/?utm_source=bluesky&utm_medium=social&utm_content=victorialogs-single-server-k8s-setup-gotchas), David Hernandez donne un retour d'expérience sur le déploiement de VictoriaLogs. 

Clever Cloud lance sa première certification : [Cloud Concepts 101](https://www.programmez.com/actualites/clever-cloud-lance-sa-1ere-certification-cloud-concepts-101-38538). Avec cette première certification gratuite, vous pourrez comprendre la base du cloud computing et particulièrement celui de Clever Cloud. C'est une très bonne initiative et j'espère qu'il y en aura d'autres.

## 🤖 Intelligence Artificielle

Dans ma carrière, j'ai été architecte de solution pendant de nombreuses années. A cet époque, il n'y avait pas tous les outils boostés à l'IA comme il peut y avoir aujourd'hui. A l'époque, c'était des schémas et autres diagrammes faits avec draw.io (mais c'est encore le cas aujourd'hui). Dans cet [article](https://handsonarchitects.com/blog/2025/ai-toolset-for-software-architect-2025q3/), l'auteur explore les différents outils disponibles pour explorer, faire des recherches ou créer des POC pour valider des solutions.

D'ailleurs, pour vous aider à faire des diagrammes d'architectures d'infrastructure sur AWS, je vous recommande cet [article](https://aws.amazon.com/fr/blogs/machine-learning/build-aws-architecture-diagrams-using-amazon-q-cli-and-mcp/). Les auteurs expliquent comment ils ont exposé un serveur MCP pour générer des diagrammes à l'aide d'Amazon Q (l'assistant IA made in AWS). Ce concept est plutôt intéressant pour générer des diagrammes à l'aide de la bibliothèque Python "Diagrams".

Concernant Claude Code d'Anthropic, il est important de spécifier le contexte du projet dans le fichier `CLAUDE.md`. Dans cet [article](https://blog.sshh.io/p/how-i-use-every-claude-code-feature), Shrivu Shankar explique les bonnes pratiques pour avoir un fichier `CLAUDE.md` qui permettra à l'agent d'être efficace. Il explique entre autre qu'il ne faut pas avoir un fichier trop gros car il est utilisé par Claude dans son contexte au démarrage de la session. Intéressant à lire et à appliquer.

Anthropic a annoncé  [l'ouverture d'un bureau](https://www.roboto.fr/blog/anthropic-s-implante-en-france-claude-defie-chatgpt-sur-le-marche-europeen) à Paris et Munich pour adresser le marché européen. Le but est de conquérir des parts de marché et de recruter des talents.

La course à celui qui aura le meilleur modèle continue encore et encore. Ce mois-ci, Google a d'abord présenté son nouveau modèle [Gemini 3 ](https://blog.google/intl/fr-fr/nouveautes-produits/gemini-3/)puis Anthropic a déployé le sien avec [Claude Opus 4.5](https://www.lesnumeriques.com/intelligence-artificielle/claude-opus-4-5-le-modele-d-ia-qui-ecrase-tout-sur-son-passage-n246632.html). Ce qui est intéressant côté Google est le fait qu'ils ont utilisé leurs propres TPU pour la phase d'entraînement moins énergivores et qui leur permet de ne pas dépendre de Nvidia. 

Un[ article intéressant](https://www.faketech.fr/p/leconomie-de-lia-tourne-en-rond-bientot) sur le point de vue économique de la bulle IA sur le point d'exploser ? L'auteur explique comment les différents acteurs que ce soit les fournisseurs de cloud, de modèles ou de cartes graphiques entretiennent cette bulle.

## 💻 Programmation

Un (très) long [article](https://loglog.games/blog/leaving-rust-gamedev/) d'un développeur de jeux vidéos qui abandonne Rust pour développer son jeu vidéo après 3 ans de développement. L'auteur explique les raisons de son choix même s'il apprécie énormément les performances obtenues grâce au langage et à l'écosystème qui a énormément évolué. Il regrette néanmoins que la communauté se focalise essentiellement sur le hype. Je ne suis pas totalement d'accord avec son point de vue mais de mon côté, je ne pratique pas ce langage au quotidien.

Un vieil [article](https://medium.com/@andrewimm/writing-a-dos-clone-in-2019-70eac97ec3e1) daté de 2019 mais qui est ressorti de mes recommandations dernièrement. L'auteur s'est donné comme objectif de développer un clone de DOS mais totalement écrit en Rust. Cet article nous détaille les embûches pour créer son clone qui doit être compatible avec le DOS de microsoft.

Les créateurs de l'excellent IDE [Zed](https://zed.dev) ont mis en open source leur bibliothèque de composants UI à savoir [GPU UI](https://www.gpui.rs). Cette librairie multi-plateforme permettra de développer des applications plutôt rapide. J'espère que son adoption pourra faire abandonner les applications Electron mais ça c'est une autre histoire.

Le framework SpringBoot passe en version 4. La [liste des changements](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-4.0-Release-Notes) est longue comme mon bras. Il faudra faire des tests pour passer à cette version majeure mais ce [guide](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-4.0-Migration-Guide) permettra de vous guider.

## 🎲 Découvertes insolites

Je pratique l'escrime de spectacle depuis plusieurs années (presqu'autant que ma carrière professionnelle). J'ai découvert la chaîne YouTube "Entrer en lice" qui est plutôt didactique et est plutôt orientée AMHE (Art Martiaux Historique Européen). Et j'ai bien aimé cette [vidéo](https://youtu.be/qwZX-T_kU6k) qui explique le contexte de la piraterie à la fin du 17eme siècle dans les caraïbes mais surtout les différentes armes utilisées à cette époque.

Une vidéo inspirante pour mes prochains combats en tant que "Cul-de-bouteille" Corsaire du Roy.

## 📊 Ma veille en chiffres (novembre) 

- 📰 + de 50 articles lus dans tous les domaines
- 🎧 + de 30 épisodes de podcasts avec des notes 
- 📚 1 livre fini ([Le grand détournement](https://www.goodreads.com/book/show/241207867-le-grand-d-tournement---comment-milliardaires-et-multinationales-captent))
- 🎬 2 conférences visionnées (replay du DevFest Nantes)

## ❤️ Mon coup de cœur du mois

Un [article](https://mcorbin.fr/posts/2025-01-12-conf-dette/) lu depuis le blog de mcorbin (daté de début d'année mais je rattrape mon retard). L'auteur explique qu'il aimerait voir en conférence des retour d'expérience quand tout va mal. C'est un point de vue intéressant surtout qu'on peut en retirer des points positifs aussi bien pour l'équipe, l'entreprise et l'audience. C'est une pratique qu'on a déjà vu en interne chez WeScale sur différents projets mais que nous ne pouvions pas communiquer en extérieur.

## Pour conclure

Les mois défilent et l'année 2025 est sur le point de s'achever. Et comme chaque année, j'ai l'impression qu'elle est passée comme un éclair.

Les technologies autour de l'IA générative n'arrêtent pas de progresser mais au final, que reste-t-il de ces avancées ? Entre la course à l'échalote pour obtenir le meilleur modèle entre les différents fournisseurs (OpenAI, Anthropic, Google...) et les différentes pannes des cloud providers publics ces deux derniers mois, on peut se poser légitimement la question sur notre dépendance de plus en plus grande aux GAFAM. 

Même si je suis un grand utilisateur de Claude Code, on nous vend de l'IA à toutes les sauces, mais combien d'entreprises l'utilisent réellement de manière productive au quotidien ?

Rendez-vous en janvier pour la première édition de 2026. D'ici là, je vous souhaite de belles fêtes de fin d'année et une bonne déconnexion !

---

**À lire aussi :**  mes précédents articles sur [le blog](/blog/)
