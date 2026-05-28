#!/bin/bash

# BICpES Learning Hub - Deployment Verification Script
# Run this before deploying to catch any issues

echo "🔍 BICpES Learning Hub - Deployment Verification"
echo "================================================"
echo ""

# 1. Check Node.js
echo "✓ Checking Node.js..."
if command -v node &> /dev/null; then
    echo "  ✅ Node.js: $(node --version)"
else
    echo "  ❌ Node.js not found"
    exit 1
fi

# 2. Check npm
echo "✓ Checking npm..."
if command -v npm &> /dev/null; then
    echo "  ✅ npm: $(npm --version)"
else
    echo "  ❌ npm not found"
    exit 1
fi

# 3. Check essential files
echo ""
echo "✓ Checking essential files..."
FILES=(
    "package.json"
    "vercel.json"
    "vite.config.js"
    ".env.example"
    "public/index.html"
    "database/001_init.sql"
)

for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file NOT FOUND"
        exit 1
    fi
done

# 4. Check API endpoints
echo ""
echo "✓ Checking API endpoints..."
API_ENDPOINTS=(
    "public/api/projects/index.js"
    "public/api/topics/index.js"
    "public/api/simulation-tools/index.js"
    "public/api/auth/login.js"
    "public/api/auth/signup.js"
)

for endpoint in "${API_ENDPOINTS[@]}"; do
    if [ -f "$endpoint" ]; then
        echo "  ✅ $endpoint"
    else
        echo "  ❌ $endpoint NOT FOUND"
        exit 1
    fi
done

# 5. Check HTML pages
echo ""
echo "✓ Checking HTML pages..."
PAGES=(
    "public/index.html"
    "public/pages/projects.html"
    "public/pages/topics.html"
    "public/pages/project.html"
    "public/pages/topic.html"
    "public/pages/multisim.html"
    "public/pages/tinkercad.html"
    "public/pages/user-profile.html"
)

for page in "${PAGES[@]}"; do
    if [ -f "$page" ]; then
        echo "  ✅ $page"
    else
        echo "  ❌ $page NOT FOUND"
        exit 1
    fi
done

# 6. Check JavaScript modules
echo ""
echo "✓ Checking JavaScript modules..."
JS_FILES=(
    "public/js/auth.js"
    "public/js/nav.js"
    "public/js/db.js"
    "public/js/main.js"
    "public/js/pages/projects.js"
    "public/js/pages/topics.js"
)

for js_file in "${JS_FILES[@]}"; do
    if [ -f "$js_file" ]; then
        echo "  ✅ $js_file"
    else
        echo "  ❌ $js_file NOT FOUND"
        exit 1
    fi
done

# 7. Check assets
echo ""
echo "✓ Checking assets..."
if [ -d "public/images" ]; then
    echo "  ✅ public/images/ ($(ls -1 public/images/ | wc -l) files)"
else
    echo "  ⚠️  public/images/ directory not found"
fi

if [ -d "public/Materials" ]; then
    echo "  ✅ public/Materials/ ($(ls -1 public/Materials/ | wc -l) files)"
else
    echo "  ⚠️  public/Materials/ directory not found (PDFs should be here)"
fi

# 8. Check npm dependencies
echo ""
echo "✓ Checking npm dependencies..."
if [ -d "node_modules" ]; then
    echo "  ✅ node_modules/ installed ($(ls -1 node_modules | wc -l) packages)"
else
    echo "  ❌ node_modules/ not found - run 'npm install'"
    exit 1
fi

# 9. Check build output
echo ""
echo "✓ Checking build output..."
if [ -d "dist" ]; then
    echo "  ✅ dist/ folder exists"
    echo "    - Size: $(du -sh dist | awk '{print $1}')"
    echo "    - HTML files: $(find dist -name '*.html' | wc -l)"
    echo "    - CSS files: $(find dist -name '*.css' | wc -l)"
    echo "    - Image files: $(find dist -name '*.{jpg,png,gif,svg}' | wc -l)"
else
    echo "  ⚠️  dist/ folder not found - run 'npm run build'"
fi

# 10. Check for .env.local
echo ""
echo "✓ Checking environment configuration..."
if [ -f ".env.local" ]; then
    echo "  ✅ .env.local found (make sure it has credentials)"
else
    echo "  ℹ️  .env.local not found (needed for local dev)"
    echo "     Copy .env.example to .env.local and fill in values"
fi

# 11. Summary
echo ""
echo "================================================"
echo "✅ VERIFICATION COMPLETE!"
echo ""
echo "Next steps for deployment:"
echo "1. Ensure Supabase project is created and schema initialized"
echo "2. Add VITE_SUPABASE_URL to Vercel environment variables"
echo "3. Add VITE_SUPABASE_ANON_KEY to Vercel environment variables"
echo "4. Add VITE_API_URL to Vercel environment variables"
echo "5. Deploy to Vercel: vercel --prod"
echo "6. Test all pages and endpoints on live deployment"
echo ""
echo "For more info: See DEPLOYMENT_READINESS_REPORT.md"
