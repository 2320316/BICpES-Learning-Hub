# 🚀 QUICK START: Deploy BICpES to Vercel + Supabase

## Status: ✅ READY TO DEPLOY

All files are configured and verified. Follow these steps to deploy:

---

## STEP 1: Create Supabase Project (5 minutes)

1. Go to https://supabase.com
2. Click "Sign Up" → Use GitHub account
3. Click "New Project"
   - Name: `bicpes-learning-hub`
   - Region: Pick closest to your users
   - Database Password: Create strong password
4. Wait for project creation (2-3 minutes)
5. Copy these values:
   - **Project URL** (looks like: `https://xxxxx.supabase.co`)
   - **Anon Key** (under Settings → API)

---

## STEP 2: Initialize Database Schema (2 minutes)

1. In Supabase dashboard, go to **SQL Editor** → **New Query**
2. Open file: `database/001_init.sql`
3. Copy entire content
4. Paste into Supabase SQL editor
5. Click **Run**
6. Verify all tables created (go to **Table Editor** → check for users, projects, topics, simulation_tools, user_progress)

---

## STEP 3: Deploy to Vercel (5 minutes)

### Option A: Using Vercel CLI

```bash
# 1. Install Vercel CLI
npm install -g vercel

# 2. Login to Vercel
vercel login

# 3. Deploy
vercel --prod
```

### Option B: Using GitHub Integration (Recommended)

1. Go to https://vercel.com/new
2. Click "Continue with GitHub"
3. Search & select repo: `BICpES-Learning-Hub`
4. Click "Import"
5. **Leave all defaults** (Vercel auto-detects Vite)
6. Click "Deploy"

---

## STEP 4: Add Environment Variables to Vercel (2 minutes)

1. After deployment completes, go to Vercel Dashboard
2. Select your project: `BICpES-Learning-Hub`
3. Go to **Settings** → **Environment Variables**
4. Add these variables:

| Variable | Value | Example |
|----------|-------|---------|
| `VITE_SUPABASE_URL` | From Step 1 | `https://xxxxx.supabase.co` |
| `VITE_SUPABASE_ANON_KEY` | From Step 1 | `eyJhbGc...` |
| `VITE_API_URL` | Your Vercel domain | `https://bicpes.vercel.app/api` |

5. Click **Save**
6. Vercel will **automatically redeploy** with new env vars

---

## STEP 5: Test Your Deployment (3 minutes)

### Test Homepage
```
https://your-vercel-domain.vercel.app/
```
Should show: BICpES Learning Hub with hero section and preview cards

### Test Projects
```
https://your-vercel-domain.vercel.app/pages/projects.html
```
Should show: Projects list loading from Supabase

### Test API
```
In browser console (F12):
fetch('https://your-vercel-domain.vercel.app/api/projects')
  .then(r => r.json())
  .then(data => console.log(data))
```
Should show: JSON array of projects

### Test Login
1. Click "Start Learning" on homepage
2. Go to signup
3. Create test account (student number: 2321000, password: test123)
4. Should redirect to login page
5. Login with credentials
6. Should show authenticated nav with user profile

---

## TROUBLESHOOTING

### ❌ "API not responding"
- Check Vercel environment variables are set correctly
- Check Supabase URL and key are valid
- Check Supabase tables are created (run SQL schema again)

### ❌ "Database connection error"
- Verify VITE_SUPABASE_URL is correct
- Verify VITE_SUPABASE_ANON_KEY is correct
- Check Supabase project is active (not paused)

### ❌ "Images not loading"
- Images are bundled in dist/assets/ automatically
- If missing, rebuild: `npm run build`
- Check dist/ folder has assets

### ❌ "PDF materials not loading"
- PDFs need to be in `/public/Materials/` folder
- After pushing to git, they'll deploy with Vercel
- Check /Materials/ folder exists in repo

### ❌ "Login keeps redirecting to signup"
- Check database has sample data from 001_init.sql
- Try with admin: student_number=`ADMIN`, password=`admin123`
- Check browser console (F12) for errors

---

## VERIFY DEPLOYMENT

Run this script to verify everything is ready:

```bash
bash scripts/verify-deployment.sh
```

Should show all ✅ checks passing.

---

## LIVE SITE URLS

Once deployed, your site will be at:
```
https://bicpes.vercel.app/                    (Homepage)
https://bicpes.vercel.app/pages/projects.html  (Projects)
https://bicpes.vercel.app/pages/topics.html    (Topics)
https://bicpes.vercel.app/pages/project.html?id=1  (Project detail)
https://bicpes.vercel.app/pages/topic.html?id=1    (Topic detail)
```

---

## NEXT STEPS (Optional)

### Custom Domain
1. Vercel → Project → Settings → Domains
2. Add your custom domain
3. Update DNS records (Vercel shows instructions)

### Enable Google Analytics
1. Vercel → Project → Settings → Analytics
2. Connect Google Analytics account

### Monitor Performance
- Vercel Dashboard → Analytics
- Supabase Dashboard → Database → Queries

### Backup Database
- Supabase → Backups → Enable Auto-backup

---

## FILES INCLUDED

```
✅ 8 HTML pages (fully functional)
✅ 5 API endpoints (Vercel Functions)
✅ PostgreSQL schema (Supabase)
✅ All images and assets (optimized)
✅ All PDFs (5 learning materials)
✅ Authentication system
✅ Database integration
✅ Responsive design
```

---

## DOCUMENTATION

- **DEPLOYMENT_READINESS_REPORT.md** - Full technical details
- **PAGES_MIGRATION_SUMMARY.md** - All pages documented
- **DEPLOYMENT_GUIDE.md** - Original deployment guide
- **README.md** - Project overview

---

## SUPPORT

If you get stuck:

1. Check **DEPLOYMENT_READINESS_REPORT.md** (full details)
2. Run **scripts/verify-deployment.sh** (finds issues)
3. Check **DEPLOYMENT_GUIDE.md** (step-by-step)

---

## 🎉 Ready?

1. ✅ Supabase project created?
2. ✅ Database schema initialized?
3. ✅ Environment variables added to Vercel?
4. ✅ Deploy button clicked?

**Then your app is LIVE! 🚀**

Visit: `https://bicpes.vercel.app/`
