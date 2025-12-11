---
title: Retour sur le re:Invent 2025
date: 2025-12-11T12:08:00+01:00
modified: 2025-12-11
draft: false
author: David Drugeon-Hamon
tags:
  - blog
  - aws
  - reinvent
  - news
categories:
  - AWS
  - Tech
  - Veille Technologique
description: "AWS re:Invent 2025 : IA générative, agents autonomes, S3 Vector... Analyse des annonces qui transforment le cloud computing."
keywords:
  - AWS re:Invent
  - re:Invent 2025
  - Amazon Web Services
  - cloud computing
  - intelligence artificielle
  - agents IA
  - AWS Bedrock
  - AgentCore
  - S3 Vector
  - Lambda Managed Instances
  - EKS
  - Nova2
  - Frontier Agent
reading_time: 8
image:
created: 2025-12-11
ShowToc: true
TocOpen: false
ShowReadingTime: true
ShowShareButtons: true
ShowPostNavLinks: true
ShowBreadCrumbs: true
ShowCodeCopyButtons: false
ShowWordCount: true
comments: false
statut: publié
---
<img src="/blog/2025/12/reinvent-2025/banner.jpg" style="width: 100%; height: 400px; object-fit: cover; border-radius: 8px; margin-bottom: 2rem;">
<p style="font-size: 0.75rem; color: #666; margin-top: 0.5rem; margin-bottom: 2rem;">
<a href="https://unsplash.com/fr/@jonasjacobsson" target="_blank" style="color: #999;">Jonas Jacobson</a> sur Unsplash
</p>

Comme tous les ans, AWS organise pendant une semaine une conférence pour leurs clients : le re:invent. C'est l'occasion pour AWS de présenter les nouveautés qu'ils proposeront en bêta ou en GA pour certains services. La semaine est rythmée par une keynote par jour en fonction des thèmes abordés. Les points forts de la semaine sont la keynote d'ouverture présentée par le CEO d'AWS et celle de fermeture par le CTO d'Amazon. C'est aussi l’occasion pour les participants d'assister à des talks avec des retours d'expérience ou d'avoir des talks plus technique sur telle ou telle technologies. Enfin, c'est un grand espace pour faire du réseautage.

Cette année, elle s'est déroulée du 1  au 5 décembre 2025 à Las Vegas. Dans cet article, je vous présente les grandes tendances de cette année, les nouveautés qui m'ont marquée et je vous donnerai enfin un avis personnel sur ces annonces.

## La grande tendance de l'année : Focus sur les Agents IA

Comme vous vous en doutez, LA grande tendance est bien entendu l'Intelligence artificielle.

Nous pourrions penser qu'AWS est loin derrière Google ou Microsoft sur ces sujets. Mais finalement, ils sont présents sur toute la chaîne depuis les processeurs dédiés à l'entraînement et à l'inférence jusqu'aux modèles et les services pour faciliter le développement d'agents ou leur déploiement.

Et cette tendance se confirme aussi sur l'ordre des keynotes : celle de Peter DeSantis (Senior VP Utility Computing) et de Peter Brown (Directeur Sales, Strategy, Planning et Operations) sur les nouveautés côté Compute a été décalée en fin de semaine contrairement au programme habituel. Et celle de Dr. Swami Sivasubramanian (VP Agentic AI) a été programmée à sa place.

À travers les différentes keynotes, AWS insiste sur le fait qu'il est maintenant possible de développer facilement des Agents IA autonomes permettant d'exécuter différentes tâches. Cela devient le cœur de sa stratégie à l'aide d'AWS Bedrock AgentCore :l’« ossature » pour construire ses propres agents IA.

Ils introduisent un nouveau type d'Agent appelés Frontier Agent (à voir si l'industrie adoptera ce nouveau terme). Avec ce type d'agent autonome, il est possible de :
- Développer avec Kiro (leur éditeur concurrent de Cursor orienté « spec driven development »)
- Faciliter le diagnostic lors d'un incident pour aider les SRE en astreinte avec l'agent IA DevOps, ou encore accélérer l'automatisation
- Analyser et remédier les failles de sécurité sur le compte AWS ou les applications déployées avec l'agent Sécurité.


> [!cite]
> « Les assistants IA commencent à céder la place à des agents capables d’exécuter des tâches et d’automatiser en votre nom. C’est là que l’on commence à voir des retours sur investissement matériels. » 
> 
> **Matt Garman**, CEO d'AWS lors de la keynote d'ouverture

