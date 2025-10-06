# 🚀 Supabase Database Setup Instructions

## Prerequisites Checklist
- ✅ Supabase project created
- ✅ `.env` file configured with credentials
- ⬜ Test user created in Supabase Authentication
- ⬜ User UID copied

## Step-by-Step Setup

### 1️⃣ Create Test User in Supabase

1. Go to: https://supabase.com/dashboard/project/npadhtykvehljagyggye/auth/users
2. Click **"Add user"** → **"Create new user"**
3. Enter:
   - Email: `test@lesdauphins.ca`
   - Password: `TestPassword123!`
   - ✅ Auto Confirm User
4. Click **"Create user"**
5. **COPY THE USER UID** - you'll need it in the next step!

### 2️⃣ Prepare the SQL Script

1. Open the file: `supabase_complete_setup.sql`
2. Find this line (near line 328):
   ```sql
   INSERT INTO public.users (id, email, full_name, phone, role)
   VALUES ('fdc1d3ce-495b-4bc0-8cfa-b1e997f9a029', 'test@lesdauphins.ca', ...
   ```
3. Replace `'fdc1d3ce-495b-4bc0-8cfa-b1e997f9a029'` with YOUR actual User UID

   **OR** use the automated script I'll create for you below.

### 3️⃣ Run the Database Setup

**Option A: Use the SQL Editor**

1. Go to: https://supabase.com/dashboard/project/npadhtykvehljagyggye/sql/new
2. Copy the ENTIRE contents of `supabase_complete_setup.sql` (after updating the User ID)
3. Paste into the SQL Editor
4. Click **"Run"** (or press Ctrl+Enter)
5. Wait for success message

**Option B: Use the automated setup script I'll create**

I'll create a PowerShell script that will do this automatically for you.

### 4️⃣ Verify the Setup

After running the SQL, verify everything worked:

1. Go to **Database** → **Tables** in Supabase
2. You should see these tables:
   - ✅ users
   - ✅ units
   - ✅ owners
   - ✅ accounts_receivable
   - ✅ service_requests
   - ✅ documents
   - ✅ communications
   - ✅ parking_spaces
   - ✅ lockers

3. Check the data:
   - **users** table: Should have 1 row (Jean Tremblay)
   - **units** table: Should have 6 rows
   - **accounts_receivable**: Should have 5 invoices

### 5️⃣ Test Your Application

1. Open terminal in your project folder
2. Run:
   ```powershell
   npm install
   npm run dev
   ```
3. Open browser to: `http://localhost:5173`
4. Click **"Connexion"**
5. Login with:
   - Email: `test@lesdauphins.ca`
   - Password: `TestPassword123!`
6. You should see the Member Dashboard! 🎉

## 🔍 Troubleshooting

### "User already exists" error
- The test user is already in auth.users, which is fine. The script handles this.

### "Row already exists" errors
- This means the data is already there. You can safely ignore these.

### "Cannot read properties of null"
- Make sure the User UID in the SQL matches the auth user exactly.

### Tables not appearing
- Make sure you ran the ENTIRE script
- Check for errors in the SQL Editor output

### Login fails
- Verify the user exists in Authentication → Users
- Verify the user exists in the `public.users` table
- Check that the email matches exactly

## 📞 Need Help?

If you encounter issues:
1. Check the browser console (F12) for errors
2. Check the Supabase logs (Logs section in dashboard)
3. Verify RLS policies are enabled on all tables

## ✅ Success Indicators

You'll know it worked when:
- ✅ You can login with test@lesdauphins.ca
- ✅ Dashboard shows "Jean Tremblay" and "Unité 201"
- ✅ You see 3 pending invoices totaling $635.00
- ✅ You see 3 service requests
- ✅ Documents page shows 2 documents

---

Ready to set up? Let's do it! 🚀
