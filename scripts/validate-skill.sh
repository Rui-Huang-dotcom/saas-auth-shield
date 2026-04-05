#!/bin/bash

# SaaS Auth Shield - Validation Script
# Validates the skill structure for a navigation-first skill with references/

set -e

echo "🔍 Validating SaaS Auth Shield..."
echo ""

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ERRORS=0
WARNINGS=0

check_file() {
  local path="$1"
  if [ -f "$path" ]; then
    echo -e "${GREEN}✓ $path${NC}"
  else
    echo -e "${RED}✗ Missing: $path${NC}"
    ((ERRORS++))
  fi
}

check_dir() {
  local path="$1"
  if [ -d "$path" ]; then
    echo -e "${GREEN}✓ $path/${NC}"
  else
    echo -e "${RED}✗ Missing: $path/${NC}"
    ((ERRORS++))
  fi
}

echo -e "${BLUE}📋 Checking required files...${NC}"
for file in SKILL.md README.md INSTALLATION.md template.md FILE_MANIFEST.md LICENSE .gitignore; do
  check_file "$file"
done

echo ""
echo -e "${BLUE}📁 Checking required directories...${NC}"
for dir in examples scripts references; do
  check_dir "$dir"
done

echo ""
echo -e "${BLUE}📚 Checking reference and example files...${NC}"
for file in \
  examples/example-output.md \
  references/env-setup.md \
  references/fingerprint-options.md \
  references/retrofit-guide.md \
  scripts/detect-project.sh \
  scripts/validate-skill.sh
  do
  check_file "$file"
  if [[ "$file" == *.sh ]] && [ -f "$file" ]; then
    if [ -x "$file" ]; then
      echo -e "${GREEN}  ✓ Executable${NC}"
    else
      echo -e "${YELLOW}  ⚠ Not executable (run: chmod +x $file)${NC}"
      ((WARNINGS++))
    fi
  fi
done

echo ""
echo -e "${BLUE}📊 Checking file sizes...${NC}"
if [ -f "SKILL.md" ]; then
  SIZE=$(wc -l < SKILL.md)
  if [ "$SIZE" -ge 60 ] && [ "$SIZE" -le 220 ]; then
    echo -e "${GREEN}✓ SKILL.md: $SIZE lines (good for a navigation-first skill)${NC}"
  elif [ "$SIZE" -lt 60 ]; then
    echo -e "${YELLOW}⚠ SKILL.md: $SIZE lines (may be too thin)${NC}"
    ((WARNINGS++))
  else
    echo -e "${YELLOW}⚠ SKILL.md: $SIZE lines (may be too long for a navigation-first skill)${NC}"
    ((WARNINGS++))
  fi
fi

for file in template.md examples/example-output.md references/env-setup.md references/fingerprint-options.md references/retrofit-guide.md; do
  if [ -f "$file" ]; then
    SIZE=$(wc -l < "$file")
    echo -e "${GREEN}✓ $file: $SIZE lines${NC}"
  fi
done

echo ""
echo -e "${BLUE}📝 Checking SKILL.md content...${NC}"
REQUIRED_SECTIONS=(
  "Overview"
  "Core Positioning"
  "What to Clarify"
  "Decision Path"
  "Default Implementation Strategy"
  "Reference Files"
  "Output Expectations"
)
for section in "${REQUIRED_SECTIONS[@]}"; do
  if grep -q "## $section" SKILL.md || grep -q "### $section" SKILL.md; then
    echo -e "${GREEN}✓ Section: $section${NC}"
  else
    echo -e "${RED}✗ Missing section: $section${NC}"
    ((ERRORS++))
  fi
done

echo ""
echo -e "${BLUE}🔗 Checking reference wiring...${NC}"
for ref in references/env-setup.md references/fingerprint-options.md references/retrofit-guide.md examples/example-output.md; do
  if grep -q "$ref" SKILL.md; then
    echo -e "${GREEN}✓ SKILL.md references $ref${NC}"
  else
    echo -e "${YELLOW}⚠ SKILL.md does not mention $ref${NC}"
    ((WARNINGS++))
  fi
done

echo ""
echo -e "${BLUE}🏷️  Checking frontmatter...${NC}"
if head -5 SKILL.md | grep -q "^name:"; then
  echo -e "${GREEN}✓ Skill name defined${NC}"
else
  echo -e "${RED}✗ Missing skill name in frontmatter${NC}"
  ((ERRORS++))
fi

if head -5 SKILL.md | grep -q "^description:"; then
  echo -e "${GREEN}✓ Skill description defined${NC}"
else
  echo -e "${RED}✗ Missing skill description in frontmatter${NC}"
  ((ERRORS++))
fi

echo ""
echo -e "${BLUE}🧭 Checking positioning language...${NC}"
if grep -qi "signup-abuse\|registration abuse\|multi-account" SKILL.md; then
  echo -e "${GREEN}✓ Core anti-abuse positioning is present${NC}"
else
  echo -e "${YELLOW}⚠ Core anti-abuse positioning is weak or missing${NC}"
  ((WARNINGS++))
fi

echo ""
echo -e "${BLUE}📋 Validation Summary${NC}"
echo "===================="
echo ""

if [ $ERRORS -eq 0 ]; then
  echo -e "${GREEN}✓ No errors found${NC}"
else
  echo -e "${RED}✗ Found $ERRORS error(s)${NC}"
fi

if [ $WARNINGS -eq 0 ]; then
  echo -e "${GREEN}✓ No warnings${NC}"
else
  echo -e "${YELLOW}⚠ Found $WARNINGS warning(s)${NC}"
fi

echo ""
if [ $ERRORS -eq 0 ]; then
  echo -e "${GREEN}✅ Skill validation PASSED${NC}"
  echo ""
  echo "The skill is ready for:"
  echo "  • Publication on GitHub"
  echo "  • Installation in Claude Code"
  echo "  • Installation in Codex CLI"
  echo "  • Further packaging/distribution"
  echo ""
  exit 0
else
  echo -e "${RED}❌ Skill validation FAILED${NC}"
  echo ""
  echo "Please fix the errors above before distributing the skill."
  echo ""
  exit 1
fi
