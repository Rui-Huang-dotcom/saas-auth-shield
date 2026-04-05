#!/bin/bash

# SaaS Auth Shield - Project Detection Script
# Detect current auth, database, and project shape to support migration decisions.

set -e

echo "🔍 Detecting project configuration..."
echo ""

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

DETECTED_AUTH=""
DETECTED_DB=""
DETECTED_UI=""
DETECTED_OAUTH=""
HAS_USER_SCHEMA="unknown"
HAS_AUTH_ROUTES="unknown"
HAS_EMAIL_STACK="no"
HAS_FINGERPRINTING="no"
PROJECT_TYPE="unknown"

if [ ! -f "package.json" ]; then
  echo -e "${RED}❌ Error: package.json not found${NC}"
  echo "Please run this script from your project root directory"
  exit 1
fi

echo -e "${BLUE}📦 Project Information${NC}"
PROJECT_NAME=$(grep -o '"name": "[^"]*' package.json | cut -d'"' -f4)
echo "Project name: ${PROJECT_NAME:-unknown}"
echo ""

echo -e "${BLUE}🔐 Checking authentication stack...${NC}"
if grep -q 'next-auth' package.json 2>/dev/null; then
  echo -e "${GREEN}✓ NextAuth detected${NC}"
  DETECTED_AUTH="nextauth"
fi
if grep -q '@clerk/nextjs' package.json 2>/dev/null; then
  echo -e "${GREEN}✓ Clerk detected${NC}"
  DETECTED_AUTH="clerk"
fi
if grep -q '@supabase/supabase-js' package.json 2>/dev/null && [ -z "$DETECTED_AUTH" ]; then
  echo -e "${GREEN}✓ Supabase SDK detected${NC}"
  DETECTED_AUTH="supabase-auth"
fi
if grep -q 'better-auth' package.json 2>/dev/null; then
  echo -e "${GREEN}✓ Better Auth detected${NC}"
  DETECTED_AUTH="better-auth"
fi
if grep -q 'firebase' package.json 2>/dev/null && [ -z "$DETECTED_AUTH" ]; then
  echo -e "${GREEN}✓ Firebase detected${NC}"
  DETECTED_AUTH="firebase"
fi
if grep -q '@auth0/nextjs-auth0' package.json 2>/dev/null; then
  echo -e "${GREEN}✓ Auth0 detected${NC}"
  DETECTED_AUTH="auth0"
fi

if [ -d "src/pages/api/auth" ] || [ -d "pages/api/auth" ] || [ -d "src/app/api/auth" ] || [ -d "app/api/auth" ]; then
  HAS_AUTH_ROUTES="yes"
  echo -e "${GREEN}✓ Auth route directory detected${NC}"
else
  HAS_AUTH_ROUTES="no"
  echo -e "${YELLOW}⚠ No obvious auth route directory detected${NC}"
fi

echo ""
echo -e "${BLUE}🗄️  Checking database / ORM...${NC}"
if grep -q 'drizzle-orm' package.json 2>/dev/null; then
  echo -e "${GREEN}✓ Drizzle ORM detected${NC}"
  DETECTED_DB="drizzle"
elif grep -q '@prisma/client' package.json 2>/dev/null; then
  echo -e "${GREEN}✓ Prisma detected${NC}"
  DETECTED_DB="prisma"
elif grep -q 'typeorm' package.json 2>/dev/null; then
  echo -e "${GREEN}✓ TypeORM detected${NC}"
  DETECTED_DB="typeorm"
elif grep -q 'sequelize' package.json 2>/dev/null; then
  echo -e "${GREEN}✓ Sequelize detected${NC}"
  DETECTED_DB="sequelize"
elif grep -q 'mongoose' package.json 2>/dev/null; then
  echo -e "${GREEN}✓ Mongoose detected${NC}"
  DETECTED_DB="mongoose"
else
  echo -e "${YELLOW}⚠ No obvious ORM/database package detected${NC}"
fi

if find . -maxdepth 4 \( -name 'schema.ts' -o -name 'schema.prisma' -o -name '*user*schema*' \) | grep -q .; then
  HAS_USER_SCHEMA="yes"
  echo -e "${GREEN}✓ User/auth-related schema file detected${NC}"
else
  HAS_USER_SCHEMA="no"
  echo -e "${YELLOW}⚠ No obvious user/auth-related schema file detected${NC}"
fi

