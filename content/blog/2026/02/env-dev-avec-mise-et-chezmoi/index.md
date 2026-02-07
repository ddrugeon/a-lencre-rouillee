---
title: Mon environnement de développement avec mise et chez-moi
Date: 2026-02-07
created:
  2026-02-07
modified:
  2026-02-07
draft: false
author: David Drugeon-Hamon
tags:
  - blog
  - blog-article
  - mise
  - chezmoi
  - dotfiles
  - devtools
categorie: technique
date_publication:
date_publication_cible:
categories:
  - technique
description: "Comment gérer ses outils de développement et ses fichiers de configuration sur plusieurs machines et OS grâce au duo mise et chezmoi."
keywords:
  - mise
  - chezmoi
  - dotfiles
  - gestionnaire outils
  - configuration multi-machines
  - asahi linux
  - zsh
  - age
ShowToc: true
TocOpen: false
ShowReadingTime: true
ShowShareButtons: true
ShowPostNavLinks: true
ShowBreadCrumbs: true
ShowCodeCopyButtons: true
ShowWordCount: true
comments: false
statut: brouillon
---
<img src="/blog/2026/02/env-dev-avec-mise-et-chezmoi/banner.jpg" style="width: 100%; height: 400px; object-fit: cover; border-radius: 8px; margin-bottom: 2rem;">
<p style="font-size: 0.75rem; color: #666; margin-top: 0.5rem; margin-bottom: 2rem;">
Photo de <a href="https://unsplash.com/fr/@anastasiiachepinska" target="_blank" style="color: #999;">Anastasia Chepinska</a> sur <a href="https://unsplash.com/fr/photos/coussin-blanc-sur-canape-gris-mB__zsotOqY" target="_blank" style="color: #999;">Unsplash</a>
</p>

