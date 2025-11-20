---
title: "J'ai vibe codé une CLI (2/3) : Pourquoi Claude Code ?"
date: 2024-11-15
created: 2024-11-15
modified: 2025-11-20
draft: false
author: David Drugeon-Hamon
tags:
  - blog
  - IA
  - claude-code
  - assistants-code
  - wescale
categories:
  - IA Générative
  - Outils
description: Comment choisir son assistant de code ? Retour d'expérience sur l'évaluation et la sélection de Claude Code chez WeScale
keywords: claude code, anthropic, assistant de code, IA générative, wescale
ShowToc: true
TocOpen: false
ShowReadingTime: true
ShowShareButtons: true
ShowPostNavLinks: true
ShowBreadCrumbs: true
ShowCodeCopyButtons: false
ShowWordCount: true
comments: false
statut: a-publier
---

<img src="/blog/2025/11/vibe-coder-cli-part2/banner.jpg" alt="Un " style="width: 100%; height: 400px; object-fit: cover; border-radius: 8px; margin-bottom: 2rem;">
<p style="font-size: 0.75rem; color: #666; margin-top: 0.5rem; margin-bottom: 2rem;">
    Photo de <a href="https://unsplash.com/fr/@brikelly">Brian Kelly</a> sur Unsplash
</p>

## Résumé de l'épisode précédent

Dans la [partie 1](/blog/2025/11/vibe-coder-cli-part1/), je vous ai présenté le contexte du projet : en tant que SRE, je devais transformer une matrice de flux réseau complexe en dizaines de Network Policies Cilium. Plutôt que de le faire manuellement, j'ai décidé de créer une CLI... avec l'aide d'un assistant de code.

**Dans cet article (partie 2/3)** : Je vous explique pourquoi et comment j'ai choisi Claude Code parmi tous les assistants de code disponibles.

## Mon parcours avec les assistants de code IA chez WeScale

Et oui, depuis un peu plus d'un an, j'anime en binôme au sein de WeScale une communauté de personnes intéressées par l'IA Générative. Tout d'abord avec Ivan Beauvais avec qui nous avions déjà animé ensemble la communauté autour des "Cloud providers" puis avec Bertrand Nau lorsqu'Ivan est parti pour de nouvelles aventures.

Grâce à cette communauté, nous avons pu monter en compétence sur différents sujets autour de l'IA Générative :

- **Veille technologique partagée** : Chaque mois, nous partageons les nouveautés, articles, et annonces du secteur, et ce n'est pas une mince affaire tant les annonces et avancées se font rapidement. L'idée est que chaque membre sélectionne un article, une news, une conférence ou encore un outil qui l'a marqué dans le mois pour le partager au sein de la communauté. Cela permet d'alimenter sa veille en misant sur l'intelligence collective.

- **Compréhension et vulgarisation des concepts clés** : RAG, prompt engineering, fine-tuning, agents, etc. Vu le nombre de concepts à appréhender et vite obsolète, il est nécessaire de comprendre les fondements. Nous avons donné des conférences, tant en interne qu’en externe, pour expliquer différents concepts, tels que ceux du serveur MCP, de l’embedding ou encore des bases vectorielles.

- **Développement de POC** : Pour mettre en pratique et expérimenter concrètement en prenant des cas d'utilisation.  Bertrand et moi avions fait un projet pour un assistant vocal pour piloter un lecteur multimédia, nous avons aussi réalisé un prototype de chatbot interne autour de la recherche documentaire, etc.

- **Retours d'expérience** : Partage des usages en mission et des apprentissages. Des collaborateurs du cercle ont pu expérimenter des assistants IA en mission, leur retour d'expérience est toujours intéressant pour avancer sur le sujet.

## Le défi : équiper tous les collaborateurs

De nombreux collaborateurs avaient émis le souhait d'avoir un assistant de code pour les aider au quotidien. La communauté a alors été sollicitée pour effectuer une évaluation sur les différents acteurs du marché afin de proposer une solution.

Et tout un tas de questions s’est alors posé à nous :
  

