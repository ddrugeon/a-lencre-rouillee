---
title: Les news du mois d'octobre 2025
date: 2025-10-29T09:00:00+02:00
draft: false
author: David Drugeon-Hamon
description: "Ma sélection mensuelle de découvertes tech : la panne AWS, MinIO abandonne Docker, l'IA en Java, Python 3.14, et mon coup de cœur Another World."
reading_time: 7
categories:
  - Veille Technologique
  - Newsletter
tags:
  - veille-mensuelle
  - cloud-native
  - kubernetes
  - ia
  - open-source
  - aws
  - python
  - golang
  - programmation
keywords:
  - veille technologique octobre 2025
  - news tech octobre
  - AWS panne DynamoDB
  - MinIO Docker
  - Python 3.14
  - IA agents Java
  - Kubernetes livre Denis Germain
  - cloud native
  - lambda runtime
  - Another World
ShowToc: true
TocOpen: false
ShowReadingTime: true
ShowShareButtons: true
ShowPostNavLinks: true
ShowBreadCrumbs: true
ShowCodeCopyButtons: false
ShowWordCount: true
comments: true
image: /blog/2025/10/news-octobre/banner.jpg
---

<img src="/blog/2025/10/news-octobre/banner.jpg" style="width: 100%; height: 400px; object-fit: cover; border-radius: 8px; margin-bottom: 2rem;">
<p style="font-size: 0.75rem; color: #666; margin-top: 0.5rem; margin-bottom: 2rem;">
<a href="https://unsplash.com/fr/@ashni_ahlawat" target="_blank" style="color: #999;">Ashni</a> sur Unsplash
</p>

J'aime me tenir informé sur les dernières nouvelles autour de la tech, que ce soit des news sur les tendances du marché, les nouveaux frameworks émergents ou encore de nouvelles pratiques.

Comme je vous l'ai déjà décrit dans [mon article sur comment j'organise ma veille](/blog/2025/10/comment-jorganise-ma-veille/), je lis ou j'écoute différentes sources pour découvrir de nouveaux sujets que je pourrai partager au sein des groupes de travail de mon entreprise actuelle.

Pour élargir mon audience, j'aimerais vous donner un rendez-vous mensuel qui centralisera les articles, découvertes ou autres que j'ai faites ou appréciées. Voici donc cette première édition.

## 📖 Sommaire du mois

En octobre 2025 :
- ☁️ **Cloud** : Panne AWS historique • MinIO dit adieu au gratuit • Livre Kubernetes de zwindler • Google sur ARM
- 🤖 **IA** : Agents Java avec Guillaume Laforge • MCP Service-Public • Claude Skills • Spécifications pour l'IA
- 💻 **Dev** : Python 3.14 (πthon) • Portage Perl→Go • Lambda Runtime décodé
- ❤️ **Coup de cœur** : Another World par Olivier Poncet

## ☁️ Cloud Native et Infrastructure

Minio est une solution Open Source qui permet de faire du stockage objet simplement. Elle est compatible avec les API d'AWS S3. Je l'ai déjà déployé plusieurs fois sur des infrastructures basées sur du Kubernetes.
Après avoir épuré sa console d'administration dans la version Open Source au profit de sa version commerciale, l'éditeur ne produit plus de binaires et encore moins d'images Docker pour la version communautaire ! [Minio retires free Docker images](https://veritas.enc.edu/news/minio-retires-free-docker-images-impact-on-the-open-source-community/)

En cherchant un remplaçant, je suis tombé sur ce projet Open Source écrit en Rust et qui semble aussi performant. Je n'ai pas encore testé ce projet [RustFS](https://github.com/rustfs/rustfs)

