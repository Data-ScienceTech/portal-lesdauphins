# Guide de Configuration - Les Dauphins Portal

## ⚡ Configuration Rapide (15 minutes)

### Étape 1: Créer un projet Supabase

1. Allez sur [supabase.com](https://supabase.com)
2. Cliquez sur "Start your project"
3. Créez un nouveau projet:
   - **Nom**: `dauphins-portal`
   - **Database Password**: Notez-le en sécurité!
   - **Region**: `Northeast US (North Virginia)` ou plus proche
4. Attendez ~2 minutes que le projet soit créé

### Étape 2: Récupérer vos credentials

1. Dans votre projet Supabase, allez dans **Settings** > **API**
2. Copiez ces deux valeurs:
   - **Project URL**: `https://xxxxx.supabase.co`
   - **anon/public key**: `eyJhbGc...` (une longue clé)

### Étape 3: Configurer votre application

1. Dans le dossier du projet, copiez `.env.example` vers `.env`
2. Remplacez les valeurs:

```env
VITE_SUPABASE_URL=https://xxxxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGc...votre-longue-clé
```

### Étape 4: Créer les tables (BASE DE DONNÉES)

Dans Supabase Dashboard > **SQL Editor**, créez une nouvelle query et exécutez:

```sql
-- Table Users (simplified for now)
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT UNIQUE NOT NULL,
  full_name TEXT NOT NULL,
  role TEXT NOT NULL DEFAULT 'owner',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view their own profile
CREATE POLICY "Users can view own profile"
ON users FOR SELECT
USING (auth.uid()::text = id::text);
```

### Étape 5: Créer un utilisateur de test

1. Dans Supabase Dashboard > **Authentication** > **Users**
2. Cliquez sur **"Add user"** > **"Create new user"**
3. Remplissez:
   - **Email**: `test@lesdauphins.ca`
   - **Password**: `TestPassword123!`
   - **Auto Confirm User**: ✅ (coché)
4. Cliquez sur **Create user**

### Étape 6: Installer et lancer

```bash
# Installer les dépendances
npm install

# Lancer le serveur de développement
npm run dev
```

### Étape 7: Tester!

1. Ouvrez http://localhost:5173
2. Cliquez sur "connexion" en haut à droite
3. Connectez-vous avec:
   - Email: `test@lesdauphins.ca`
   - Password: `TestPassword123!`
4. Vous devriez voir le portail des membres! 🎉

---

## 🔧 Configuration Complète (pour production)

### Tables complètes

Pour créer TOUTES les tables du système, exécutez le script dans `rls_policies.sql` dans le SQL Editor de Supabase.

Les tables principales incluent:
- `users` - Utilisateurs et rôles
- `units` - Unités de la copropriété
- `owners` - Propriétaires
- `accounts_receivable` - Factures
- `service_requests` - Demandes de service
- `documents` - Bibliothèque de documents
- ... et 21 autres tables

### Storage Buckets

Créez les buckets de stockage dans Supabase:

1. Allez dans **Storage**
2. Créez ces buckets:
   - `documents` - Pour les PDFs, contrats, etc.
   - `photos` - Pour les photos de service requests
   - `invoices` - Pour les factures générées

### Politiques de sécurité

Appliquez toutes les politiques RLS depuis `rls_policies.sql` pour sécuriser les données.

---

## 🐛 Dépannage

### Erreur: "Missing Supabase environment variables"

✅ Vérifiez que votre fichier `.env` existe et contient les bonnes valeurs.

### Erreur lors de la connexion: "Invalid login credentials"

✅ Vérifiez que l'utilisateur existe dans Supabase Auth > Users  
✅ Confirmez que "Auto Confirm User" était coché lors de la création

### L'application ne se lance pas

```bash
# Supprimez node_modules et réinstallez
rm -rf node_modules
npm install
npm run dev
```

### Page blanche après connexion

✅ Vérifiez la console du navigateur (F12)  
✅ Vérifiez que les tables existent dans Supabase  
✅ Vérifiez que les politiques RLS sont configurées

---

## 📚 Ressources

- [Documentation Supabase](https://supabase.com/docs)
- [Documentation React](https://react.dev)
- [Documentation Vite](https://vitejs.dev)
- [Guide Tailwind CSS](https://tailwindcss.com/docs)

---

## ✅ Checklist de déploiement

Avant de déployer en production:

- [ ] Toutes les tables créées
- [ ] Politiques RLS appliquées
- [ ] Storage buckets configurés
- [ ] Variables d'environnement configurées sur Vercel/Netlify
- [ ] Domaine personnalisé configuré (optionnel)
- [ ] Backup automatique activé sur Supabase
- [ ] Utilisateurs réels créés et testés

---

Bon développement! 🚀