> [!quote]
> Quelle technologie choisir ? 
> Un IDE, un assistant de code en mode CLI ou agent ? 
> Un assistant de code en mode SaaS ou hébergé ? 
> Un assistant de code local pour garantir la sécurité des données ?

## La méthodologie d'évaluation : le panel

Pour répondre à ces besoins, nous avons décidé de constituer un panel de collaborateurs ayant un intérêt à l'utilisation de ces outils.

### Comment ça a fonctionné ?

1. **Constitution du panel** : ~6 collaborateurs volontaires avec différents profils (dev, SRE) et plutôt séniors

2. **Période de test** : L'évaluation a eu lieu cet été pendant environ 2 mois. Chaque collaborateur a pu évaluer au quotidien un ou plusieurs assistants de code compatible avec son IDE préféré sur des projets internes ou personnels.

3. **Outils testés** : GitHub Copilot, Gemini (Web et CLI), Claude (Web et Claude Code), Jetbrains Junie et bien d'autres.

4. **Collecte de feedback** : sessions de partage sur les différentes expérimentations aussi bien pour les ops que pour les dev. Ces sessions de partage ont permis de comprendre les avantages et inconvénients des outils en fonction des tests effectués.

5. **Recommandations** : Sur la base des retours terrain, nous avons ensuite effectué nos recommandations pour équiper au mieux les collaborateurs.

### Les questions clés

Pour structurer notre réflexion, nous avons identifié plusieurs axes d'évaluation :

| Axe d'évaluation | Critères |
|------------------|----------|
| **Format de l'outil** | Extension IDE (VS Code, JetBrains, NeoVim)<br>CLI / Agent autonome<br>Service web |
| **Modèle d'hébergement** | SaaS (cloud provider)<br>Auto-hébergé (on-premise)<br>Local (sur la machine du développeur) |
| **Sécurité et souveraineté des données** | Données envoyées au cloud<br>Données restant en local<br>Anonymisation / filtrage |
| **Modèles disponibles** | Famille de modèles<br>Performance sur la génération de code<br>Taille du contexte |
| **Expérience utilisateur** | Courbe d'apprentissage<br>Intégration dans le workflow<br>Fonctionnalités avancées |

### Les critères qui ont compté

À travers les retours des collaborateurs, certains critères se sont révélés plus importants que d'autres :

- **Qualité de la génération de code** : Le critère numéro 1
- **Compréhension du contexte** : Capacité à analyser une codebase existante
- **Facilité d'intégration** : Dans les workflows existants
- **Coût** : Rapport qualité/prix
- **Respect de la vie privée** : Où vont nos données ?

## Pourquoi j'ai choisi Claude Code pour ce projet

Le panel a validé quatre outils principaux selon les cas d'usage : GitHub Copilot pour l'intégration IDE, Junie pour l'écosystème JetBrains, Gemini en mode chat et Claude Code pour son approche CLI et son modèle performant.

Initialement, j'avais commencé mes tests avec l'assistant Junie de Jetbrains. Étant équipé de l'IDE Intellij en version ultimate, je me suis dit que c'était l'occasion de prendre pour un mois l'abonnement et tester leur assistant.

L'assistant de code est basé sur plusieurs modèles disponibles du marché :  OpenAI, de Google, d'Anthropic voire celui de Jetbrains. Les premiers tests étaient plutôt bons, Junie propose des solutions claires, génère du code propre et plutôt performant néanmoins, la limite que j'ai vue est le nombre d'appels limités aux différents modèles. 

L'abonnement donne une limite mensuelle sur l'utilisation d'un modèle. En fonction de celui qui est sélectionné, cette limite peut être vite atteinte.

<img src="/blog/2025/11/vibe-coder-cli-part2/junie-pricing.png"/>

Ce que j'ai pu constaté est que la limite est vite atteinte lorsque l'on demande à Junie de spécifier et implémenter une nouvelle fonctionnalité en fonction du modèle choisi.

> [!info] A noter
> Lors de mon expérimentation, GPT5 n'était pas encore disponible. C'est maintenant le modèle par défaut de Junie et permet d'économiser des crédits vu le prix au token moins élevé que Claude.

C'est alors que je me suis dit que je pouvais tester directement Claude Code en prenant l'abonnement Pro.
### Anthropic et Claude : qui sont-ils ?

