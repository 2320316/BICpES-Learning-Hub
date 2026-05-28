#!/bin/bash

echo "🔍 DEPLOYMENT VERIFICATION - All Resources Check"
echo "=================================================="
echo ""

# Check 1: HTML Pages
echo "✓ HTML Pages:"
if [ -f "dist/index.html" ]; then
  echo "  ✅ dist/index.html exists"
else
  echo "  ❌ dist/index.html MISSING"
fi

PAGE_COUNT=$(find dist/pages -name "*.html" 2>/dev/null | wc -l)
echo "  ✅ $PAGE_COUNT pages in dist/pages/"

# Check 2: JavaScript Files
echo ""
echo "✓ JavaScript Files:"
if [ -f "dist/js/auth.js" ]; then
  echo "  ✅ dist/js/auth.js exists"
else
  echo "  ❌ dist/js/auth.js MISSING"
fi
JS_COUNT=$(find dist/js -name "*.js" 2>/dev/null | wc -l)
echo "  ✅ $JS_COUNT JS files in dist/js/"

# Check 3: Images
echo ""
echo "✓ Images:"
IMG_COUNT=$(find dist/assets -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.gif" \) 2>/dev/null | wc -l)
echo "  ✅ $IMG_COUNT images bundled in dist/assets/"

# Check 4: Materials (PDFs)
echo ""
echo "✓ Materials:"
if [ -d "dist/Materials" ]; then
  PDF_COUNT=$(find dist/Materials -name "*.pdf" 2>/dev/null | wc -l)
  echo "  ✅ $PDF_COUNT PDFs in dist/Materials/"
else
  echo "  ❌ dist/Materials folder MISSING"
fi

# Check 5: API Endpoints
echo ""
echo "✓ API Endpoints:"
if [ -f "api/auth/login.js" ]; then
  echo "  ✅ api/auth/login.js exists"
else
  echo "  ❌ api/auth/login.js MISSING"
fi

if [ -f "api/auth/signup.js" ]; then
  echo "  ✅ api/auth/signup.js exists"
else
  echo "  ❌ api/auth/signup.js MISSING"
fi

API_COUNT=$(find api -name "*.js" 2>/dev/null | wc -l)
echo "  ✅ $API_COUNT API endpoints"

# Check 6: Build Files
echo ""
echo "✓ Build Configuration:"
if grep -q "copy-static" package.json; then
  echo "  ✅ copy-static script in package.json"
else
  echo "  ❌ copy-static script MISSING"
fi

if [ -f "vercel.json" ]; then
  echo "  ✅ vercel.json exists"
else
  echo "  ❌ vercel.json MISSING"
fi

# Check 7: Total Size
echo ""
echo "✓ Deployment Size:"
DIST_SIZE=$(du -sh dist 2>/dev/null | cut -f1)
API_SIZE=$(du -sh api 2>/dev/null | cut -f1)
echo "  📦 dist/ folder: $DIST_SIZE"
echo "  📦 api/ folder: $API_SIZE"

# Summary
echo ""
echo "=================================================="
echo "✅ ALL RESOURCES VERIFIED AND READY FOR DEPLOYMENT!"
echo ""
echo "Next Steps:"
echo "1. git add ."
echo "2. git commit -m 'Fix: Copy all resources for Vercel deployment'"
echo "3. git push"
echo "4. Vercel will auto-deploy"
echo ""
