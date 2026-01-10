---
title: Bilan 2025 et perspectives pour 2026
Date: 2026-01-03
created:
  2026-01-03
modified:
  2026-01-03
draft: false
author: David Drugeon-Hamon
tags:
  - blog
  - rétrospective
  - kubernetes
  - ia-generative
  - cloud-souverain
categories:
  - Personnel
description: "Rétrospective de mon année 2025 : mission chez Numspot, veille IA générative, lancement de mon blog. Perspectives 2026 avec mon nouveau poste chez Teralab autour de Gaia-X et des dataspaces."
keywords:
  - bilan 2025
  - rétrospective
  - kubernetes
  - cluster api
  - numspot
  - teralab
  - ia générative
  - gaia-x
  - cloud souverain
  - secnumcloud
ShowToc: true
TocOpen: false
ShowReadingTime: true
ShowShareButtons: true
ShowPostNavLinks: true
ShowBreadCrumbs: true
ShowCodeCopyButtons: false
ShowWordCount: true
comments: false
statut: brouillon
---
<img src="/blog/2026/01/bilan-2025/banner.jpg" style="width: 100%; height: 400px; object-fit: cover; border-radius: 8px; margin-bottom: 2rem;">
<p style="font-size: 0.75rem; color: #666; margin-top: 0.5rem; margin-bottom: 2rem;">
<a href="https://unsplash.com/fr/@ottofreijser" target="_blank" style="color: #999;">Otto Freijser</a> sur Unsplash
</p>

Eh oui, les fêtes sont passées, nous sommes déjà début 2026. Malgré la neige et le froid qui ont fait leur apparition en ce début de semaine, il est temps pour moi de faire une rétrospective de l'année écoulée autant au point de vue professionnel que personnel.

J'aimerais aussi donner quelques perspectives pour cette nouvelle année même si le contexte géopolitique actuel est assez pesant.

## Mes fiertés

En 2025, mon année professionnelle a été essentiellement centrée sur ma mission chez Numspot et sur la veille autour de l'IA générative.

### Ma mission chez Numspot

Ma mission chez Numspot a commencé en octobre 2024 et a continué tout au long de l'année jusqu'à mi-décembre 2025. J'ai ainsi pu travailler sur différents sujets tout au long de l'année.
#### Cluster API

Dans une démarche "platform engineering", j'ai aidé à mettre en place la gestion de clusters Kubernetes à la demande grâce à [Cluster API](https://cluster-api.sigs.k8s.io).

> [!info]
> Cluster API permet de définir l'infrastructure et les spécifications d'un cluster Kubernetes que nous aimerions créer à l'aide d'une description sous forme de fichiers YAML. Des contrôleurs spécifiques sont alors installés sur notre cluster dit de gestion pour créer cette infra et ces clusters. Il existe des providers spécifiques pour une infrastructure dédiée (de la création de clusters sous forme de container Docker en passant par une infrastructure sur AWS ou GCP).

C'est un beau challenge technique pour industrialiser cette solution afin de pouvoir créer des clusters Kubernetes en fonction des environnements. Ces clusters sont ensuite utilisés pour héberger l'outillage nécessaire aux développements, aux tests et autres.

La principale difficulté rencontrée était la disponibilité du provider utilisé qui était en béta au moment où j'ai fait le prototype puis l'industrialisation avec l'équipe. C'est un des problèmes quand l'infrastructure n'est pas déployée sur un Cloud Provider Américain.
#### Développement de contrôleurs Kubernetes

Pour les besoins de la certification SecNumCloud, j'ai pu creuser comment isoler les clusters kubernetes en fonction de leur environnement. Il fallait, en effet, pouvoir accéder à l'API server des clusters gérés par Cluster API sans l'exposer sur internet. En explorant les solutions, les architectes avaient évoqué la piste [Netbird](https://netbird.io) pour mettre en place une connexion entre le contrôleur Cluster API et l'API server de Kubernetes.

> [!info]
> Netbird est une solution de Zero Trust Network basé sur Wireguard. Cela permet de mettre en place des connexions VPN facilement grâce à un mesh de réseau.

