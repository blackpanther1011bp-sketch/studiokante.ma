STUDIO KANTE - SITE EN VERSION AUTONOME
=======================================

Ce dossier EST ton site. Il ne depend plus de personne.
Il est pret pour GitHub Pages, et il marche aussi chez Netlify
ou Cloudflare si tu changes d'avis un jour.


CE QU'IL Y A DEDANS
-------------------
index.html      la page d'accueil (le site)
kit/index.html  la page /kit (tes neuf posts Instagram, non referencee)
assets/         toutes les photos, les polices, le style, le code
CNAME           contient studiokante.ma (ne pas supprimer)
.nojekyll       fichier technique, sans importance si ton PC le cache


METTRE EN LIGNE AVEC GITHUB PAGES
---------------------------------
1. Cree un compte gratuit sur  https://github.com/signup
2. Cree un depot (repository) vide, nom au choix, visibilite PUBLIC.
3. Dans le depot : Add file > Upload files.
   Glisse TOUT LE CONTENU de ce dossier (pas le dossier lui-meme :
   index.html doit se retrouver a la racine du depot).
   Puis Commit changes.
4. Onglet Settings > Pages.
   Source : Deploy from a branch.  Branch : main  /  (root).  Save.
5. Toujours dans Settings > Pages, champ Custom domain :
   tape  studiokante.ma  et valide.
6. Chez Nindohost, ouvre la zone DNS de studiokante.ma et cree :
      4 enregistrements A sur @   ->  185.199.108.153
                                      185.199.109.153
                                      185.199.110.153
                                      185.199.111.153
      1 enregistrement CNAME sur www  ->  TON-PSEUDO.github.io
7. Reviens dans Settings > Pages et coche  Enforce HTTPS
   (la case devient cliquable une fois le DNS propage).
8. Entre 1 heure et 24 heures plus tard, studiokante.ma affiche ton site,
   avec le cadenas HTTPS, gratuitement et sans limite de duree.


IMPORTANT
---------
- Le domaine studiokante.ma doit rester enregistre A TON NOM chez Nindohost.
- Ne supprime pas le dossier assets/ : sans lui, il n'y a plus de photos.
- Garde toujours une copie de ce dossier d'origine avant de modifier un texte.
- Si tu actives la double authentification sur GitHub (recommande),
  NOTE ET CONSERVE les codes de secours. Sans eux, un telephone perdu
  te ferme definitivement l'acces au compte.