AWS ne veut pas forcément suivre les acteurs autour de l'IA comme OpenAI, Anthropic ou Google à la course au meilleur modèle, mais restent dans leur mantra à savoir Customer First : Ils proposent une ribambelle de produits depuis les types d'instances avec de nouvelles puces dédiées pour l'entraînement et l'inférence jusqu'au choix de modèles LLM le plus vaste du marché (Aussi bien commerciaux qu'en open weight) et les différents services pour développer efficacement ses propres agents IA.

Vu la quantité de nouveauté proposée et annoncée avant et  lors de cette semaine de re:invent, j'ai préféré sélectionner ce qui m'a le plus marqué. Je les ai regroupés par domaine.

## Les nouveautés les plus marquantes

### IA

Amazon propose une nouvelle génération de leurs propres modèles LLMs à savoir Nova2:
- Nova2 Lite - un modèle de langage efficace et peu cher pour les tâches les plus courantes (prise en charge des tools et une fenêtre de contexte de 1 million de tokens)
- Nova2 Omni - un modèle de langage multi-modal permettant la génération d'images et de texte. A noter que ce modèle est en preview.
- Nova2 Forge - un modèle préentraîné pour être ensuite entraîné sur ses propres données pour le spécialiser sur ses cas d'utilisation métier.

AWS propose depuis l'année dernière AWS Bedrock Knowledge Bases : un service de RAG (Retrieval-Augmented Generation) à la demande et serverless. Jusqu'à présent, ce service utilisait un cluster OpenSearch serverless pour stocker ses documents sous forme vectorielle. Or, un cluster OpenSearch même serverless coûte au minimum 150$ / mois (voire plus en fonction de la région). Ils ont annoncé le support de Amazon S3 Vector comme base vectorielle. Ce service était en bêta depuis cet été et est maintenant en GA depuis le re:invent. C'est un game changer pour ce cas d'utilisation : coût moindre, performances autour de 100ms pour récupérer des données les plus proches depuis la base et simplicité d'utilisation. D'ailleurs, il est maintenant aussi possible d'utiliser ce service pour OpenSearch pour la partie vectorielle. Pratique lorsqu'on a déjà des clusters OpenSearch déployés sur nos infras.