Ce fut le plus gros challenge de cette année. La documentation de Netbird est assez sommaire et la solution technique est toujours en développement avec de nouvelles fonctionnalités à chaque release. Après avoir compris comment fonctionne cet outil, j'ai pu développer mon premier contrôleur Kubernetes en Golang pour automatiser la création du réseau et sa configuration.

Une fois ce premier contrôleur finalisé, j'ai développé un second contrôleur pour automatiser la gestion des connexions aux serveurs dans Warpgate (j'ai d'ailleurs fait un tour d'horizon de la solution dans [cet article](/blog/2025/11/warpgate/)).
#### Développement d'outils internes

Ce fut l'occasion de développer aussi une CLI pour automatiser la génération de network policies pour isoler les workloads dans les clusters kubernetes. J'en ai fait une série d'articles à ce sujet:
- [partie 1](/blog/2025/11/vibe-coder-cli-part1/)
- [partie 2](/blog/2025/11/vibe-coder-cli-part2/)
- [partie 3](/blog/2025/11/vibe-coder-cli-part3/)

#### Une aventure humaine

Ce n'est pas tous les jours que l'on a l'opportunité de développer les fondations d'un cloud provider français et souverain. La route a été parsemée de doutes et de victoires avec la sortie, par exemple, de la plateforme en GA en avril 2025. Le plus gros des challenges a été d'être techniquement à l'heure pour le calendrier de la certification SecNumCloud. La phase de certification a été terminée à la fin de ma mission. Je croise les doigts pour que Numspot puisse l'obtenir car l'équipe a vraiment relevé tous les challenges imposés par cette certification (avec entre autres le cloisonnement des workloads).

Pendant cette année, j'ai vogué au sein de différentes équipes et j'ai pu y rencontrer des personnes formidables et volontaires. J'ai aussi la fierté d'avoir accompagné des personnes en début de carrière pour les faire grandir.

Bref, cette mission était plutôt positive même si cela n'a pas été facile tous les jours.

### Veille technologique et IA générative

Depuis septembre 2024, j'ai co-animé un groupe de travail sur l'IA générative, d'abord avec Ivan Beauvais puis avec Bertrand Nau. Ce groupe de travail interne à WeScale a permis de se former sur ces nouvelles technologies, de produire des talks internes pour vulgariser certains concepts, de réaliser des POCs.

