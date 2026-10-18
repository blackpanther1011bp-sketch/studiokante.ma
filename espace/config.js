/* --------------------------------------------------------------------
   Studio Kanté — branchement de la base

   Remplacez les deux valeurs ci-dessous par celles de votre projet
   Supabase : Project Settings → API.

   La « clé anon » est faite pour être publique : elle vit dans la page,
   tout le monde peut la lire, et c'est normal. Ce qui protège les
   données, c'est RLS (les règles du fichier base/schema.sql), pas le
   secret de cette clé.

   N'inscrivez JAMAIS ici la clé « service_role » : celle-là contourne
   toutes les règles. Elle ne doit jamais sortir du tableau de bord.
   -------------------------------------------------------------------- */
window.SK_BASE = {
  url:  "",   // ex. https://abcdefghijklm.supabase.co
  cle:  ""    // la clé « anon public »
};