echo ""
echo -e "${BLUE}🎨 Checking app stack...${NC}"
if grep -q 'next' package.json 2>/dev/null; then
  echo -e "${GREEN}✓ Next.js detected${NC}"
  DETECTED_UI="nextjs"
elif grep -q 'react' package.json 2>/dev/null; then
  echo -e "${GREEN}✓ React detected${NC}"
  DETECTED_UI="react"
else
  echo -e "${YELLOW}⚠ No React/Next.js dependency detected${NC}"
fi
if grep -q 'tailwindcss' package.json 2>/dev/null; then
  echo -e "${GREEN}✓ Tailwind CSS detected${NC}"
fi

echo ""
echo -e "${BLUE}🔑 Checking providers and related services...${NC}"
if grep -q 'google' package.json 2>/dev/null; then
  DETECTED_OAUTH="$DETECTED_OAUTH google"
  echo -e "${GREEN}✓ Google-related package detected${NC}"
fi
if grep -q 'github' package.json 2>/dev/null; then
  DETECTED_OAUTH="$DETECTED_OAUTH github"
  echo -e "${GREEN}✓ GitHub-related package detected${NC}"
fi
if grep -q 'discord' package.json 2>/dev/null; then
  DETECTED_OAUTH="$DETECTED_OAUTH discord"
  echo -e "${GREEN}✓ Discord-related package detected${NC}"
fi
if grep -q 'resend' package.json 2>/dev/null; then
  HAS_EMAIL_STACK="yes"
  echo -e "${GREEN}✓ Resend detected${NC}"
fi
if grep -qi 'fingerprintjs' package.json 2>/dev/null; then
  HAS_FINGERPRINTING="yes"
  echo -e "${GREEN}✓ FingerprintJS package detected${NC}"
fi

echo ""
if [ -z "$DETECTED_AUTH" ]; then
  if [ "$HAS_USER_SCHEMA" = "yes" ] || [ "$DETECTED_DB" != "" ]; then
    PROJECT_TYPE="existing-without-auth"
  else
    PROJECT_TYPE="new-project"
  fi
else
  PROJECT_TYPE="existing-with-auth"
fi

echo -e "${BLUE}📋 Detection Summary${NC}"
echo "===================="
echo ""
echo "Project type: $PROJECT_TYPE"
echo "Auth system: ${DETECTED_AUTH:-none}"
echo "Database/ORM: ${DETECTED_DB:-none}"
echo "UI stack: ${DETECTED_UI:-none}"
echo "OAuth hints: ${DETECTED_OAUTH:-none}"
echo "Auth routes present: $HAS_AUTH_ROUTES"
echo "User schema present: $HAS_USER_SCHEMA"
echo "Email stack present: $HAS_EMAIL_STACK"
echo "Fingerprinting present: $HAS_FINGERPRINTING"
echo ""

echo -e "${BLUE}🧭 Recommended path${NC}"
if [ "$PROJECT_TYPE" = "existing-with-auth" ]; then
  echo "- Read references/retrofit-guide.md before planning changes"
  echo "- Preserve current user/business logic where possible"
  echo "- Migrate auth only as far as needed to add maintainable signup-abuse controls"
elif [ "$PROJECT_TYPE" = "existing-without-auth" ]; then
  echo "- Add auth around the current app structure"
  echo "- Extend the existing schema instead of redesigning it"
  echo "- Add fingerprinting only if abuse prevention is actually needed"
else
  echo "- Start with the smallest useful auth setup"
  echo "- Add fingerprinting only if the product has signup-abuse risk"
fi

echo ""
REPORT_FILE="detection-report.json"
cat > "$REPORT_FILE" << EOF
{
  "projectName": "${PROJECT_NAME:-unknown}",
  "projectType": "$PROJECT_TYPE",
  "detectedAuth": "${DETECTED_AUTH:-}",
  "detectedDatabase": "${DETECTED_DB:-}",
  "detectedUI": "${DETECTED_UI:-}",
  "detectedOAuth": "${DETECTED_OAUTH# }",
  "hasAuthRoutes": "$HAS_AUTH_ROUTES",
  "hasUserSchema": "$HAS_USER_SCHEMA",
  "hasEmailStack": "$HAS_EMAIL_STACK",
  "hasFingerprinting": "$HAS_FINGERPRINTING",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF

echo -e "${GREEN}✓ Detection report saved to: $REPORT_FILE${NC}"