Ce que j'ai pu constater est que la limite est vite atteinte lorsque l'on demande à Junie de spécifier et implémenter une nouvelle fonctionnalité en fonction du modèle choisi.

> [!info] A noter
> Lors de mon expérimentation, GPT5 n'était pas encore disponible. C’est maintenant le modèle par défaut de Junie, qui lui permet d’économiser des crédits, grâce à son prix au token moins élevé que celui de Claude.

C'est alors que je me suis dit que je pouvais tester directement Claude Code en prenant l'abonnement Pro.

### Claude Code : l'assistant en ligne de commande

Depuis février 2024, Anthropic a lancé un assistant de code sous forme d'une CLI avec laquelle nous pouvons interagir. Étrange au lancement et depuis copié par différents acteurs concurrents (Google avec Gemini Code, Alibaba avec la sienne ou encore OVHCloud avec Shai). Cette CLI permet d'interagir avec sa base de code depuis le terminal. Elle s'intègre aussi dans l'IDE de votre choix (j'utilise essentiellement Intellij et Zed depuis peu)

#### Les forces de Claude Code

**1. Performance du modèle**

Claude s'est imposé comme la référence pour la génération de code. Les tests de performane publics (HumanEval, MBPP) le placent régulièrement en tête, et sur le SWE bench - qui évalue la capacité à résoudre des issues réelles sur des repos GitHub - trois modèles Claude figurent dans le top 5.

> [!attention]
> Depuis la rédaction de cet article, Gemini 3 Pro est sorti et est maintenant considéré comme le meilleur modèle pour la génération de code.


**2. CLI native**

Au final, le format CLI plutôt qu'extension IDE présente plusieurs avantages pour mon cas d'usage :

- Indépendance de l'éditeur de code. J'ai ainsi pu interagir avec zed comme intellij
- Automatisation possible via des scripts ou pour la CI/CD. Claude propose un mode non interactif.
- Interaction en langage naturel.
- Moins de distractions qu'une extension. L'assistant peut travailler sur sa base de code pendant que je code en parallèle sur d'autres fonctionnalités.

**3. Fonctionnalités avancées**

Anthropic n'hésite pas à ajouter de nouvelles fonctionnalités au fil de l'eau :

- **Prise en charge de serveurs MCP** : Anthropic est à l'origine du protocole MCP (Model Context Protocol). Claude le supporte naturellement et cela permet d'étendre ses possibilités. Il est possible qu'il crée automatiquement une PR sur un repo en interagissant directement avec le serveur MCP de Github.

- **Tools** : Introduit par OpenAI pour ChatGPT, Claude est aussi compatible avec les tools, cela permet par exemple de pouvoir lancer des commandes sur votre machine ou créer des fichiers.

- **Sous-agents** : Claude supporte des Agents spécialisés pour différentes tâches (exploration de code, revue, tests). Ils en proposent quelques-uns par défaut, mais il est facile d'en ajouter de nouveaux soit au niveau de sa machine, soit au niveau du projet pour les partager avec les collègues. Par exemple, j'en ai créé un pour générer de la documentation en respectant le paradigme Diátaxis

- **Skills** : Nouvelle fonctionnalité proposée par Anthropic qui ajoute de nouvelles capacités (pouvoir facilement créer un ticket sur Jira par exemple). C’est plus performant et moins consommateur en jetons que les interactions avec un serveur MCP pour certaines tâches.

- **Mode plan** : Claude propose différents niveaux de réflexions en fonction de la tâche à accomplir (plus le mode de réflexion est important, plus le modèle coûtera cher.). C'est plutôt pratique en phase de conception, de définition de features ou quand on veut comprendre l'architecture logicielle d'un projet existant.

- **Gestion du contexte** : Claude propose une grande taille de contexte (200k tokens) ce qui permet d'avoir de grandes sessions de codage sans devoir réexpliquer le projet. De plus, Claude a été le premier à supporter une mémoire sous forme de fichier CLAUDE.md où seront stockés des informations sur le projet, comment le builder, les guides de développements, etc... Depuis, une spécification avec AGENT.md est apparue.

**4. Transparence et sécurité**

Claude peut être déployé sur différents cloud providers. La plupart le supportent que ce soit AWS, OVHCloud ou Scaleway. Il est ainsi facile de l'héberger et s'assurer que nous maitrisons nos données.

D'ailleurs, la documentation est claire sur l'utilisation des données. Par défaut, les données peuvent être réutilisées pour l'apprentissage des futurs modèles, mais il est toujours possible de le désactiver.

Et enfin, les logs des interactions sont disponibles, ce qui permet de voir et de rechercher ce qui a été fait avec la CLI.

### Pourquoi c'était adapté à mon projet de CLI ?

Pour mon projet spécifique de génération de Network Policies, Claude Code présentait plusieurs atouts :

**Architecture claire** : J'avais une idée de l'architecture logicielle que je voulais mettre en place pour cette CLI. Le mode plan m'a permis de vérifier si c'était réalisable facilement. Ce mode est plutôt utile même pour aider à brainstormer ou à faire des choix.

**Itérations rapides** : Les interactions sont plutôt rapides, il est facile d'itérer pour avancer.

**Domaine technique** : Kubernetes, YAML, parsing CSV - ces domaines sont bien couverts par le modèle

### Les alternatives considérées

Pour être transparent, j'ai également considéré :

- **GitHub Copilot** : excellent dans n'importe quel IDE (vscode, intellij, neovim...), mais j'ai vu les mêmes contraintes que Jetbrains Junie sur la limite des tokens d'utilisation.

- **Jetbrains Junie** : Très bon, mais plus orienté IDE Jetbrains (Intellij ou Goland). Il nécessite un abonnement supplémentaire à Intellij avec une limite sur les tokens qui peuvent être vite atteints.

- **Gemini** : Au début de l'expérimentation, seule la version web était disponible. C'est toujours réalisable, mais moins interactif avec l'IDE.
 
## Ce que j'ai appris de cette expérimentation

Les retours du panel ont confirmé plusieurs intuitions que nous avions eu pendant la phase de préparation:

### **Il n'y a pas "un seul" bon outil**

Le choix dépend du contexte, du projet, du profil du collaborateur. Chaque personne a une préférence pour son IDE, et aura une préférence sur son assistant de code préféré. En discutant avec mon ami Henri Gomez, il préfère nettement Gemini, alors que moi, c’est plutôt Claude.

### **L'expérimentation est clé**

Impossible de choisir sans tester en conditions réelles pour connaître les contraintes et limites de l'outil.

### **La courbe d'apprentissage compte** 

Même le meilleur outil est inutile si personne ne sait s'en servir. Comme tout nouvel outil, il faut comprendre comment s'en servir pour en utiliser ses capacités aux maximums et ne pas se cantonner à l'autocomplétion dans son IDE.

### **Le prompt engineering est crucial**

80% du succès vient de la façon dont vous guidez l'IA. Et cette compétence n'est pas forcément la plus facile à réaliser pour obtenir de bonnes performances.

## Et maintenant, place à l'action !

Maintenant que mon assistant de code était choisi, il était temps de coder mon application. Mais comment passer de l'idée à une CLI fonctionnelle sans se perdre dans des itérations sans fin ?

La réponse m'est venue d'une rencontre inattendue sur les réseaux sociaux et d'une méthodologie qui allait transformer ma façon de "vibe coder" : **Speckit** de Github.

Mais ça, c'est une autre histoire que je vous raconterai dans le prochain article.

👉 **[Lire la partie 3 : Vibe coding avec Speckit](#)** *(à venir)*

## Sources

- [Page Wikipedia sur Anthropic](https://fr.wikipedia.org/wiki/Anthropic)
- [Documentation officielle Claude Code](https://docs.anthropic.com/claude/docs)
- [Claude code : guide pour non tech](https://www.sfeir.dev/ia/guides-claude-code-france-2025/)
- [GitHub Spec Kit - Méthodologie de développement assisté par IA](https://github.com/github/spec-kit)
- [Site officiel de Diátaxis](https://diataxis.fr)
- [Site officiel WeScale](https://www.wescale.fr/)
- [Spécification agents.md](https://agents.md)
