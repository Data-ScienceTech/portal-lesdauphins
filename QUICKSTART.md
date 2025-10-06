# 🚀 Quick Start Guide - 5 Minutes to Launch!

## ✅ Prerequisites Done
- [x] Dependencies installed (`npm install`)
- [x] `.env` file configured with Supabase credentials

---

## 📝 Setup Steps

### Step 1: Run Database Migration (2 minutes)

1. Open your Supabase project dashboard
2. Go to **SQL Editor** (left sidebar)
3. Click **"+ New query"**
4. Copy the entire contents of `supabase_initial_migration.sql`
5. Paste into the editor
6. Click **"Run"** (or press Ctrl+Enter)
7. ✅ You should see "SUCCESS" messages

### Step 2: Create Test User (1 minute)

1. In Supabase, go to **Authentication** → **Users**
2. Click **"Add user"** → **"Create new user"**
3. Fill in:
   - **Email**: `test@lesdauphins.ca`
   - **Password**: `TestPassword123!`
   - **✅ Auto Confirm User**: CHECK THIS!
4. Click **"Create user"**
5. **IMPORTANT**: Copy the **User ID** (UUID) - you'll need it in the next step

### Step 3: Seed Sample Data (1 minute)

1. Open `supabase_seed_data.sql` in your editor
2. **Find and replace** ALL instances of `YOUR_AUTH_USER_ID` with the UUID you copied above
   - Use your editor's Find & Replace (Ctrl+H)
   - Replace: `YOUR_AUTH_USER_ID`
   - With: `the-uuid-you-copied` (e.g., `a1b2c3d4-5678-90ab-cdef-1234567890ab`)
3. Go back to Supabase **SQL Editor**
4. Create a **new query**
5. Copy the entire (modified) contents of `supabase_seed_data.sql`
6. Paste and **Run**
7. ✅ You should see success messages with summary

### Step 4: Launch the App! (30 seconds)

```bash
npm run dev
```

Open in browser: **http://localhost:5173**

---

## 🎉 Test Your Setup

### 1. Landing Page
- You should see the beautiful landing page
- Click **"connexion"** (top right)

### 2. Login
- **Email**: `test@lesdauphins.ca`
- **Password**: `TestPassword123!`
- Click **"Se connecter"**

### 3. Member Portal
You should see:
- ✅ Dashboard with welcome message
- ✅ **3 pending invoices** (Total: $635.00)
- ✅ **1 service request** in progress
- ✅ Recent communications
- ✅ Sidebar navigation

### 4. Explore
Click around:
- **Factures** - See all invoices (pending, paid, overdue)
- **Demandes** - View service requests
- **Mon profil** - Your profile info

---

## 🎯 What You Have Now

### Sample Data Created:
- **6 units** (101, 102, 201 in Tour Sud; 301, 401, 501 in Tour Nord)
- **1 owner**: Jean Tremblay (Unit 201)
- **5 invoices**: 3 pending, 1 paid, 1 overdue
- **3 service requests**: 1 submitted, 1 assigned, 1 completed
- **3 parking spaces**
- **3 storage lockers**
- **3 documents**
- **2 announcements**

---

## 🔧 Next Features to Build

Once everything is working, we can add:

1. **Invoice Details Page** - View and pay invoices
2. **Service Request Form** - Submit new requests with photos
3. **Document Library** - Browse and download documents
4. **Profile Management** - Edit contact info, parking, etc.
5. **Admin Portal** - Manage owners, create invoices
6. **Payment Integration** - Online payment processing

---

## ❓ Troubleshooting

### Can't login?
- ✅ Check that user exists in Supabase Auth > Users
- ✅ Verify "Email Confirm" is set to confirmed
- ✅ Check browser console (F12) for errors

### No data showing?
- ✅ Verify seed data was run successfully
- ✅ Check you replaced `YOUR_AUTH_USER_ID` correctly
- ✅ Open Supabase Table Editor and verify data exists

### RLS Policy errors?
- ✅ Make sure migration ran successfully
- ✅ Check that user exists in BOTH `auth.users` AND `public.users`

### Environment variables error?
- ✅ Verify `.env` file exists in project root
- ✅ Check values are correct (no quotes needed)
- ✅ Restart dev server after changing `.env`

---

## 📞 Ready to Continue?

Once you can login and see the dashboard with sample data, we're ready to build:
- Full invoice management
- Service request workflow
- Document uploads
- And more!

Let me know when it's working! 🚀