Depuis plusieurs mois, j'utilise différentes machines sous différents OS en fonction de l'activité : ordinateurs personnels sous MacOS ou Fedora (Merci [Asahi Linux](https://asahilinux.org)), et ordinateur professionnel sous Ubuntu 24.

Sur chaque environnement, j'installe les mêmes outils à savoir Zed, Neovim ou Intellij pour le développement, 1password comme gestionnaire de mots de passe sans compter Ghostty et zsh pour le terminal.

Je suis tombé alors sur une problématique simple : comment installer les outils sur les différents OS, comment répliquer leur configuration et les synchroniser.

Jusqu'à présent, j'utilisais essentiellement le combo [homebrew](https://brew.sh) + [asdf](https://github.com/asdf-vm/asdf) sur MacOS, et apt / dnf + asdf sur les environnements Linux pour l'installation des outils spécifiques au développement aussi bien les compilateurs, interpréteurs ou linter sans compter les outils d'IaC comme terraform ou Ansible. 

Quant à l'automatisation de mes projets, je comptais sur [Taskfile](https://taskfile.dev) en remplacement du Makefile.

Mais comment partager les fichiers de configuration entre mes machines ? J'ai eu l'idée d'utiliser un dépôt Git privé pour les stocker mais j'ai été vite confronté à un problème entre mes différentes versions de mes OS où les chemins par exemple n'étaient pas les mêmes.

C'est en discutant de cette problématique l'année passée avec Grégory Bloquel qu'il m'a soufflé à l'oreille un outil qu'il utilisait depuis longtemps : [chezmoi](https://www.chezmoi.io)

Actuellement, je développe aussi bien sur du Python, que du Golang voire même du Rust (pour le plaisir ?). [L'article de Julien Wittouck](https://codeka.io/2025/12/19/adieu-direnv-bonjour-mise/) est tombé au bon moment, ce fut l'occasion de tester cet outil couteau suisse qui remplacera aussi bien mon gestionnaire de version, mais aussi mon direnv, mon taskfile. Est-ce que [mise-en-place](https://mise.jdx.dev) est la solution idéale ?

Et si je combinais ces deux outils pour gérer mes environnements de développement ?

## Nouveau boulot = nouvel environnement

En commençant chez mon nouvel employeur, j'ai dû réinstaller mon environnement de travail sur mon mac sous Asahi Linux en attendant d'avoir un PC disponible pour pouvoir travailler.

> [!info]
> Asahi Linux est un projet de retro engineering pour documenter les puces Apple Silicon (à partir des séries M1) afin de porter facilement des OS alternatifs à MacOS comme Linux.
> 
> Il est ainsi possible dès à présent d'installer différentes distributions sur un Mac Sillicon et c'est plutôt fonctionnel même si tous les drivers spécifiques ne sont pas encore portés (par exemple, le port thunderbolt n'est pas exploité à sa puissance maximum).

Au bout de quelques jours, j'ai eu mon ordinateur professionnel et j'ai installé dessus une distribution Ubuntu pour pouvoir travailler sereinement. Mais recommencer à installer les outils, configurer son shell, ses alias et autres joyeusetés (sans compter sa configuration neovim) sur un PC tout neuf fut le déclencheur pour automatiser cette configuration.

Ni une ni deux, j'ai installé mise et chezmoi pour gérer ce nouvel environnement. 

## Par où commencer ?

### Installation
La première étape à faire est simplement d'installer mise. En fonction de l'OS, différentes options sont disponibles.

Par exemple, sur MacOS, la solution la plus simple est d'utiliser homebrew

```bash
brew install mise
```

ou sur Fedora, récupérer l'installer directement depuis le repo Copr

```bash
sudo dnf copr enable jdxcode/mise
sudo dnf install mise
```

Quant à un environnement sous Ubuntu, il est nécessaire de rajouter le dépôt debian avant de pouvoir l'installer

```bash
sudo apt update -y && sudo apt install -y curl
sudo install -dm 755 /etc/apt/keyrings
curl -fSs https://mise.jdx.dev/gpg-key.pub | sudo tee /etc/apt/keyrings/mise-archive-keyring.asc 1> /dev/null
echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.asc] https://mise.jdx.dev/deb stable main" | sudo tee /etc/apt/sources.list.d/mise.list
sudo apt update -y
sudo apt install -y mise
```

### Activation

Il est nécessaire d'activer mise dans son shell pour que les outils puissent être retrouvés.

Pour mon cas, travaillant avec un shell zsh, j'ai lancé cette commande pour rajouter l'activation dans mon shell:

```bash
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc
```

### Utilisation

Les commandes pour gérer les outils sont simples :

```bash
mise use --global <outil>@<version>
mise use -g <outil>@<version>
```


> [!note]
> Mise s'appuie sur plusieurs sources différentes pour installer un outil provenant d'écosystèmes totalement différents. C'est la force de cet outil qui centralise l'ensemble des sources d'installations possibles.
> Ainsi, il peut puiser sur plusieurs gestionnaires d'outils différents:
> - **core**: c'est une source pour les outils les plus courants (python, java, node...)
> - **aqua**: registre populaire de binaires
> - **asdf**: mise s'appuie sur les sources d'asdf pour installer des outils
> - **cargo**: pour l'installation de librairies ou binaires rust
> - **go**: pour l'installation de librairies ou binaires go
> - **npm**: pour les paquets node.js
> - **pipx**: pour les outils écrits en Python
> - **gem**: pour les outils écrits en Ruby
> - **github**: pour installer les outils en téléchargeant les binaires depuis github
> - **gitlab**: pour installer les outils en téléchargeant les binaires depuis gitlab
> - **ubi**: universal binary installer
> - **vfox**: plugin vfox
>  

Mise utilise un fichier de configuration `toml` où seront stockés les outils gérés et leurs versions. Ce fichier est disponible sur MacOS ou Linux dans le répertoire `~/.config/mise`. D'autres éléments peuvent être ajoutés pour les gérer globalement.

Pour les outils spécifiques à un projet donné, mise peut les gérer localement. Dans ce cas, il suffit de spécifier la commande suivante:

```bash
mise use <outil>@<version>
```

Un fichier `mise.toml` sera alors ajouté dans le répertoire du projet. Par exemple, voici un extrait de mon fichier de configuration sur un projet Python.

```toml
[tools]
uv = "0.9.24"
```


> [!note]
> Si vous avez des projets avec un fichier `.tools-version`, mise peut le lire pour installer automatiquement les outils. 
> Par défaut, mise s'appuie sur ses propres fichiers de configuration `mise.toml`ou `mise.local.toml`. Rien n'empêche d'ailleurs d'avoir les deux format de fichiers dans un projet. Mise utilisera alors cette priorité :
  >1. mise.toml / mise.local.toml
 > 2. .tool-versions

> [!tip]
> Pour gérer mes environnements Python, je préfère utiliser [uv](https://docs.astral.sh/uv/). Une configuration spécifique à mise permet de réutiliser les environnements virtuels gérés par uv.  Il faut alors ajouter dans son fichier de configuration global `~/.config/mise/config.toml`la section suivante:
> 
> ```toml
>[settings]
>python.uv_venv_auto = true
>```

Lorsque l'on clone un nouveau dépôt, pour des questions de sécurité, mise ne voudra pas installer les outils même si les fichiers de configuration sont présents. Il est nécessaire d'accorder la confiance au dépôt:

```bash
mise trust
```

Pour le moment, je n'utilise pas encore tout le potentiel de mise. J'ai déjà identifié des fonctionnalités comme la gestion des environnements et les tasks pour gérer les makefile que j'aimerais utiliser. Ce sera la prochaine étape dans mon workflow de développement.

## Comment partager mes fichiers de configuration ?

Une fois que j'ai une gestion de mes outils et de leurs versions, comment partager les fichiers de configuration entre mes différentes machines ?

C'est là qu'intervient `chezmoi` et c'est l'occasion de l'installer avec `mise` : 

```bash
mise use -g chezmoi@latest
```

La première chose à faire est de créer un dépôt Git privé pour les stocker. Par défaut, chezmoi créera un dépôt sur son compte Github s'il n'existe pas. Il suffit de lancer la commande 

```bash
chezmoi init <user>
```


> [!info]
> Il est tout à fait possible de stocker vos fichiers de configuration sur un autre type de serveur Git comme gitlab ou comme codeberg par exemple.
> dans ce cas, vous pouvez lancer l'initialisation avec l'url du serveur git sur lequel ils seront stockés.
> Exemple : `chezmoi init codeberg.org/<user>` si vous avez un compte sur codeberg.org

Le repo local sera alors stocké dans `~/.local/share/chezmoi`

J'utilise sur toutes mes machines zsh avec une configuration customisée. J'aimerais partager cette configuration sur les différentes machines que j'utilise. La première étape à faire est alors d'ajouter le fichier.

```bash
chezmoi add .zshrc
```

Maintenant, chezmoi gère le fichier que nous venons d'ajouter. Pour pouvoir le commiter dans son dépôt GIT, il suffit d'aller dans le dépôt local via la commande suivante:

```bash
chezmoi cd
```

Vous pouvez lister les fichiers dans le répertoire

```bash
ls -al

drwxr-xr-x@    - daviddrugeon-hamon  6 Feb 22:20  .git
.rw-r--r--@ 4.7k daviddrugeon-hamon 10 Jan 17:42  dot_zshrc
```


> [!info]
> Les fichiers que vous ajoutez dans le gestionnaire chezmoi sont renommés si ce sont des fichiers dotfiles

Il suffit alors de commiter le fichier et de le pousser sur le dépôt distant pour qu'il soit disponible depuis n'importe quelle machine.

```bash
git add dot_zshrc
git commit -m "ajout de la configuration zsh"
git push
```

### Le workflow au quotidien

Au quotidien, on ne modifie pas directement ses fichiers de configuration dans son `$HOME`. On passe par chezmoi pour garder la cohérence entre la copie de travail (celle dans votre `$HOME`) et la copie source gérée par chezmoi (celle dans le dépôt Git).

Pour éditer un fichier géré par chezmoi :

```bash
chezmoi edit ~/.zshrc
```

Cette commande ouvre la copie source du fichier dans votre éditeur. Une fois les modifications faites, vous pouvez visualiser les différences entre la copie source et la copie de travail :

```bash
chezmoi diff
```

Si les modifications vous conviennent, il suffit de les appliquer :

```bash
chezmoi apply
```

> [!tip]
> Si vous avez modifié directement un fichier dans votre `$HOME` (par exemple en changeant un paramètre via une interface graphique), vous pouvez mettre à jour la copie source avec :
> ```bash
> chezmoi re-add
> ```

Ensuite, il ne reste plus qu'à commiter et pousser les modifications :

```bash
chezmoi cd
git add .
git commit -m "mise à jour de la configuration zsh"
git push
```

> [!tip]
> Pour les plus pressés, chezmoi propose également des raccourcis pour intégrer le workflow Git directement. La commande `chezmoi git` permet de lancer des commandes Git sans avoir à se déplacer dans le dépôt :
> ```bash
> chezmoi git add .
> chezmoi git commit -- -m "mise à jour de la configuration zsh"
> chezmoi git push
> ```

### Récupérer sa configuration sur une nouvelle machine

C'est là que la magie opère. Sur une nouvelle machine, une fois chezmoi installé (via mise par exemple), il suffit de l'initialiser avec votre dépôt :

```bash
chezmoi init <user>
chezmoi apply
```

La première commande clone le dépôt, la seconde applique l'ensemble des fichiers de configuration sur la machine. En deux commandes, je me retrouve comme chez moi.

Par la suite, pour récupérer les dernières modifications poussées depuis une autre machine :

```bash
chezmoi update
```

Cette commande effectue un `git pull` sur le dépôt local puis applique les changements. C'est la commande que je lance en arrivant le matin lorsque je change de machine.

### Adapter sa configuration à chaque machine

C'est la fonctionnalité qui m'a vraiment convaincu. Comme je l'évoquais en introduction, le problème des chemins différents entre MacOS et Linux rendait difficile le partage brut des fichiers de configuration. Chezmoi résout élégamment ce problème grâce à son système de templates basé sur les [templates Go](https://pkg.go.dev/text/template).

Pour transformer un fichier géré en template, il suffit de l'ajouter avec l'option `--template` :

```bash
chezmoi add --template ~/.zshrc
```

Le fichier sera alors renommé `dot_zshrc.tmpl` dans le dépôt. On peut ensuite y utiliser des conditions basées sur l'OS, le nom de la machine, le nom d'utilisateur, etc.

Voici un exemple concret avec mon `.zshrc` :

```bash
# Configuration commune à toutes mes machines
export EDITOR="nvim"
alias ll="ls -la"

{{ if eq .chezmoi.os "darwin" -}}
# Configuration spécifique MacOS
export HOMEBREW_PREFIX="/opt/homebrew"
eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
{{ else if eq .chezmoi.os "linux" -}}
# Configuration spécifique Linux
{{ if eq .chezmoi.osRelease.id "fedora" -}}
# Spécifique Fedora / Asahi Linux
{{ else if eq .chezmoi.osRelease.id "ubuntu" -}}
# Spécifique Ubuntu
{{ end -}}
{{ end -}}

# Activation de mise (commun à tous les OS)
eval "$(mise activate zsh)"
```

Grâce aux templates, un seul fichier `.zshrc` s'adapte automatiquement à chacune de mes machines. Plus besoin de maintenir trois versions différentes.

> [!note]
> Chezmoi met à disposition de nombreuses variables exploitables dans les templates : `.chezmoi.os`, `.chezmoi.arch`, `.chezmoi.hostname`, `.chezmoi.osRelease.id` et bien d'autres. La liste complète est disponible dans la [documentation officielle](https://www.chezmoi.io/reference/templates/variables/).

On peut également définir ses propres variables dans le fichier de configuration de chezmoi `~/.config/chezmoi/chezmoi.toml` :

```toml
[data]
email = "mon@email.com"
machine_type = "perso"
```

Ces variables sont ensuite utilisables dans les templates via `{{ .email }}` ou `{{ .machine_type }}`. C'est pratique pour les informations qui varient d'une machine à l'autre sans forcément dépendre de l'OS, comme par exemple séparer la configuration de vos machines personnelles de celle de votre machine professionnelle.

> [!tip]
> Pour vérifier le rendu d'un template avant de l'appliquer, la commande `chezmoi cat` est très utile :
> ```bash
> chezmoi cat ~/.zshrc
> ```
> Elle affiche le contenu du fichier tel qu'il sera appliqué sur la machine courante.

### Protéger ses données sensibles

Mais comment protéger ses données sensibles qui se retrouveront sur le dépôt GIT ?
Que ce soient clés SSH, tokens d'API, fichiers de configuration contenant des mots de passe... Il ne faut pas les commiter sans les chiffrer.

Chezmoi propose un chiffrement intégré via [age](https://github.com/FiloSottile/age), un outil de chiffrement simple et moderne. La configuration se fait dans le fichier `~/.config/chezmoi/chezmoi.toml` :

```toml
encryption = "age"
[age]
identity = "~/.config/chezmoi/key.txt"
recipient = "age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```

La clé de chiffrement se génère en une commande :

```bash
age-keygen -o ~/.config/chezmoi/key.txt
```

> [!warning]
> La clé générée dans `key.txt` est votre **clé privée.** Elle ne doit **jamais** être commitée dans le dépôt. Pensez à la sauvegarder dans un endroit sûr comme un gestionnaire de mots de passe pour ne pas la perdre sinon vous ne pourrez plus déchiffrer vos secrets depuis le dépôt GIT.

Une fois configuré, il suffit d'ajouter un fichier avec l'option `--encrypt` pour qu'il soit chiffré dans le dépôt :

```bash
chezmoi add --encrypt ~/.ssh/config
```

Le fichier sera stocké chiffré dans le dépôt (avec le préfixe `encrypted_`) et déchiffré automatiquement lors du `chezmoi apply`. Le contenu en clair n'apparaît jamais dans l'historique Git.

> [!tip]
> chezmoi propose l'intégration de gestionnaires de mots de passe comme 1Password, Bitwarden ou pass par exemple. Il est possible de les intégrer directement via les templates.
> 
> Par exemple avec 1Password :
> ```bash
> {{ onepasswordRead "op://vault/item/field" }}
> ```
> Le secret sera alors injecté au moment de l'application du template sans jamais le stocker dans le dépôt, même chiffré.


## Le workflow complet

Pour résumer visuellement le fonctionnement des deux outils ensemble, voici le workflow que j'utilise au quotidien entre mes différentes machines :

![Workflow mise + chezmoi](/blog/2026/02/env-dev-avec-mise-et-chezmoi/workflow-mise-chezmoi.png)

## En conclusion

En bon SRE, j'ai commencé à automatiser les tâches répétitives et qui n'apportent aucune valeur. Jusqu'à présent, je gérais différemment mes versions des outils entre mes environnements professionnels et personnels. A l'aide de mise, je peux enfin spécifier les outils (et les versions) que j'utilise le plus fréquemment quelle que soit la machine sur laquelle je travaille. 
Avec chezmoi, je peux partager facilement mes fichiers de configuration et les adapter à chaque environnement grâce aux templates. C'est un gain de temps énorme surtout quand je dois basculer d'une machine à l'autre.

Je n'exploite pas encore toutes les possibilités de ces deux outils. Côté mise, j'aimerais creuser la gestion des tâches pour remplacer mes Taskfiles. 

Chezmoi propose d'autres fonctionnalités que je n'ai pas encore explorées mais c'est un outil qui me facilite la vie quand je jongle entre mes différentes machines. En effet, il suffit de l'installer avec mise puis de rajouter sa configuration dans chezmoi. Et bien entendu, la configuration de mise est aussi dans chezmoi, ce qui me permet de retrouver l'ensemble de mes outils entre les machines.

Alors, mise est-elle la solution idéale ? Ça dépend du contexte. Pour un développeur qui jongle entre plusieurs machines et plusieurs OS comme moi, le duo mise + chezmoi est redoutablement efficace. Pour quelqu'un qui travaille sur une seule machine avec un seul langage, c'est peut-être surdimensionné. Ce qui est certain, c'est que le temps investi à mettre en place ces outils s'est rentabilisé dès la deuxième machine configurée.

Et vous, qu'avez-vous mis en place pour gérer vos outils au quotidien ?