Quand AWS tousse, c'est tout l'internet mondial qui est malade. Ce lundi 20 octobre, AWS a connu une défaillance de son service DynamoDB dans la région us-east-1. Deux processus de mise à jour d'un enregistrement DNS se sont entrés en concurrence et les enregistrements DNS de DynamoDB ont été effacés. Cette panne a causé l'interruption de nombreux services et autres sites internet dont Slack ou encore le hub Docker. Au final, comme le dit le mème, la faute est encore au DNS 😁 [La source du probleme a été identifiée](https://moncarnet.com/2025/10/24/panne-geante-chez-aws-amazon-met-en-cause-un-bogue-rare-et-une-automatisation-defectueuse/)

Le livre de [zwindler](https://www.linkedin.com/in/denis-germain/) qu'il a écrit pour présenter cinquante solutions différentes pour déployer son cluster Kubernetes est sorti et est disponible dans les bonnes librairies. [Le post annonçant sa sortie](https://blog.zwindler.fr/2025/10/07/sortie-livre-kubernetes-50-solutions/). Je pense qu'il sera sous le sapin cette année.

Cet [article](https://www.theregister.com/2025/10/22/google_multi_arch_x86_arm_port/) détaille comment Google a déjà porté environ 30 000 applications sur une architecture ARM ce qui lui a permis de faire des gains substantiels (**65% de meilleur rapport prix/performance** que les instances x86 et **60% plus économes en énergie**). Les équipes en ont profité pour entraîner un agent IA qui permet la fiabilisation du portage.

Le podcast ["AWS en français"](https://francais.podcast.go-aws.com/web/index.html) de Sébastien Stormacq est un des rares podcasts autour de l'actualité d'AWS et des REX clients. Dans l'épisode [327](https://francais.podcast.go-aws.com/web/episodes/327/index.html), Sébastien nous plonge dans les coulisses des Lambda Runtime avec son invité Maxime David. Cet épisode est très intéressant : nous apprenons comment AWS gère la mise à jour du Runtime qui exécute les lambdas, comment sont gérés les montées de version, la mise à jour suite à des CVEs etc. Bref à écouter même si vous n'utilisez pas les lambdas !

## 🤖 Intelligence Artificielle

[Guillaume Ginguene](https://www.linkedin.com/in/guigui42/) (Solution Engineer chez GitHub) a créé un serveur MCP pour accéder facilement aux documents disponibles sur le site Service-Public.gouv.fr à l'aide de son agent IA préféré. C'est une belle initiative pour pouvoir poser des questions sur les droits pour tous les usagers. Son projet est disponible sur son [GitHub](https://github.com/guigui42/mcp-vosdroits)

[Guillaume Lagorge](https://www.linkedin.com/in/glaforge/) bien connu des auditeurs du podcast "Les cast codeurs" propose de nombreux articles intéressants pour créer son agent IA en Java. Dans cet [article](https://glaforge.dev/posts/2025/10/25/creating-a-javelit-chat-interface-for-langchain4j/), il propose de découvrir la librairie [Javelit](https://javelit.io) pour faire une interface web simplement pour son chatbot. Cette librairie écrite en Java se rapproche de la librairie [Streamlit](https://streamlit.io) bien connue des développeurs Python.

[Guillaume Lagorge](https://www.linkedin.com/in/glaforge/) a fait un talk à la dernière édition de Devoxx Belgium sur comment écrire des agents IA à l'aide de ADK for Java. Il a mis à disposition sur son [blog](https://glaforge.dev/talks/2025/10/22/building-ai-agents-with-adk-for-java/) l'intégralité des slides, des exemples et la vidéo de la captation de la conférence.

La nouvelle tendance pour obtenir de meilleurs résultats avec son assistant de code est de travailler sur des specifications qui permettront à notre agent IA de produire du code correspondant à nos besoins fonctionnels. C'est l'objet de l'article [Stop coding like it's 2022, the Agentic Era is here](https://tgrall.github.io/blog/2025/10/22/devfest-nantes-stop-coding-like-2022-agentic-era) par [Tugdual Grall](https://www.linkedin.com/in/tugdualgrall/)  ainsi que de l'article [medium](https://medium.com/@sevakavakians/dont-vibe-spec-1885e61dd844) de [Sevak Avakians](https://medium.com/@sevakavakians). Grâce aux fichiers dédiés, il est ainsi plus facile de contrôler ce que fait notre agent IA.

Anthropic, éditeur de la suite d'agents IA Claude (dont le fameux Claude Code), a introduit une nouvelle fonctionnalité appelée Claude Skills. Simon Willison détaille dans cet [article](https://simonwillison.net/2025/Oct/16/claude-skills/) en quoi c'est une révolution et est complémentaire des serveurs MCP pour étendre les fonctionnalités de Claude.

Une conférence intéressante organisée par le collège de France sur le thème de l'IA. Dans cette vidéo, M. Cella nous explique comment les algorithmes de Machine Learning basés sur du Deep Learning bousculent la créativité pour un compositeur. Une conférence très intéressante à la limite philosophique : une machine peut-elle être créative ? : [Formalisation mathématique et apprentissage machine dans la création musicale - C.-E. Cella](https://www.youtube.com/watch?v=83K7vIMVSLg)

## 💻 Programmation

Mark Gardner détaille comment il a porté un script Perl en Golang lui permettant de ne mettre à jour que certains paquets Homebrew et quels en sont les [bénéfices](https://phoenixtrap.com/2025/10/05/brew-patch-upgrade-go-port/)

La nouvelle version de Python (3.14), aussi appelée **𝜋thon** vient de sortir et apporte son lot de nouveautés. La plus intéressante est une meilleure expérience développeur avec par exemple la colorisation syntaxique et l'autocomplétion dans l'interpréteur REPL ou encore de meilleurs messages d'erreurs lors d'une exception. [Les nouveautés de 𝜋thon](https://realpython.com/python314-new-features/)


## 🎲 Découvertes insolites

Une vidéo intéressante sur l'histoire de[ l'accent québécois](https://youtu.be/CQ46BbbLRrk?si=nXLqeZGlGArefhdO). Alors cet accent, au final, est-il de l'ancien Français ?

[Titimoby](https://bsky.app/profile/titimoby.bsky.social) a partagé sur bluesky ce [site pour les plus nostalgiques](https://basic-code.bearblog.dev) qui revisite des programmes en Basic et décrit ce qui a été réécrit.


## 📊 Ma veille en chiffres (octobre)

- 📰 20 articles lus
- 🎧 + de 12 épisodes de podcasts avec des notes
- 📚 1 livre en cours de lecture ([Le grand détournement](https://www.goodreads.com/book/show/241207867-le-grand-d-tournement---comment-milliardaires-et-multinationales-captent))
- 🎬 18 conférences visionnées

## ❤️ Mon coup de cœur du mois

Depuis plus d'un an, je suis Olivier Poncet dans ses lives sur Twitch. C'est toujours aussi intéressant de voir comment il vulgarise un algorithme ou une technologie. Et dans son dernier talk capté à Volcamp, il analyse le moteur du jeu d'Another World - jeu culte d'Eric Chahi sur Amiga sorti en 1991 - pour le réimplémenter sur nos machines modernes et même sur le navigateur grâce à un portage en WASM. Bref, allez le voir en live ou sur la captation du dernier Volcamp: [Another World, une belle leçon d'architecture logicielle](https://youtu.be/etXZ78hviQY?si=Uv6IaAR3ZnAVW4TT)


## Pour conclure

Voilà pour ce premier numéro de ma veille mensuelle ! J'espère que cette sélection vous aura été utile.

Rendez-vous fin novembre pour le prochain numéro 📅
Et n'hésitez pas à me partager vos propres découvertes du mois !

---

**À lire aussi :**  mes précédents articles sur [le blog](/blog/)
