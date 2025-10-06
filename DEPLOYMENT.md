# 🚀 Deployment Guide - Les Dauphins Portal

This guide will walk you through deploying your Les Dauphins portal to Netlify with the subdomain `lesdauphins.datasciencetech.ca`.

---

## 📋 Prerequisites

- ✅ Netlify account (free at https://netlify.com)
- ✅ Git repository (GitHub, GitLab, or Bitbucket)
- ✅ Access to datasciencetech.ca DNS settings
- ✅ Supabase project credentials

---

## 🎯 Step 1: Prepare Your Repository

### 1.1 Initialize Git (if not already done)

```bash
git init
git add .
git commit -m "Initial commit: Les Dauphins portal with bilingual support and ocean theme"
```

### 1.2 Create a GitHub Repository

1. Go to https://github.com/new
2. Name: `portal-lesdauphins` (or your preferred name)
3. Don't initialize with README (you already have one)
4. Click "Create repository"

### 1.3 Push to GitHub

```bash
git remote add origin https://github.com/YOUR-USERNAME/portal-lesdauphins.git
git branch -M main
git push -u origin main
```

---

## 🌐 Step 2: Deploy to Netlify

### 2.1 Connect Your Repository

1. Log in to [Netlify](https://app.netlify.com)
2. Click **"Add new site"** → **"Import an existing project"**
3. Choose **GitHub** (or your git provider)
4. Authorize Netlify to access your repositories
5. Select your `portal-lesdauphins` repository

### 2.2 Configure Build Settings

Netlify should auto-detect these settings from `netlify.toml`, but verify:

- **Build command**: `npm run build`
- **Publish directory**: `dist`
- **Node version**: 18

### 2.3 Set Environment Variables

Before deploying, add your Supabase credentials:

1. In Netlify, go to **Site settings** → **Environment variables**
2. Click **"Add a variable"** and add these:

```
VITE_SUPABASE_URL = https://npadhtykvehljagyggye.supabase.co
VITE_SUPABASE_ANON_KEY = [Your Supabase Anon Key from .env file]
```

### 2.4 Deploy

Click **"Deploy site"** - Netlify will build and deploy your site!

Your site will be live at: `https://random-name-12345.netlify.app`

---

## 🔗 Step 3: Set Up Custom Subdomain

### 3.1 In Netlify

1. Go to **Site settings** → **Domain management**
2. Click **"Add custom domain"**
3. Enter: `lesdauphins.datasciencetech.ca`
4. Click **"Verify"**
5. Netlify will show you DNS configuration needed

### 3.2 Configure DNS at datasciencetech.ca

You'll need to add a CNAME record to your DNS provider:

**DNS Record to Add:**
```
Type:  CNAME
Name:  lesdauphins
Value: [your-netlify-site-name].netlify.app
TTL:   3600 (or automatic)
```

**Example:**
```
CNAME  lesdauphins  →  les-dauphins-portal.netlify.app
```

### 3.3 Where to Add DNS Record

Depending on where `datasciencetech.ca` DNS is managed:

**If using Netlify DNS:**
1. Go to Netlify Domains
2. Click on `datasciencetech.ca`
3. Add DNS record as shown above

**If using another provider (Cloudflare, GoDaddy, etc.):**
1. Log in to your DNS provider
2. Find DNS settings for `datasciencetech.ca`
3. Add the CNAME record

### 3.4 Enable HTTPS

1. Back in Netlify, under **Domain management**
2. Click **"Verify DNS configuration"**
3. Once verified, click **"Provision certificate"**
4. Netlify will automatically set up free HTTPS (Let's Encrypt)

**Wait 5-30 minutes for DNS propagation and SSL certificate provisioning.**

---

## ✅ Step 4: Verify Deployment

### Test Your Site

Visit these URLs to ensure everything works:

- **Landing Page**: https://lesdauphins.datasciencetech.ca/
- **Login Page**: https://lesdauphins.datasciencetech.ca/connexion
- **Dashboard**: https://lesdauphins.datasciencetech.ca/portail (after login)

### Test Credentials

```
Email:    test@lesdauphins.ca
Password: TestPassword123!
```

### Verify Features

- ✅ Language switcher (FR/EN) works
- ✅ Ocean theme colors display correctly
- ✅ Navigation between pages works
- ✅ Login authentication works
- ✅ Dashboard loads with data from Supabase
- ✅ HTTPS certificate is active (padlock in browser)

---

## 🔄 Continuous Deployment

After initial setup, every time you push to your `main` branch:

```bash
git add .
git commit -m "Update feature XYZ"
git push
```

Netlify will automatically:
1. Detect the push
2. Run `npm run build`
3. Deploy the new version
4. Update your site at `lesdauphins.datasciencetech.ca`

**Build time**: Usually 1-3 minutes

---

## 🛠️ Troubleshooting

### Build Fails on Netlify

**Check build logs** in Netlify:
- Look for missing dependencies
- Verify environment variables are set
- Ensure TypeScript compiles without errors

**Common fixes:**
```bash
# Locally test the production build
npm run build

# If it fails, fix errors and commit
git add .
git commit -m "Fix build errors"
git push
```

### Site Shows "Page Not Found" on Refresh

**Solution**: Already handled by `netlify.toml` redirects!

The SPA redirect rule ensures React Router works correctly.

### DNS Not Resolving

**Check DNS propagation:**
- Visit: https://dnschecker.org
- Enter: `lesdauphins.datasciencetech.ca`
- Verify CNAME points to your Netlify site

**Wait time**: DNS can take 5 minutes to 48 hours to propagate globally.

### HTTPS Certificate Not Provisioning

**Common causes:**
- DNS not fully propagated (wait longer)
- CNAME record incorrect (double-check value)
- CAA record blocking Let's Encrypt (check DNS settings)

**Solution**: Wait 30 minutes, then click "Retry" in Netlify domain settings.

### Supabase Connection Fails

**Check environment variables:**
1. Netlify: **Site settings** → **Environment variables**
2. Verify `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY`
3. If changed, click **"Trigger deploy"** → **"Clear cache and deploy"**

---

## 📊 Netlify Features to Explore

### Deploy Previews

Every pull request gets a preview URL - test changes before merging!

### Analytics

Enable **Netlify Analytics** to track:
- Page views
- Top pages
- Traffic sources
- Bandwidth usage

### Forms (Optional)

Add contact forms without backend code - Netlify handles submissions!

### Functions (Future)

Add serverless functions for:
- Custom API endpoints
- Scheduled tasks
- Webhooks

---

## 🔒 Security Checklist

- ✅ Environment variables stored in Netlify (not in code)
- ✅ `.env` file in `.gitignore`
- ✅ HTTPS enabled with valid certificate
- ✅ Security headers configured in `netlify.toml`
- ✅ Supabase RLS policies active
- ✅ CORS configured in Supabase for your domain

---

## 📝 Post-Deployment Checklist

- [ ] Site accessible at `lesdauphins.datasciencetech.ca`
- [ ] HTTPS working (green padlock)
- [ ] Login works with test credentials
- [ ] Language switcher (FR/EN) functional
- [ ] All pages load correctly
- [ ] Dashboard shows Supabase data
- [ ] Mobile responsive design works
- [ ] Console has no errors (F12 Developer Tools)

---

## 🎉 Success!

Your Les Dauphins portal is now live at:

**🌐 https://lesdauphins.datasciencetech.ca**

---

## 📞 Support

**Netlify Docs**: https://docs.netlify.com  
**Supabase Docs**: https://supabase.com/docs  
**Vite Docs**: https://vitejs.dev  

---

*Last updated: October 6, 2025*
