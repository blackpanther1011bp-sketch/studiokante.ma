# Activer l'espace restaurant

Sept étapes. Compte une heure la première fois. Rien ici ne demande de
ligne de commande.

---

## 1. Créer le projet

Va sur **supabase.com**, crée un compte, puis un projet.

- **Region** : choisis l'Europe (`eu-west-1` ou `eu-central-1`). C'est le
  plus proche du Maroc — chaque milliseconde se voit sur le téléphone d'un
  client attablé.
- Note le mot de passe de la base qu'il te demande, mais **ne le mets
  nulle part dans le dépôt**. L'espace n'en a pas besoin.

## 2. Créer les tables

Projet → **SQL Editor** → **New query** → colle tout le contenu de
`base/schema.sql` → **Run**.

Le script est rejouable : si tu le relances, il ne casse rien.

Ce qu'il installe : quatre tables (`restaurants`, `membres`, `sections`,
`plats`), les règles d'accès, et deux fonctions — `carte(slug)` qui rend une
carte entière en un appel, et `importer(json)` qui avale un fichier de
l'atelier.

## 3. Brancher les pages

Projet → **Project Settings** → **API**. Copie deux valeurs dans
`espace/config.js` :

| Dans Supabase | Dans config.js |
|---|---|
| Project URL | `url` |
| `anon` `public` | `cle` |

**La clé `anon` est faite pour être publique.** Elle vit dans la page, tout
le monde peut la lire, et c'est normal : ce qui protège les données, ce sont
les règles de l'étape 2, pas le secret de cette clé.

**Ne mets jamais la clé `service_role` dans le dépôt.** Celle-là contourne
toutes les règles. Elle ne sort pas du tableau de bord.

Dépose `espace/config.js` modifié dans le dépôt comme n'importe quel autre
fichier.

## 4. Autoriser le retour du lien de connexion

Projet → **Authentication** → **URL Configuration** :

- **Site URL** : `https://studiokante.ma`
- **Redirect URLs** : ajoute `https://studiokante.ma/espace/`

Sans ça, le lien envoyé par courriel ne ramène pas le patron sur sa carte.

## 5. Faire entrer une carte

Tu as déjà la carte dans l'atelier. Télécharge la fiche, ouvre le fichier,
copie tout, puis dans le **SQL Editor** :

```sql
select public.importer('  ← colle le contenu du fichier ici  '::jsonb);
```

Attention aux apostrophes : si la carte en contient (et elle en contient),
double-les, ou utilise la syntaxe à dollars :

```sql
select public.importer($carte$  ← colle ici  $carte$::jsonb);
```

Vérifie tout de suite :

```sql
select public.carte('mazair');
```

## 6. Donner l'accès au patron

Deux temps.

**Créer son compte** : Authentication → **Users** → **Add user** →
*Send invitation* avec son adresse électronique.

**Le rattacher à sa carte** — c'est toi qui le fais, personne ne peut
s'ajouter tout seul :

```sql
insert into public.membres (restaurant_id, user_id)
select r.id, u.id
from public.restaurants r, auth.users u
where r.slug = 'mazair'
  and u.email = 'patron@mazair.ma';
```

## 7. Essayer

1. Ouvre `studiokante.ma/espace/`, entre l'adresse du patron, reçois le lien.
2. Change un prix. Le bandeau dit « Enregistré ».
3. Ouvre `studiokante.ma/carte/?r=mazair` : le nouveau prix est là.

---

## Ce que l'espace laisse faire au patron, et ce qu'il ne laisse pas

**Il peut** : changer un prix, marquer un plat en rupture et le remettre,
corriger un nom ou une description, en français et en arabe.

**Il ne peut pas** : ajouter un plat, changer une photo, créer ou
réorganiser une section. C'est volontaire — ces gestes passent par toi,
par l'atelier. Un patron qui réorganise sa carte à minuit casse sa carte à
minuit.

**Il ne peut pas non plus** toucher à la carte d'un autre restaurant. Je l'ai
vérifié : un compte connecté mais non rattaché obtient « 0 ligne modifiée »,
et ne voit même pas qu'il existe d'autres restaurants.

---

## Ce que ça coûte, et le piège à connaître

Le plan **gratuit** donne 500 Mo de base, 5 Go de trafic sortant et
50 000 utilisateurs actifs par mois. Largement assez : une carte pèse
quelques kilo-octets.

**Mais un projet gratuit est mis en pause après une semaine sans activité.**
Un projet en pause, ce sont toutes les cartes mortes en même temps. Tant
que des clients scannent les QR codes, il reste actif — mais un creux de
huit jours suffit à tout éteindre.

Donc : **dès le premier client qui paie, passe au plan Pro, 25 $ par mois.**
Ça fait environ 250 DH. Un seul abonnement à 400 DH par mois le couvre et
laisse de la marge. Ne fais pas tourner des cartes de clients payants sur
un projet qui peut s'arrêter tout seul.

Source : <https://supabase.com/pricing>

---

## Si quelque chose ne marche pas

| Ce que tu vois | Ce que c'est |
|---|---|
| « L'espace n'est pas encore branché » | `espace/config.js` est vide (étape 3) |
| Le lien par courriel ne revient pas sur la carte | Redirect URLs manquante (étape 4) |
| « Votre compte n'est rattaché à aucune carte » | Le `insert into membres` n'a pas été fait (étape 6) |
| « Cette carte n'existe pas encore » sur /carte/ | Ni fichier dans `cartes/`, ni ligne dans la base, ou `actif = false` |
| Un prix changé ne se voit pas | Recharge la carte : le navigateur peut servir la version gardée en mémoire |
