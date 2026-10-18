-- =====================================================================
--  Répétition générale — Studio Kanté
--  Colle ce script dans Supabase : SQL Editor → New query → Run.
--
--  Il installe une carte d'essai (16 plats) DANS LA BASE, sous le nom
--  court « essai ». Elle n'a pas de fichier dans /cartes/, donc elle est
--  servie par la base : c'est exactement le chemin d'un vrai client.
--
--  Ensuite tu pourras ouvrir studiokante.ma/espace/, changer un prix, et
--  le voir sur studiokante.ma/carte/?r=essai
--
--  Pour tout effacer après la répétition :
--      delete from public.restaurants where slug = 'essai';
-- =====================================================================

-- 1. la carte entre dans la base
select public.importer($fiche$
{
 "slug": "essai",
 "demo": true,
 "nom": {
  "fr": "Dar Sabra (essai)",
  "ar": "دار صبرة (تجربة)"
 },
 "tagline": {
  "fr": "Casablanca · Cuisine de marché",
  "ar": "الدار البيضاء · مطبخ السوق"
 },
 "heroSub": {
  "fr": "Ouvert aujourd'hui · 12h – 23h",
  "ar": "مفتوح اليوم · 12 – 23"
 },
 "wa": "212784161021",
 "ouvre": 12,
 "ferme": 23,
 "aide": {
  "adresse": {
   "fr": "12, rue des Oudayas, Anfa — Casablanca. On se gare sans trop de mal dans la rue derrière, surtout en semaine.",
   "ar": "12، زنقة الوداية، أنفا — الدار البيضاء. يمكن الركن بسهولة في الزنقة الخلفية، خاصة في أيام الأسبوع."
  },
  "payer": {
   "fr": "Espèces ou carte bancaire, sur place. Le service est compris dans les prix affichés.",
   "ar": "نقداً أو بالبطاقة البنكية، في عين المكان. الخدمة مشمولة في الأثمنة المعروضة."
  }
 },
 "sections": [
  {
   "id": "formule",
   "fr": "Formule du midi",
   "ar": "صيغة الغداء",
   "deal": true,
   "fr_t": "Entrée, plat et thé à la menthe",
   "ar_t": "مقبّلات، طبق رئيسي وأتاي بالنعناع",
   "fr_d": "Servie du lundi au vendredi, de 12h à 15h. Le plat change chaque jour selon le marché.",
   "ar_d": "تُقدَّم من الاثنين إلى الجمعة، من 12 إلى 15. الطبق يتغيّر يومياً حسب السوق.",
   "price": 95
  },
  {
   "id": "entrees",
   "fr": "Entrées",
   "ar": "المقبّلات",
   "items": [
    {
     "fr": "Harira",
     "ar": "الحريرة",
     "p": 35,
     "img": "/assets/plats/harira.jpg",
     "fd": "Tomate, lentilles, pois chiches, coriandre. Comme à la maison, servie très chaude.",
     "ad": "طماطم، عدس، حمّص وقزبر. كما في البيت، تُقدَّم ساخنة جداً.",
     "tags": [
      "veg"
     ]
    },
    {
     "fr": "Briouates au fromage",
     "ar": "بريوات بالجبن",
     "p": 45,
     "img": "/assets/plats/briouates.jpg",
     "fd": "Trois pièces croustillantes, fromage frais et menthe.",
     "ad": "ثلاث قطع مقرمشة، جبن طري ونعناع.",
     "tags": [
      "veg"
     ]
    },
    {
     "fr": "Zaalouk et pain maison",
     "ar": "زعلوك مع الخبز البلدي",
     "p": 40,
     "img": "/assets/plats/zaalouk.jpg",
     "fd": "Aubergines fondues à l'huile d'olive, ail et cumin.",
     "ad": "باذنجان مطبوخ بزيت الزيتون، ثوم وكمّون.",
     "tags": [
      "veg"
     ]
    },
    {
     "fr": "Salade d'oranges à la cannelle",
     "ar": "سلطة البرتقال بالقرفة",
     "p": 35,
     "img": "/assets/plats/salade-oranges.jpg",
     "fd": "Oranges de Berkane, fleur d'oranger, cannelle.",
     "ad": "برتقال بركان، ماء الزهر والقرفة.",
     "tags": [
      "veg"
     ]
    }
   ]
  },
  {
   "id": "plats",
   "fr": "Plats",
   "ar": "الأطباق الرئيسية",
   "items": [
    {
     "fr": "Tajine d'agneau aux pruneaux",
     "ar": "طاجين اللحم بالبرقوق",
     "p": 110,
     "img": "/assets/plats/tajine-agneau.jpg",
     "fd": "Épaule confite trois heures, pruneaux, amandes grillées, sésame.",
     "ad": "كتف مطهوّ ثلاث ساعات، برقوق، لوز محمّص وجنجلان."
    },
    {
     "fr": "Poulet mqualli au citron confit",
     "ar": "دجاج مقلّي بالحامض المصيَّر",
     "p": 95,
     "img": "/assets/plats/poulet-mqualli.jpg",
     "fd": "Poulet fermier, olives violettes, safran et gingembre.",
     "ad": "دجاج بلدي، زيتون، زعفران وسكنجبير."
    },
    {
     "fr": "Couscous du vendredi",
     "ar": "كسكس الجمعة",
     "p": 120,
     "img": "/assets/plats/couscous.jpg",
     "fd": "Sept légumes, semoule roulée à la main, bouillon léger. Le vendredi uniquement.",
     "ad": "سبعة خضار، كسكس مفتول باليد ومرق خفيف. يوم الجمعة فقط.",
     "tags": [
      "veg"
     ]
    },
    {
     "fr": "Dorade grillée à la chermoula",
     "ar": "الدوراد المشوي بالشرمولة",
     "p": 140,
     "img": "/assets/plats/dorade.jpg",
     "fd": "Pêche du jour de Casablanca, chermoula, citron, riz ou frites maison.",
     "ad": "صيد اليوم من الدار البيضاء، شرمولة، حامض، مع أرز أو بطاطس بيتية."
    },
    {
     "fr": "Kefta aux œufs",
     "ar": "كفتة بالبيض",
     "p": 85,
     "img": "/assets/plats/kefta.jpg",
     "fd": "Boulettes de bœuf au cumin, sauce tomate relevée, deux œufs.",
     "ad": "كرات لحم البقر بالكمّون، مرق طماطم حار وبيضتان.",
     "tags": [
      "hot"
     ]
    }
   ]
  },
  {
   "id": "desserts",
   "fr": "Desserts",
   "ar": "الحلويات",
   "items": [
    {
     "fr": "Pastilla au lait",
     "ar": "بسطيلة بالحليب",
     "p": 45,
     "img": "/assets/plats/pastilla.jpg",
     "fd": "Feuilles croustillantes, crème à la fleur d'oranger, amandes.",
     "ad": "أوراق مقرمشة، كريمة بماء الزهر ولوز.",
     "tags": [
      "veg"
     ]
    },
    {
     "fr": "Orange à la cannelle",
     "ar": "برتقال بالقرفة",
     "p": 30,
     "img": "/assets/plats/orange-cannelle.jpg",
     "fd": "Le dessert le plus simple de la maison, et le plus demandé.",
     "ad": "أبسط حلوى في الدار، وأكثرها طلباً.",
     "tags": [
      "veg"
     ]
    },
    {
     "fr": "Sellou",
     "ar": "السلو",
     "p": 35,
     "img": "/assets/plats/sellou.jpg",
     "fd": "Amandes, sésame, farine grillée, miel. Servi avec un verre de lait.",
     "ad": "لوز، جنجلان، دقيق محمّص وعسل. يُقدَّم مع كأس حليب.",
     "tags": [
      "veg"
     ]
    }
   ]
  },
  {
   "id": "boissons",
   "fr": "Boissons",
   "ar": "المشروبات",
   "items": [
    {
     "fr": "Thé à la menthe",
     "ar": "أتاي بالنعناع",
     "p": 20,
     "img": "/assets/plats/the-menthe.jpg",
     "fd": "Préparé à la commande, servi à la théière.",
     "ad": "يُحضَّر عند الطلب، ويُقدَّم في البرّاد.",
     "tags": [
      "veg"
     ]
    },
    {
     "fr": "Jus d'avocat",
     "ar": "عصير الأفوكادو",
     "p": 30,
     "img": "/assets/plats/jus-avocat.jpg",
     "fd": "Avocat, lait, amandes, un trait de miel.",
     "ad": "أفوكادو، حليب، لوز وقليل من العسل.",
     "tags": [
      "veg"
     ]
    },
    {
     "fr": "Café nous-nous",
     "ar": "قهوة نص نص",
     "p": 15,
     "img": "/assets/plats/cafe-nous-nous.jpg",
     "fd": "Moitié café, moitié lait, dans un verre.",
     "ad": "نصف قهوة ونصف حليب، في كأس.",
     "tags": [
      "veg"
     ]
    },
    {
     "fr": "Eau minérale 75 cl",
     "ar": "ماء معدني 75 سل",
     "p": 10,
     "img": "/assets/plats/eau.jpg",
     "fd": "Plate ou gazeuse.",
     "ad": "عادي أو غازي.",
     "tags": [
      "veg"
     ]
    }
   ]
  }
 ]
}
$fiche$::jsonb) as restaurant_cree;

-- 2. rattache TON compte à cette carte d'essai.
--    Remplace l'adresse ci-dessous par celle avec laquelle tu te connecteras
--    sur studiokante.ma/espace/ — et crée d'abord ce compte dans
--    Authentication → Users → Add user.
insert into public.membres (restaurant_id, user_id)
select r.id, u.id
from public.restaurants r, auth.users u
where r.slug = 'essai'
  and u.email = 'kaba1011bk@gmail.com'      -- ← à vérifier / remplacer
on conflict do nothing;

-- 3. vérifie tout de suite que la carte sort bien de la base
select
  (public.carte('essai') -> 'nom' ->> 'fr')                        as nom,
  jsonb_array_length(public.carte('essai') -> 'sections')          as nb_sections,
  (select count(*) from public.plats p
     join public.sections s on s.id = p.section_id
     join public.restaurants r on r.id = s.restaurant_id
    where r.slug = 'essai')                                        as nb_plats,
  (select count(*) from public.membres m
     join public.restaurants r on r.id = m.restaurant_id
    where r.slug = 'essai')                                        as comptes_rattaches;
