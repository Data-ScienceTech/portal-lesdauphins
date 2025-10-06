# 🎯 Quick Setup Guide - Les Dauphins Portal Database

## You Have Two Options:

### ⚡ Option 1: Automated Setup (Recommended)

1. **Create the test user in Supabase** (required first):
   - Go to: https://supabase.com/dashboard/project/npadhtykvehljagyggye/auth/users
   - Click **"Add user"** → **"Create new user"**
   - Email: `test@lesdauphins.ca`
   - Password: `TestPassword123!`
   - ✅ Check "Auto Confirm User"
   - Click "Create user"
   - **Copy the User UID**

2. **Run the setup script**:
   ```powershell
   .\setup-database.ps1
   ```
   
3. **Follow the prompts**:
   - Paste your User UID when asked
   - The script will generate a custom SQL file
   - It will open your browser to Supabase SQL Editor
   - Copy the generated SQL and run it

4. **Test your app**:
   ```powershell
   npm run dev
   ```

---

### 📝 Option 2: Manual Setup

#### Step 1: Create Test User

1. Go to Supabase: https://supabase.com/dashboard/project/npadhtykvehljagyggye/auth/users
2. Click **"Add user"** → **"Create new user"**
3. Fill in:
   - Email: `test@lesdauphins.ca`
   - Password: `TestPassword123!`
   - ✅ Auto Confirm User
4. Click "Create user"
5. Click on the user to see details
6. **Copy the User UID** (looks like: `abc12345-1234-1234-1234-123456789abc`)

#### Step 2: Update the SQL File

1. Open `supabase_complete_setup.sql`
2. Press `Ctrl+F` to find: `fdc1d3ce-495b-4bc0-8cfa-b1e997f9a029`
3. **Replace ALL occurrences** with your actual User UID
4. Save the file

#### Step 3: Run the SQL

1. Go to SQL Editor: https://supabase.com/dashboard/project/npadhtykvehljagyggye/sql/new
2. Copy **ENTIRE contents** of `supabase_complete_setup.sql`
3. Paste into the SQL Editor
4. Click **"Run"** (or `Ctrl+Enter`)
5. Wait for "Success" message

#### Step 4: Test Your Application

```powershell
npm install
npm run dev
```

Then:
1. Open: http://localhost:5173
2. Click "Connexion"
3. Login:
   - Email: `test@lesdauphins.ca`
   - Password: `TestPassword123!`
4. You should see the dashboard! 🎉

---

## ✅ What Gets Created

### Database Tables (9 tables):
- `users` - User accounts with roles
- `units` - Condominium units (6 sample units)
- `owners` - Unit ownership records
- `accounts_receivable` - Invoices (5 samples)
- `service_requests` - Maintenance requests (3 samples)
- `documents` - Document library (2 samples)
- `communications` - Announcements (2 samples)
- `parking_spaces` - Parking info (3 samples)
- `lockers` - Storage lockers (3 samples)

### Sample Data:
- **User**: Jean Tremblay (test@lesdauphins.ca)
- **Unit**: 201, Tour Sud, 2nd floor
- **Invoices**: 
  - 3 pending ($635 total)
  - 1 paid
  - 1 overdue
- **Service Requests**:
  - 1 in progress (plumbing)
  - 1 submitted (electrical)
  - 1 completed (heating)

---

## 🔍 Verification Checklist

After running the SQL, verify in Supabase Dashboard:

### Check Tables (Database → Tables):
- [ ] `users` - 1 row
- [ ] `units` - 6 rows
- [ ] `owners` - 1 row
- [ ] `accounts_receivable` - 5 rows
- [ ] `service_requests` - 3 rows
- [ ] `parking_spaces` - 3 rows
- [ ] `lockers` - 3 rows
- [ ] `documents` - 2 rows
- [ ] `communications` - 2 rows

### Check Authentication:
- [ ] Go to Authentication → Users
- [ ] Verify `test@lesdauphins.ca` exists
- [ ] Status should be "Confirmed"

### Check RLS Policies:
- [ ] Go to Database → Tables → users → Policies
- [ ] Should see policies enabled

---

## 🐛 Common Issues

### Issue: "relation already exists"
**Solution**: Tables already exist. This is OK. Continue running the script.

### Issue: "duplicate key value"
**Solution**: Data already inserted. This is OK.

### Issue: Login fails
**Check**:
1. User exists in Authentication → Users
2. User ID matches in `public.users` table
3. Email is exact: `test@lesdauphins.ca`

### Issue: "No rows returned" or blank dashboard
**Check**:
1. RLS policies are enabled
2. User ID in SQL matches auth user
3. Owner record exists linking user to unit

### Issue: Can't see data after login
**Solution**:
1. Open browser console (F12)
2. Check for errors
3. Verify user_id in `owners` table matches auth user

---

## 🎉 Success Indicators

You'll know everything works when:
- ✅ Login successful
- ✅ Dashboard shows "Jean Tremblay"
- ✅ Shows "Unité 201"
- ✅ 3 pending invoices visible
- ✅ Service requests tab shows 3 requests
- ✅ Documents page shows 2 documents

---

## 🚀 Ready to Go!

Choose your option and let's get your database set up!

**Questions?** Check the troubleshooting section above or review the detailed instructions in `SUPABASE_SETUP_INSTRUCTIONS.md`.
