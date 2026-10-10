/* ------------------------------------------------------------------
   Studio Kanté — l'assistant du site.
   Huit questions, huit réponses écrites d'avance. Rien n'est généré :
   les prix et les conditions viennent de la page elle-même, et doivent
   y rester identiques. Injecté après l'hydratation pour ne pas
   perturber le rendu de la page.
   ------------------------------------------------------------------ */
(function () {
  "use strict";

  var WA = "212784161021";

  var QUESTIONS = [
    {
      q: "Combien ça coûte ?",
      r: "Quatre formules, selon la taille de la maison :" +
         "<ul>" +
         "<li><b>Carte numérique</b> — 1 500 DH, puis 400 DH / mois</li>" +
         "<li><b>Essentiel</b> — 3 500 DH, puis 1 200 DH / mois</li>" +
         "<li><b>Complet</b> — 5 500 DH, puis 2 000 DH / mois</li>" +
         "<li><b>Signature</b> — 8 000 DH, puis 3 200 DH / mois</li>" +
         "</ul>" +
         "Moitié à la commande, moitié à la mise en ligne. L'entretien se règle le 1<sup>er</sup> du mois.",
      act: ["carte", "calcul"]
    },
    {
      q: "Qu'est-ce que je reçois ?",
      r: "Un site d'une page à votre nom, votre fiche Google remise en état, une séance photo chez vous, et des publications tous les mois. " +
         "Selon la formule s'ajoutent la carte numérique par QR code, des vidéos courtes, et le relevé mensuel des vues et des appels.",
      act: ["travail"]
    },
    {
      q: "En combien de temps ?",
      r: "<b>Dix jours</b> entre la première visite et la mise en ligne. " +
         "De votre côté, il y a deux moments où je vous demande de valider : une fois les textes, une fois le site avant publication. Le reste ne vous demande rien.",
      act: ["deroule"]
    },
    {
      q: "Le site m'appartient-il ?",
      r: "<b>Oui, entièrement.</b> Le nom de domaine est enregistré au nom du restaurant, pas au mien. " +
         "Si un jour vous travaillez avec quelqu'un d'autre, vous partez avec votre adresse et votre site. Je ne garde rien en otage."
    },
    {
      q: "Je n'ai pas de photos",
      r: "C'est prévu : la séance photo est comprise. Je viens chez vous, en lumière du jour, et je photographie <b>vos</b> plats — pas des images achetées. " +
         "Un restaurant se reconnaît à sa vraie salle et à sa vraie assiette.",
      act: ["travail"]
    },
    {
      q: "Et si je veux arrêter ?",
      r: "L'entretien mensuel est engagé <b>trois mois</b>, le temps que les effets soient visibles. Après, vous arrêtez quand vous voulez, sans justification et sans frais. " +
         "Le site et le nom de domaine restent les vôtres."
    },
    {
      q: "Je veux voir un exemple",
      r: "Voici une carte numérique complète, telle qu'un client la voit depuis sa table : en français et en arabe, avec la commande qui part sur WhatsApp. " +
         "Le restaurant est fictif, la carte fonctionne vraiment.",
      act: ["exemple", "demo"]
    },
    {
      q: "Parler à Kanté",
      r: "Avec plaisir. Écrivez-moi ou appelez-moi : je réponds moi-même. " +
         "La première visite dure vingt minutes, chez vous, et ne vous engage à rien.",
      act: ["wa", "tel"]
    }
  ];

  var LIENS = {
    wa:      { t: "Écrire sur WhatsApp", h: "https://wa.me/" + WA + "?text=" +
               encodeURIComponent("Bonjour Kanté, j'ai vu votre site et je voudrais en savoir plus."), ext: true },
    tel:     { t: "Appeler", h: "tel:+" + WA, sec: true },
    carte:   { t: "Voir les formules", h: "#carte", sec: true },
    calcul:  { t: "Calculer mon devis", h: "#calcul", sec: true },
    travail: { t: "Voir le travail", h: "#travail", sec: true },
    deroule: { t: "Voir le déroulé", h: "#deroule", sec: true },
    demo:    { t: "Voir la démonstration", h: "#demo", sec: true },
    exemple: { t: "Ouvrir la carte", h: "/carte-demo/", ext: true }
  };

  var CSS = [
    '.ska-fab{position:fixed;z-index:70;right:var(--sk-gut,20px);bottom:calc(18px + env(safe-area-inset-bottom));',
    'width:54px;height:54px;border-radius:50%;border:0;cursor:pointer;',
    'background:var(--sk-ink,#141a14);color:var(--sk-bone,#f3f1e9);',
    'display:flex;align-items:center;justify-content:center;box-shadow:0 6px 20px rgba(20,26,20,.3);transition:transform .12s}',
    '.ska-fab:active{transform:scale(.94)}',
    '.ska-fab svg{width:25px;height:25px}',
    '.ska-veil{position:fixed;inset:0;z-index:88;background:rgba(20,26,20,.55);opacity:0;pointer-events:none;transition:opacity .2s}',
    '.ska-veil.on{opacity:1;pointer-events:auto}',
    '.ska{position:fixed;left:0;right:0;bottom:0;z-index:90;background:var(--sk-bone,#f3f1e9);',
    'border-radius:18px 18px 0 0;padding:16px var(--sk-gut,20px) calc(14px + env(safe-area-inset-bottom));',
    'transform:translateY(102%);transition:transform .28s cubic-bezier(.2,.7,.3,1);',
    'max-height:86vh;display:flex;flex-direction:column;',
    'font-family:var(--sk-sans,"Hanken Grotesk",system-ui,sans-serif);color:var(--sk-ink,#141a14)}',
    '.ska.on{transform:translateY(0)}',
    '.ska-in{max-width:720px;margin:0 auto;width:100%;display:flex;flex-direction:column;min-height:0}',
    '.ska-h{display:flex;align-items:flex-start;justify-content:space-between;gap:12px;flex:none}',
    '.ska-h h2{font-family:var(--sk-display,"Fraunces",Georgia,serif);font-weight:600;font-size:23px;margin:0;letter-spacing:-.015em}',
    '.ska-h p{margin:3px 0 0;color:var(--sk-ink-soft,#55614f);font-size:13.5px;line-height:1.45}',
    '.ska-x{flex:none;width:34px;height:34px;border-radius:50%;cursor:pointer;background:#fffdf8;',
    'border:1px solid var(--sk-line,#d7d4c5);color:var(--sk-ink-soft,#55614f);font-size:19px;line-height:1}',
    '.ska-fil{flex:1;min-height:0;overflow-y:auto;-webkit-overflow-scrolling:touch;margin:14px 0 0}',
    '.ska-b{max-width:88%;padding:11px 14px;border-radius:14px;font-size:14.5px;line-height:1.55;margin:0 0 9px}',
    '.ska-b.q{background:var(--sk-ink,#141a14);color:var(--sk-bone,#f3f1e9);margin-left:auto;border-bottom-right-radius:5px}',
    '.ska-b.r{background:#fffdf8;border:1px solid var(--sk-line,#d7d4c5);border-bottom-left-radius:5px}',
    '.ska-b.r ul{margin:8px 0 0;padding-left:18px}',
    '.ska-b.r li{margin:4px 0}',
    '.ska-act{display:flex;flex-wrap:wrap;gap:8px;margin:11px 0 0}',
    '.ska-act a{display:inline-flex;align-items:center;gap:6px;background:var(--sk-ink,#141a14);color:var(--sk-bone,#f3f1e9);',
    'padding:8px 13px;border-radius:9px;font-size:13.5px;font-weight:600;text-decoration:none}',
    '.ska-act a.sec{background:transparent;border:1.5px solid var(--sk-line,#d7d4c5);color:var(--sk-ink,#141a14)}',
    '.ska-q{flex:none;display:flex;gap:8px;overflow-x:auto;padding:12px 0 2px;margin-top:4px;',
    'border-top:1px solid var(--sk-line,#d7d4c5);scrollbar-width:none}',
    '.ska-q::-webkit-scrollbar{display:none}',
    '.ska-q button{flex:none;cursor:pointer;background:#fffdf8;border:1px solid var(--sk-line,#d7d4c5);',
    'color:var(--sk-ink,#141a14);padding:9px 14px;border-radius:999px;font-size:13.5px;font-weight:600;white-space:nowrap;font-family:inherit}',
    '.ska-pied{flex:none;margin:9px 0 0;font-size:11.5px;color:var(--sk-ink-soft,#55614f);line-height:1.45}',
    '@media(min-width:48rem){.ska{left:auto;right:24px;bottom:24px;width:420px;border-radius:18px;max-height:min(640px,82vh);',
    'box-shadow:0 18px 50px rgba(20,26,20,.22)}',
    '.ska-fab{right:24px;bottom:24px}',
    '.ska-veil{display:none}}'
  ].join("");

  function el(t, c, h) {
    var e = document.createElement(t);
    if (c) e.className = c;
    if (h != null) e.innerHTML = h;
    return e;
  }

  function monter() {
    if (document.querySelector(".ska-fab")) return;

    var s = document.createElement("style");
    s.textContent = CSS;
    document.head.appendChild(s);

    var fab = el("button", "ska-fab",
      '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">' +
      '<path d="M21 11.5a8.4 8.4 0 0 1-9 8.4 9 9 0 0 1-3.9-.9L3 20.5l1.6-4.6A8.3 8.3 0 0 1 3.6 11.5a8.4 8.4 0 0 1 8.4-8.4 8.4 8.4 0 0 1 9 8.4z"/>' +
      '<path d="M9.6 9.3a2.4 2.4 0 0 1 4.7.8c0 1.6-2.4 2.4-2.4 2.4"/><path d="M12 15.6h.01"/></svg>');
    fab.type = "button";
    fab.setAttribute("aria-label", "Questions fréquentes");

    var veil = el("div", "ska-veil");

    var pan = el("div", "ska");
    pan.setAttribute("role", "dialog");
    pan.setAttribute("aria-modal", "true");
    pan.setAttribute("aria-label", "Questions fréquentes");
    pan.innerHTML =
      '<div class="ska-in">' +
developpe() +
      '</div>';

    document.body.appendChild(fab);
    document.body.appendChild(veil);
    document.body.appendChild(pan);

    var fil = pan.querySelector(".ska-fil");
    var barre = pan.querySelector(".ska-q");

    QUESTIONS.forEach(function (item, i) {
      var b = el("button", null, null);
      b.type = "button";
      b.textContent = item.q;
      b.addEventListener("click", function () { repondre(i); });
      barre.appendChild(b);
    });

    function bulle(cls, html) {
      var b = el("div", "ska-b " + cls, html);
      fil.appendChild(b);
      fil.scrollTop = fil.scrollHeight;
      return b;
    }

    function repondre(i) {
      var a = QUESTIONS[i];
      bulle("q", a.q);
      var txt = a.r;
      if (a.act && a.act.length) {
        txt += '<div class="ska-act">' + a.act.map(function (code) {
          var l = LIENS[code];
          if (!l) return "";
          return '<a class="' + (l.sec ? "sec" : "") + '" href="' + l.h + '"' +
                 (l.ext ? ' target="_blank" rel="noopener"' : "") +
                 (l.h.charAt(0) === "#" ? ' data-ferme="1"' : "") + '>' + l.t + "</a>";
        }).join("") + "</div>";
      }
      var b = bulle("r", txt);
      b.querySelectorAll("[data-ferme]").forEach(function (x) {
        x.addEventListener("click", fermer);
      });
    }

    function ouvrir() {
      veil.classList.add("on");
      pan.classList.add("on");
    }
    function fermer() {
      veil.classList.remove("on");
      pan.classList.remove("on");
    }

    fab.addEventListener("click", ouvrir);
    veil.addEventListener("click", fermer);
    pan.querySelector(".ska-x").addEventListener("click", fermer);
    document.addEventListener("keydown", function (e) {
      if (e.key === "Escape") fermer();
    });
    document.addEventListener("click", function (e) {
      if (!pan.classList.contains("on")) return;
      if (pan.contains(e.target) || fab.contains(e.target)) return;
      fermer();
    });

    bulle("r", "Bonjour. Voici ce qu'on me demande le plus souvent — choisissez une question en bas. " +
               "Et si vous ne trouvez pas, le dernier bouton me joint directement.");
  }

  function developpe() {
    return '<div class="ska-h">' +
             '<div>' +
               '<h2>Vos questions</h2>' +
               '<p>Les prix, les délais, ce qui vous appartient. Sans rendez-vous.</p>' +
             '</div>' +
             '<button class="ska-x" type="button" aria-label="Fermer">&times;</button>' +
           '</div>' +
           '<div class="ska-fil"></div>' +
           '<div class="ska-q"></div>' +
           '<p class="ska-pied">Réponses écrites à l\'avance. Rien n\'est généré automatiquement : ' +
           'pour tout le reste, vous tombez sur moi.</p>';
  }

  if (document.readyState === "complete") setTimeout(monter, 0);
  else window.addEventListener("load", function () { setTimeout(monter, 0); });
})();
