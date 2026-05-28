# BICpES Learning Hub - Refactored for Vercel + Supabase

This is the modernized version of BICpES Learning Hub, refactored from a PHP/MySQL monolith to a **serverless, cloud-native architecture** using:

- **Frontend**: Vercel (static hosting + serverless functions)
- **Database**: Supabase PostgreSQL
- **Authentication**: Supabase Auth

## 📂 Project Structure

```
BICpES-Learning-Hub/
├── public/                      # Frontend (deployed to Vercel)
│   ├── index.html              # Homepage
│   ├── pages/                  # HTML pages
│   │   ├── projects.html
│   │   ├── project.html
│   │   ├── topics.html
│   │   ├── topic.html
│   │   ├── user-panel.html
│   │   └── ...
│   ├── styles/                 # CSS organized by feature
│   │   ├── design.css
│   │   ├── user_design.css
│   │   ├── projects_design.css
│   │   └── ...
│   ├── js/                     # JavaScript modules
│   │   ├── auth.js            # Authentication
│   │   ├── db.js              # Database queries
│   │   ├── nav.js             # Navigation & forms
│   │   ├── main.js            # Homepage logic
│   │   └── supabase.js        # Supabase client config
│   ├── images/                # All images
│   │   ├── Logo/
│   │   ├── Projects/
│   │   ├── Skills/
│   │   ├── Topics/
│   │   └── Icons/
│   └── api/                    # Vercel serverless functions
│       ├── auth/
│       │   ├── login.js
│       │   └── signup.js
│       ├── projects/
│       │   ├── index.js
│       │   └── [...id].js
│       └── topics/
│
├── src/                        # Backend logic
│   ├── lib/                    # Utility functions
│   │   ├── auth.js
│   │   ├── db.js
│   │   └── email.js
│   └── middleware/
│
├── database/                   # Database migrations
│   └── 001_init.sql           # Supabase schema
│
├── package.json               # Dependencies
├── vercel.json                # Vercel configuration
├── .env.example               # Environment template
└── README.md                  # This file
```

## 🚀 Quick Start

### 1. **Setup Supabase**

1. Create a Supabase project at [supabase.com](https://supabase.com)
2. Go to SQL Editor and run the schema from `database/001_init.sql`
3. Note your:
   - Project URL
   - Anon Key (for frontend use)

### 2. **Environment Configuration**

```bash
cp .env.example .env.local
```

Edit `.env.local`:

```env
VITE_SUPABASE_URL=your_supabase_project_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
```

### 3. **Local Development**

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build
```

### 4. **Deploy to Vercel**

```bash
# Install Vercel CLI
npm install -g vercel

# Deploy
vercel
```

During deployment, configure environment variables in Vercel Dashboard:

- `VITE_SUPABASE_URL`
- `VITE_SUPABASE_ANON_KEY`

## 📋 API Routes (Serverless Functions)

### Authentication

- `POST /api/auth/signup` - Register new user
- `POST /api/auth/login` - Login user
- `POST /api/auth/logout` - Logout user

### Projects

- `GET /api/projects` - Get all projects (paginated)
- `GET /api/projects/:id` - Get project details
- `GET /api/projects/search?q=keyword` - Search projects

### Topics

- `GET /api/topics` - Get all topics (paginated)
- `GET /api/topics/:id` - Get topic details
- `GET /api/topics/search?q=keyword` - Search topics

### Tools

- `GET /api/simulation-tools` - Get all simulation tools

## 🔐 Security Best Practices

1. **Row Level Security (RLS)** - Enabled on all database tables
2. **Environment Variables** - Never commit `.env.local`
3. **HTTPS Only** - Enforced on Vercel
4. **CORS** - Configured for Vercel domain
5. **Input Validation** - All API endpoints validate input

## 📦 Database Schema

### Tables

- **users** - Student and admin accounts
- **projects** - Learning projects with components and procedures
- **topics** - Course topics and learning materials
- **simulation_tools** - External tools (Multisim, Tinkercad)
- **user_progress** - Track student progress

All tables use PostgreSQL with JSONB for structured data (components, activities).

## 🎨 Frontend Features

### Authentication

- Login/Signup modal
- Session management
- Role-based access (student/admin)

### Homepage

- Featured projects preview (3 items)
- Featured topics preview (3 items)
- Skills showcase with rotating images
- Simulation tools section
- About section
- Responsive design

### Dynamic Loading

- JavaScript fetches data from API
- No server-side rendering needed
- Works on Vercel's free tier

## 🔄 Migration from Old System

### What Changed

- ✅ No more PHP
- ✅ No more local MySQL
- ✅ No more session files
- ✅ Serverless architecture
- ✅ Global CDN distribution

### Data Migration

Run `database/001_init.sql` on your Supabase instance to create all tables with sample data.

## 🛠️ Maintenance

### Adding New Pages

1. Create HTML in `public/pages/yourpage.html`
2. Create JS module in `public/js/yourpage.js`
3. Import CSS from `public/styles/`
4. Add to navigation in `public/js/nav.js`

### Adding New API Routes

Create file: `public/api/your-endpoint/index.js`

Example:

```javascript
export default function handler(req, res) {
  if (req.method === "GET") {
    return res.status(200).json({ message: "Success" });
  }
  return res.status(405).json({ message: "Method not allowed" });
}
```

### Database Modifications

Create new migration file: `database/002_your_migration.sql`
Run in Supabase SQL Editor.

## 📱 Responsive Design

Optimized for:

- 📱 Mobile (320px+)
- 📱 Tablet (768px+)
- 💻 Desktop (1024px+)

CSS uses `clamp()` for fluid typography and layouts.

## 🚨 Troubleshooting

### "Cannot fetch data"

- Check Supabase URL and key in `.env.local`
- Verify database tables exist
- Check browser console for CORS errors

### "Login not working"

- Verify `/api/auth/login` endpoint exists
- Check Supabase authentication settings
- Ensure RLS policies allow public access for signup

### "Images not loading"

- Check image paths in `public/images/`
- Verify relative paths in HTML (use `images/` prefix)

## 📞 Support

For issues, check:

1. Supabase documentation: https://supabase.com/docs
2. Vercel documentation: https://vercel.com/docs
3. Project GitHub Issues

## 📄 License

MIT License - See LICENSE file

---

**Version**: 2.0.0 (Refactored for Vercel + Supabase)
**Last Updated**: May 2026
