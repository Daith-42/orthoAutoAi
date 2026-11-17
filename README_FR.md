# OrthoAutoAI

**OrthoAutoAI** est un correcteur orthographique et grammatical puissant et léger pour Windows, piloté par l'IA. Développé avec AutoHotkey et propulsé par le modèle Gemini 3.5 Flash-Lite de Google, il fonctionne universellement dans toutes les applications : Bloc-notes, Word, Discord, Navigateurs, et bien plus.

**Site web** : [daith-42.github.io/orthoAutoAi/fr/](https://daith-42.github.io/orthoAutoAi/fr/)

> 🐧 **Version Linux** : un portage communautaire (Python + GTK4, Wayland/Hyprland, X11) réalisé par
> [Kiliotsu](https://github.com/AbelQ11) est disponible sur
> [AbelQ11/orthoAutoAi-linux](https://github.com/AbelQ11/orthoAutoAi-linux).

## ✨ Fonctionnalités

- **Correction Universelle** : Sélectionnez du texte n'importe où, appuyez sur un raccourci (Défaut : `Alt + C`), et regardez-le se corriger instantanément.
- **Propulsé par l'IA** : Utilise Google Gemini 3.5 Flash-Lite pour des corrections contextuelles et une grande précision.
- **Support Multi-langues** : Entièrement traduit en **7 langues** : Anglais, Français, Espagnol, Allemand, Italien, Portugais et Roumain.
- **Historique** : Garde une trace de vos 5 dernières corrections dans un onglet dédié.
- **Confirmation Manuelle** : Mode optionnel pour valider les changements avant application.
- **Personnalisable** :
    -   Changez les raccourcis (Correction & Réglages).
    -   Activez/Désactivez le bip de confirmation.
    -   Intégration dans la barre des tâches (System Tray).
    -   Raccourcis de démarrage et sur le bureau.
- **Interface Moderne** : Interface de configuration épurée (Segoe UI).

## 🚀 Installation

1.  **Télécharger OrthoAutoAI** :
    Clonez ce dépôt ou téléchargez le ZIP.
2.  **Obtenir une Clé API Gemini** :
    -   Allez sur [Google AI Studio](https://aistudio.google.com/app/apikey).
    -   Créez une clé API gratuite.
3.  **Lancer l'Application** :
    Double-cliquez sur `OrthoAutoAI.exe` pour démarrer.
4.  **Configurer** :
    -   Au premier lancement, collez votre Clé API.
    -   Sélectionnez votre langue.

## 🛠️ Utilisation

### Correction Rapide
1.  **Sélectionnez** le texte à corriger.
2.  Appuyez sur **`Alt + C`** (ou votre raccourci configuré).
3.  Attendez un instant que l'IA analyse et remplace le texte.

### Configuration
1.  Appuyez sur **`Alt + W`** (ou clic-droit sur l'icône dans la barre des tâches et choisissez "Configuration").
2.  Ajustez les réglages :
    -   **Clé API** : Mettez à jour votre clé Gemini.
    -   **Raccourcis** : Personnalisez les touches.
    -   **Langue** : Changez la langue de l'interface.
    -   **Options** : Son, confirmation manuelle, démarrage automatique.
3.  **Onglet Historique** : Voir les corrections récentes.
4.  **Onglet Crédits** : Infos du projet et lien vers le site web.

## 🌐 Site Web

Le site vitrine se trouve dans le dossier [`site/`](site/), séparé de l'application. C'est une page
statique générée en 7 langues (EN, FR, ES, DE, IT, PT, RO), déployée sur GitHub Pages par GitHub Actions
à chaque push sur `main`. Voir [`site/README.md`](site/README.md) pour travailler dessus.

## 👤 Crédits

**Créé par** : Daith_42
**Version Linux** : [Kiliotsu](https://github.com/AbelQ11)
**Date** : Janvier 2026
**Propulsé par** : Google Gemini AI

---
*Avertissement : Cet outil n'est pas affilié à Google. Il utilise l'API Gemini qui nécessite une clé API personnelle.*