Dans ce cadre, nous avons exploré Bertrand et moi l'utilisation de SLM (Small Language Models) pour être utilisés dans le cadre de la domotique (et entre autres pouvoir déclencher la lecture d'un MP3, d'un livre audio ou d'un film). Nous avons un prototype que nous avons mis en opensource (de mon côté, j'avais développé la partie enrichissement des contenus pour ensuite les mettre dans une base Qdrant). Travail très intéressant qui aurait dû être présenté dans un talk à Devoxx France 2025 si nous avions été retenus.

J'ai aussi réalisé une solution pour faire de la recherche documentaire d'entreprise. J'ai pu tester la dernière version d'Onyx (nouveau nom de DAnswer) que j'avais documenté sur une série d'articles de blog sur le blog de WeScale ([partie 1](https://blog.wescale.fr/mise-en-place-dun-assistant-avec-lia-introduction), [partie 2](https://blog.wescale.fr/mise-en-place-dun-assistant-avec-lia-implementation), [partie 3](https://blog.wescale.fr/mise-en-place-dun-assistant-avec-lia-bilan)).
Ce fut aussi l'occasion d'expérimenter des workflows à l'aide de N8N.

Et pendant l'été, nous avons aussi pu tester différents agents de codage pour choisir une solution pérenne.

Ce groupe de travail était actif et les membres très impliqués aussi bien pour faire de la veille partagée ou faire des expérimentations.

### Lancement du blog personnel

Cela faisait longtemps que je réfléchissais à produire du contenu sur un blog personnel mais je n'avais pas pris le temps et le courage à deux mains pour m'y lancer.  J'ai ouvert ce blog en octobre 2025, et j'ai déjà écrit 10 articles depuis. Ils semblent être lus avec intérêt.

Ce serait dommage de s'arrêter en si bon chemin, je continuerai sur ma lancée en 2026.

### Running

Depuis plus de trois ans, je me suis mis à la course à pied. Ce fut dur au début mais maintenant je prends du plaisir à courir. Depuis le milieu de l'année, j'ai trois entraînements par semaine, ce qui me permet d'évacuer le stress. Je ne cherche pas la performance mais plutôt le bien-être.

Le seul regret : avoir dû revendre mon dossard pour les 10 Kms du marathon vert organisé à Rennes. En effet, j'ai dû me faire opérer la veille de la course.

### Musique

Cela fait six ans que j'ai commencé à apprendre à jouer de l'accordéon diatonique. Je commence enfin à prendre du plaisir à jouer certains morceaux même si la marche de progression est encore haute. Je joue depuis la rentrée en duo avec une partenaire du même niveau et nous avons pu jouer en décembre pour animer une porte ouverte.

## Mes points à améliorer

### Conférences et talks

Côté conférence, je n'ai pas pu en donner en 2025. J'avais soumis un talk à Devoxx avec mon ami Bertrand Nau sur le framework LangChain avec notre retour d'expérience suite à un projet commun. Malheureusement, ce talk n'a pas été retenu mais je suis content que Bertrand ait pu en donner deux à Devoxx.

Néanmoins, j'ai donné plusieurs talks en interne, aussi bien pour vulgariser les concepts clés des LLMs que pour partager comment je fais de la veille (le talk issu de mon article). 

J’ai proposé trois talks pour 2026 au CFP de Devoxx France pour cette année. J’ai également l’intention de participer au Breizh Camp et à d'autres conférences dans l'année.

### Escrime Artistique

Cette saison a été en demi-teinte. J'ai eu beaucoup de déplacements qui m'ont fait annuler des séances d'entrainements.

J'ai tout de même participé à la fête des corsaires 2025. Cette édition était moins réussie que les années précédentes à cause des conditions de sécurité demandées. Nous avions par exemple interdiction de sortir nos épées quand nous déambulions dans les rues de Saint-Malo. Et nous étions surveillés par les troupes militaires Sentinelle lors de nos démonstrations.

En 2025, je n’ai pas eu le temps de préparer un combat. Ce n’est que partie remise : j’aimerais en présenter un lors de la prochaine édition.

### Running

J'ai tout de même participé à une course caritative à Noël (un 8 km). C'est la troisième année que j'y participe. J'étais déçu du résultat où j'ai été moins performant que lors de l'édition 2024.

Peut-être un record pour cette année ?

## Et pour 2026 ?

### Un nouveau chapitre professionnel

J'ai quitté le monde du conseil pour rejoindre Teralab, un laboratoire de transfert de technologies du groupe Institut Mines et Télécom. 

C'est un nouveau challenge qui s'offre à moi :  Je devrai aussi bien gérer l'infrastructure de projets de recherches et collaboratifs, évangéliser et contribuer à Gaïa-X et travailler autour des espaces de données.

> [!info]
> Un espace de données (ou Dataspace) est un écosystème permettant à des organisations (entreprises, administrations, laboratoires) de partager des données de manière sécurisée et interopérable, tout en conservant le contrôle et la souveraineté sur celles-ci.
>
> Exemple concret : les données d'un patient sont réparties entre hôpitaux, laboratoires et mutuelles. Plutôt que de les centraliser, chaque acteur garde ses données et décide avec qui les partager (le laboratoire peut autoriser l'accès à un hôpital, par exemple). Une gouvernance commune définit les règles de ce partage.

Dans le contexte géopolitique actuel, travailler sur des alternatives souveraines aux cloud providers américains prend tout son sens.

### Objectifs personnels

Côté running, j'ai une revanche à prendre : j'aimerais enfin participer à mon premier 10 Km voire à mon premier semi-marathon. Il faut que j'y réfléchisse encore. Bien entendu, je participerai de nouveau à la course caritative à La Motte comme tous les ans en ayant en tête de faire un meilleur temps.

Pour l'accordéon, je compte poursuivre ma progression et multiplier les occasions de jouer en duo. Six ans de pratique, et je commence enfin à prendre du plaisir — il serait dommage de s'arrêter en si bon chemin.

Concernant le blog, j'ai déjà beaucoup d'idées d'articles. Il me reste encore à les planifier pour avoir un rythme soutenable entre mes différentes activités.

---

Et vous, quels sont vos objectifs pour 2026 ?
