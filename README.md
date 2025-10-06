# Les Dauphins - Portail des Copropriétaires

Application web moderne pour la gestion de la copropriété Les Dauphins sur le Plateau Mont-Royal.

## 🚀 Démarrage rapide

### Prérequis

- Node.js 18+ installé
- Compte Supabase (gratuit sur [supabase.com](https://supabase.com))

### Installation

1. **Installer les dépendances**
   ```bash
   npm install
   ```

2. **Configurer Supabase**
   
   a. Créer un nouveau projet sur [supabase.com](https://supabase.com)
   
   b. Copier `.env.example` vers `.env`:
   ```bash
   copy .env.example .env
   ```
   
   c. Remplir les variables dans `.env` avec vos credentials Supabase:
   ```
   VITE_SUPABASE_URL=https://votre-projet.supabase.co
   VITE_SUPABASE_ANON_KEY=votre-clé-anonyme
   ```

3. **Lancer le serveur de développement**
   ```bash
   npm run dev
   ```

4. **Ouvrir dans votre navigateur**
   ```
   http://localhost:5173
   ```

## 📁 Structure du projet

```
Portal-LesDauphins/
├── src/
│   ├── pages/           # Pages de l'application
│   │   ├── LandingPage.tsx      # Page d'accueil publique
│   │   ├── LoginPage.tsx        # Page de connexion
│   │   └── MemberDashboard.tsx  # Portail des membres
│   ├── contexts/        # Contextes React (Auth, etc.)
│   ├── lib/            # Configuration (Supabase, etc.)
│   ├── App.tsx         # Router principal
│   ├── main.tsx        # Point d'entrée
│   └── index.css       # Styles globaux
├── docs/               # Documentation du projet
├── package.json
└── vite.config.ts
```

## 🔑 Prochaines étapes

### 1. Configuration Supabase (Urgent)

Vous devez créer les tables dans votre base de données Supabase. Utilisez les fichiers suivants:

1. **Base de données**: Créez les tables à partir de `typescript_interfaces.ts`
2. **Sécurité**: Appliquez les politiques RLS depuis `rls_policies.sql`

### 2. Créer un utilisateur de test

Dans Supabase Dashboard > Authentication > Users:
- Cliquez sur "Add user"
- Email: `test@lesdauphins.ca`
- Mot de passe: `TestPassword123!`

### 3. Tester l'application

1. Accéder à la page d'accueil: `http://localhost:5173`
2. Cliquer sur "Connexion" (en haut à droite)
3. Se connecter avec l'utilisateur de test
4. Explorer le portail des membres

## 🛠️ Technologies utilisées

- **React 18** - Framework UI
- **TypeScript** - Type safety
- **Vite** - Build tool ultra-rapide
- **Tailwind CSS** - Styling
- **Supabase** - Backend (Auth + Database)
- **React Router** - Navigation
- **Lucide React** - Icônes

## 📝 Développement

### Commandes disponibles

```bash
npm run dev      # Lancer le serveur de développement
npm run build    # Compiler pour production
npm run preview  # Prévisualiser le build de production
npm run lint     # Vérifier le code
```

### Ajouter une nouvelle page

1. Créer le composant dans `src/pages/`
2. Ajouter la route dans `src/App.tsx`
3. Ajouter le lien dans la navigation

## 🔐 Sécurité

- Les mots de passe ne sont JAMAIS stockés en clair
- Toutes les routes du portail sont protégées
- Row Level Security (RLS) activée sur toutes les tables
- Variables d'environnement pour les secrets

## 🚀 Déploiement

### Option 1: Vercel (Recommandé)

1. Push votre code sur GitHub
2. Connectez votre repo à [Vercel](https://vercel.com)
3. Ajoutez les variables d'environnement
4. Deploy!

### Option 2: Netlify

1. Build: `npm run build`
2. Publish directory: `dist`
3. Ajoutez les variables d'environnement

## 📞 Support

Pour toute question technique:
- Consultez la documentation dans `/docs`
- Référez-vous aux user stories dans `user_stories.md`
- Vérifiez les workflows dans `user_workflows.mermaid`

## 📄 Licence

© 2025 Les Dauphins - Tous droits réservés
