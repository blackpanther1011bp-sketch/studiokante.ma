/* ------------------------------------------------------------------
   Kit de publication — deux boutons par post.
   Copier la légende d'un geste plutôt que de la sélectionner au doigt,
   et enregistrer l'image sans passer par l'appui long.
   Ajouté après le chargement, en dehors du code de la page.
   ------------------------------------------------------------------ */
(function () {
  "use strict";

  var CSS =
    '.kit-outils{display:flex;flex-wrap:wrap;gap:8px;margin:14px 0 0}' +
    '.kit-outils button,.kit-outils a{display:inline-flex;align-items:center;gap:7px;cursor:pointer;' +
    'font:inherit;font-size:14px;font-weight:600;padding:10px 15px;border-radius:10px;text-decoration:none;' +
    'border:1.5px solid var(--sk-line,#d7d4c5);background:#fffdf8;color:var(--sk-ink,#141a14)}' +
    '.kit-outils button.fait{background:var(--sk-ink,#141a14);color:var(--sk-bone,#f3f1e9);border-color:var(--sk-ink,#141a14)}' +
    '.kit-outils button:active,.kit-outils a:active{transform:scale(.985)}' +
    '.kit-outils svg{width:16px;height:16px;flex:none}';

  var ICO_COPIE =
    '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">' +
    '<rect x="9" y="9" width="12" height="12" rx="2.2"/><path d="M5 15H4.2A1.2 1.2 0 0 1 3 13.8V4.2A1.2 1.2 0 0 1 4.2 3h9.6A1.2 1.2 0 0 1 15 4.2V5"/></svg>';
  var ICO_IMG =
    '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">' +
    '<path d="M12 3v12"/><path d="m7.5 10.5 4.5 4.5 4.5-4.5"/><path d="M4 17.5V19a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-1.5"/></svg>';

  function legende(post) {
    var cap = post.querySelector(".kit-cap");
    var tags = post.querySelector(".kit-tags");
    var t = cap ? cap.innerText.trim() : "";
    if (tags) t += "\n\n" + tags.innerText.trim();
    return t;
  }

  /* Repli pour les navigateurs sans presse-papiers : on sélectionne le texte,
     le geste « Copier » du téléphone prend le relais. */
  function copieDeSecours(txt) {
    var z = document.createElement("textarea");
    z.value = txt;
    z.setAttribute("readonly", "");
    z.style.cssText = "position:fixed;top:0;left:0;opacity:0";
    document.body.appendChild(z);
    z.select();
    var ok = false;
    try { ok = document.execCommand("copy"); } catch (e) { ok = false; }
    document.body.removeChild(z);
    return ok;
  }

  var styleMis = false;

  function monter() {
    var posts = document.querySelectorAll(".kit-post");
    if (!posts.length || document.querySelector(".kit-outils")) return;

    if (!styleMis) {
      var s = document.createElement("style");
      s.textContent = CSS;
      document.head.appendChild(s);
      styleMis = true;
    }

    posts.forEach(function (post, i) {
      var barre = document.createElement("div");
      barre.className = "kit-outils";

      var bc = document.createElement("button");
      bc.type = "button";
      bc.innerHTML = ICO_COPIE + "<span>Copier la légende</span>";
      bc.addEventListener("click", function () {
        var txt = legende(post);
        var dit = function (ok) {
          bc.querySelector("span").textContent = ok ? "Légende copiée" : "Copie impossible";
          bc.classList.toggle("fait", ok);
          setTimeout(function () {
            bc.querySelector("span").textContent = "Copier la légende";
            bc.classList.remove("fait");
          }, 1900);
        };
        if (navigator.clipboard && navigator.clipboard.writeText) {
          navigator.clipboard.writeText(txt).then(function () { dit(true); },
                                                  function () { dit(copieDeSecours(txt)); });
        } else {
          dit(copieDeSecours(txt));
        }
      });

      var img = post.querySelector(".kit-img");
      barre.appendChild(bc);

      if (img) {
        var a = document.createElement("a");
        a.href = img.getAttribute("src");
        a.setAttribute("download", "studio-kante-post-" + (i + 1) + ".jpg");
        a.innerHTML = ICO_IMG + "<span>Enregistrer l'image</span>";
        barre.appendChild(a);
      }

      (post.querySelector(".kit-tags") || post).insertAdjacentElement("afterend", barre);
    });
  }

  /* La page est rendue côté serveur puis reprise par React. Si on ajoute
     les boutons trop tôt, React les efface en reprenant la main — et se
     plaint d'une différence. On attend donc que la reprise soit passée,
     et on vérifie quelques fois qu'ils sont bien restés. */
  function lancer() {
    var essais = [400, 900, 1600, 2600, 4000];
    essais.forEach(function (ms) { setTimeout(monter, ms); });

    var cible = document.body;
    if (window.MutationObserver && cible) {
      var vu = new MutationObserver(function () {
        if (!document.querySelector(".kit-outils")) monter();
      });
      vu.observe(cible, { childList: true, subtree: true });
      setTimeout(function () { vu.disconnect(); }, 8000);
    }
  }

  if (document.readyState === "complete") lancer();
  else window.addEventListener("load", lancer);
})();