AWS se veut aussi le plus gros fournisseur de modèles en OpenWeight comme en modèles commerciaux. AWS Bedrock propose désormais 18 modèles supplémentaires, comme les modèles de Mistral, de Qwen (et dire que c'est Alibaba qui est derrière ce modèle) ou encore OpenAI (ils ont signé un partenariat avec OpenAI dernièrement).

Ils proposent aussi un nouveau service AWS AI Factories. C’est tout simplement un ensemble de serveurs à installer chez soi. Il comprend des modèles de base LLM, des services AWS et du matériel dédié pour les entreprises qui ont besoin de souveraineté des données. C'est entièrement managé par AWS. Reste à voir si le Cloud Act américain s'applique toujours...

Enfin, AWS veut faciliter le développement et le déploiement d'agents IA avec AWS Bedrock AgentCore. AgentCore regroupe différents services nécessaires pour un agent autonome, à savoir.

- Un runtime pour orchestrer des agents (appel de modèles, outils, APIs, bases de données, etc.).
- Une gestion de l’état et de la mémoire de l'agent (pour le contexte actuel sur la tâche à accomplir, mais aussi sur les interactions passées).
- Des capacités de planification et de décision (décomposer une tâche, choisir quelles actions/outils appeler).
- Intégré au reste d’AWS (Bedrock, données, sécurité, observabilité) pour déployer des agents en production.

Et bien entendu, les trois agents déjà cités.


### Compute

La plus grande nouveauté vient du côté d'AWS Lambda. Ils introduisent le nouveau service **AWS Lambda Managed Instances**. Ce service permet d'exécuter les lambdas sur une instance EC2 dédiée et managée par AWS. Cela permettra de réduire les coûts tout en pouvant choisir le type d'instance dédiée (et donc piocher dans ses services plan ou reserved instance). Ce type d'AWS Lambda ne sera pas adapté à tous les cas d'utilisation, mais permettra d'adresser le cas où l'invocation des lambdas est prévisible dans le temps.

L'autre nouveauté intéressante concerne EKS avec **Amazon EKS Capabilities for workload orchestration and cloud resource management**. EKS devient une plateforme Kubernetes entièrement géré par AWS. En plus de gérer les control planes du cluster, AWS gère aussi les nœuds workers: Déploiement, scaling, mises à jour, rollbacks  et applications de patterns courants (Blue / Green Deployment, jobs, batch...) gérés par la plateforme. Le service gère aussi tout ce qui est utilisé par le cluster (les load balancers, IAM, secrets...). Bref, vous n'aurez plus à gérer la plomberie de l'infrastructure autour d'un cluster Kubernetes, mais à quel prix ? À vrai dire, je n'ai pas encore regardé.

### Database

Une des nouveautés qui m'a intéressé est la gestion des coûts des instances avec l'introduction de Database Saving Plans : au niveau d'une organisation, il est maintenant possible de réduire les coûts des instances de bases de données pour l'ensemble des bases de données, quel que soit le type (RDS, Neptune, DocumentDB...). Bref, c'est un vrai levier d'optimisation des coûts.

Bien entendu, d’autres annonces ont été faites en ce qui concerne le réseau, dont un partenariat avec Google pour assurer la résilience des applications multi-cloud. Vu le nombre d'incidents ces deux derniers mois, c'est plutôt une bonne nouvelle. AWS a aussi annoncé que Microsoft sera aussi de la partie dans les prochains mois.

Face à cette avalanche d'annonces, prenons du recul pour analyser ce qui change vraiment.

## Alors, qu'en penser ?

Cette année, la stratégie d'AWS change complètement d'horizon. AWS n’est plus seulement un vendeur d’infrastructures et de services, c’est maintenant un véritable accélérateur de développement d’applications axées sur l’IA au niveau d’une entreprise. Et cette approche pourrait bien être payante : AWS propose l'infrastructure complète du silicium aux agents clés en main, en passant par le plus large catalogue de modèles du marché. Là où OpenAI aimerait, aller avec ses différents partenariats pour construire leurs propres datacenters ou encore son plus sérieux concurrent Google qui pousse ses solutions verticales.

> [!quote]
>  « Est-ce que l'IA va prendre mon job ? Peut-être. Mais est-ce qu'elle va me rendre obsolète ? Absolument pas… à condition que vous évoluiez. »
>  
>  **Werner Vogels**, CTO d'Amazon, lors de la keynote de clôture

Mais des questions se posent.

Sur les agents autonomes, l'adoption des assistants de code est maintenant acquise dans les pratiques de développement. Même si les modèles sont de plus en plus performants, le gain de productivité annoncé n'est pas forcément à la hauteur des espérances. Le concept de "Frontier Agent" semble prometteur : les équipes SRE et sécurité auront plus de temps pour se consacrer à des tâches valorisantes plutôt qu'aux tâches répétitives et aux fausses alertes. En tant que SRE, je reste particulièrement attentif à cette promesse. Combien de fois ai-je passé des nuits à investiguer des fausses alertes ou des incidents répétitifs ? 

Côté infrastructure, S3 Vector est un vrai game changer pour la réalisation de POC à moindres coûts. Les Database Saving Plans multi-services permettront aussi d'optimiser significativement les budgets cloud. De quoi accélérer l'innovation sans les frictions liées aux coûts de démarrage.

Lambda Managed Instances interroge : AWS nous promet depuis des années de réduire les coûts grâce aux lambdas. La scalabilité et le modèle de pricing à l'usage sont-ils encore d'actualité avec ce nouveau service ? C'est pragmatique pour certains workloads prévisibles, mais c'est aussi un aveu des limites du modèle serverless pur.

EKS entièrement managé va diviser la communauté. D'un côté, pour des entreprises qui veulent juste déployer leurs apps sans gérer la plomberie Kubernetes, c'est une aubaine. De l'autre, pour ceux qui ont investi dans leur expertise Cluster API, GitOps et automation maison, la valeur ajoutée est moins évidente. Et surtout : combien ça coûte ? AWS a la fâcheuse tendance à facturer généreusement ses services managés. Si le coût devient prohibitif, autant rester sur sa stack custom.

Au final, AWS confirme sa maturité et son pragmatisme en proposant des services qui simplifient réellement l'adoption de l'IA en entreprise. Certaines annonces sont excitantes (S3 Vector, Database Saving Plans), d'autres relèvent encore du pari technologique (Frontier Agents). Rendez-vous dans quelques mois pour mesurer l'écart entre la keynote et la réalité terrain.
