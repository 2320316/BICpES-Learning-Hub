# Deployment Guide: BICpES Learning Hub on Vercel + Supabase

This guide walks you through deploying the refactored BICpES Learning Hub to production.

## 🎯 Prerequisites

- GitHub account with your repository
- Supabase account (free tier available)
- Vercel account (free tier available)
- Node.js 16+ installed locally

## 📊 Step 1: Prepare Supabase Database

### 1.1 Create Supabase Project

1. Visit [supabase.com](https://supabase.com)
2. Sign up/Login with your GitHub account
3. Click "New Project"
4. Fill in project details:
   - **Name**: `bicpes-learning-hub`
   - **Database Password**: Create a strong password
   - **Region**: Choose closest to your users
   - **Pricing**: Free tier is fine

### 1.2 Initialize Database Schema

1. Once project is created, go to **SQL Editor**
2. Click **New Query**
3. Copy the entire contents from `database/001_init.sql`
4. Paste into the editor
5. Click **Run**
6. Verify all tables are created: Check the **Table Editor**

### 1.3 Get Your Credentials

1. Go to **Project Settings** → **API**
2. Copy these values:
   - **Project URL** (e.g., `https://xxxxx.supabase.co`)
   - **anon public** key (for frontend use)
3. Save these for Vercel configuration

### 1.4 Configure Row Level Security (RLS)

Supabase has already enabled RLS in the SQL. Verify in **Authentication** → **Policies**:

- ✅ Projects are publicly readable
- ✅ Topics are publicly readable
- ✅ Tools are publicly readable
- ✅ User progress requires authentication

## 🚀 Step 2: Deploy to Vercel

### 2.1 Install Vercel CLI

```bash
npm install -g vercel
```

### 2.2 Prepare Repository

```bash
# Navigate to project root
cd BICpES-Learning-Hub

# Install dependencies
npm install

# Build locally to verify
npm run build
```

### 2.3 Deploy to Vercel

```bash
# Login to Vercel (opens browser)
vercel login

# Deploy (first time - will prompt for project setup)
vercel

# Answer prompts:
# - "Set up and deploy?": Yes
# - "Which scope?": Your account
# - "Link to existing project?": No
# - "What's your project's name?": bicpes-learning-hub
# - "In which directory is your code?": ./public
# - "Want to modify vercel.json?": Yes
```

### 2.4 Configure Environment Variables

**Option A: Via CLI**

```bash
vercel env add VITE_SUPABASE_URL
# Paste: https://xxxxx.supabase.co

vercel env add VITE_SUPABASE_ANON_KEY
# Paste: your anon public key
```

**Option B: Via Dashboard**

1. Go to [vercel.com/dashboard](https://vercel.com/dashboard)
2. Select your project
3. Go to **Settings** → **Environment Variables**
4. Add:
   - `VITE_SUPABASE_URL` = your Supabase URL
   - `VITE_SUPABASE_ANON_KEY` = your Supabase anon key

### 2.5 Redeploy with Environment Variables

```bash
vercel --prod
```

## ✅ Step 3: Verify Deployment

### 3.1 Test the Live Site

1. Your site will be available at a Vercel URL (e.g., `https://bicpes-learning-hub.vercel.app`)
2. Test core functionality:
   - ✅ Homepage loads
   - ✅ Projects display
   - ✅ Topics display
   - ✅ Login/Signup modal opens
   - ✅ Signup creates user
   - ✅ Login works

### 3.2 Monitor API

1. Go to Vercel Dashboard → Your Project → **Functions**
2. You should see:
   - `/api/projects`
   - `/api/topics`
   - `/api/simulation-tools`
   - `/api/auth/signup`
   - `/api/auth/login`

### 3.3 Check Browser Console

Open DevTools (F12) → Console:

- Should NOT see 401/CORS errors
- API responses should show in Network tab

## 🔗 Step 4: Setup Custom Domain (Optional)

1. Go to Vercel Project Settings → **Domains**
2. Add your custom domain
3. Follow DNS configuration instructions
4. SSL certificate auto-issues (free)

## 🛡️ Step 5: Security Checklist

- [ ] Environment variables set (not hardcoded)
- [ ] Supabase RLS policies verified
- [ ] API rate limiting considered
- [ ] HTTPS enforced (automatic on Vercel)
- [ ] Admin panel protected (implement if needed)
- [ ] User passwords hashed (done in signup.js)

## 📈 Step 6: Monitoring & Maintenance

### Monitor Supabase

1. Go to Supabase Dashboard → **Database Usage**
   - Check storage, auth, and query counts
   - Free tier includes: 500 MB storage, unlimited API calls
   - Generous free limits - suitable for production

### Monitor Vercel

1. Go to Vercel Dashboard → **Analytics**
   - Check function execution time
   - Monitor bandwidth usage
   - Free tier includes: 100 GB bandwidth/month

### Enable Logs

**Supabase Logs**:

1. Go to **Logs** → **API** or **Database** to monitor queries

**Vercel Logs**:

1. Go to **Settings** → **Environment** → View deployment logs

## 🔄 Updating Your Site

### Make Local Changes

```bash
# Edit files locally
# Update HTML/CSS/JS

# Test locally
npm run dev

# Build and push to GitHub
git add .
git commit -m "Update feature"
git push origin main
```

### Automatic Deployment

1. Vercel automatically deploys on `git push` to `main` branch
2. Deployment takes ~30-60 seconds
3. Check **Deployments** tab for status

### Manual Deployment

```bash
vercel --prod
```

## 📱 Mobile Testing

1. Deploy to Vercel first
2. Test on mobile device:
   - Responsive design works
   - Touch interactions work
   - Performance acceptable

```bash
# Test mobile viewport locally
npm run dev
# Open DevTools (F12) → Toggle Device Toolbar (Ctrl+Shift+M)
```

## 🆘 Troubleshooting

### Error: "Cannot reach Supabase"

**Solution**: Verify environment variables

```bash
vercel env list
```

Re-add if missing:

```bash
vercel env add VITE_SUPABASE_URL
vercel env add VITE_SUPABASE_ANON_KEY
vercel --prod
```

### Error: "501 Not Implemented"

**Solution**: API route not found

- Check function names match `/api/path/index.js`
- Redeploy: `vercel --prod`

### Error: "CORS error"

**Solution**: Headers already set in API

- Check `res.setHeader` in API routes
- Ensure no duplicate headers

### Projects/Topics not loading

**Solution**: Database might be empty

- Run `database/001_init.sql` again in Supabase SQL Editor
- Verify sample data inserted:
  ```sql
  SELECT COUNT(*) FROM projects;
  SELECT COUNT(*) FROM topics;
  ```

## 📞 Support

- **Supabase Docs**: https://supabase.com/docs
- **Vercel Docs**: https://vercel.com/docs
- **Project Issues**: Check GitHub Issues

---

**Deployment Complete!** 🎉

Your site is now live and production-ready. Continue to the Maintenance section in REFACTOR_README.md for ongoing updates.
