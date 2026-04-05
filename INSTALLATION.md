# Installation Guide - SaaS Auth Shield

This guide explains how to install and use the SaaS Auth Shield in your AI editor.

---

## 📋 Prerequisites

- **Claude Code** (Anthropic's Claude 3.5+) OR **OpenAI Codex CLI**
- **Git** (for cloning the repository)
- **Basic command line knowledge**

---

## 🚀 Installation Methods

### Method 1: Claude Code (Recommended)

#### Step 1: Clone the Repository

```bash
git clone https://github.com/Rui-Huang-dotcom/saas-auth-shield.git
cd saas-auth-shield
```

#### Step 2: Find Your Skills Directory

**macOS/Linux:**
```bash
mkdir -p ~/.claude/skills
```

**Windows (PowerShell):**
```powershell
New-Item -ItemType Directory -Path "$env:USERPROFILE\.claude\skills" -Force
```

#### Step 3: Copy the Skill

**macOS/Linux:**
```bash
cp -r . ~/.claude/skills/saas-auth-shield/
```

**Windows (PowerShell):**
```powershell
Copy-Item -Path "." -Destination "$env:USERPROFILE\.claude\skills\saas-auth-shield\" -Recurse
```

#### Step 4: Verify Installation

```bash
ls ~/.claude/skills/saas-auth-shield/
```

You should see:
```
SKILL.md
README.md
template.md
examples/
scripts/
LICENSE
.gitignore
```

#### Step 5: Use in Claude Code

1. Open Claude Code
2. Start a new project or open an existing one
3. Type in the chat: **"I need to add authentication to my Next.js app"**
4. Claude will automatically discover and use the skill

---

### Method 2: OpenAI Codex CLI

#### Step 1: Clone the Repository

```bash
git clone https://github.com/Rui-Huang-dotcom/saas-auth-shield.git
cd saas-auth-shield
```

#### Step 2: Find Your Codex Skills Directory

**macOS/Linux:**
```bash
mkdir -p ~/.codex/skills
```

**Windows (PowerShell):**
```powershell
New-Item -ItemType Directory -Path "$env:USERPROFILE\.codex\skills" -Force
```

#### Step 3: Copy the Skill

**macOS/Linux:**
```bash
cp -r . ~/.codex/skills/saas-auth-shield/
```

**Windows (PowerShell):**
```powershell
Copy-Item -Path "." -Destination "$env:USERPROFILE\.codex\skills\saas-auth-shield\" -Recurse
```

#### Step 4: Use in Codex CLI

```bash
codex --skill saas-auth-shield "Add authentication to my project"
```

---

### Method 3: Manual Installation (No Git)

#### Step 1: Download the Archive

Download one of these files:
- `saas-auth-shield-skill.zip` (for Windows)
- `saas-auth-shield-skill.tar.gz` (for macOS/Linux)

#### Step 2: Extract the Archive

**Windows:**
- Right-click the ZIP file
- Select "Extract All..."
- Choose extraction location

**macOS/Linux:**
```bash
tar -xzf saas-auth-shield-skill.tar.gz
```

#### Step 3: Move to Skills Directory

**Windows (PowerShell):**
```powershell
Move-Item -Path "saas-auth-shield" -Destination "$env:USERPROFILE\.claude\skills\saas-auth-shield" -Force
```

**macOS/Linux:**
```bash
mv saas-auth-shield ~/.claude/skills/saas-auth-shield
```

#### Step 4: Verify

Check that all files are in place:
```bash
ls ~/.claude/skills/saas-auth-shield/
```

---

### Method 4: Git Submodule (For Projects)

If you want to keep the skill updated within your project:

```bash
# Add as submodule
git submodule add https://github.com/Rui-Huang-dotcom/saas-auth-shield.git .claude/skills/saas-auth-shield

# Update submodule
git submodule update --remote
```

---

## ✅ Verification

### Check Installation

```bash
# List installed skills
ls ~/.claude/skills/

# Verify SaaS Auth Shield
ls ~/.claude/skills/saas-auth-shield/
```

### Validate Skill Structure

```bash
cd ~/.claude/skills/saas-auth-shield
bash scripts/validate-skill.sh
```

Expected output:
```
✅ Skill validation PASSED
The skill is ready for:
  • Publication on GitHub
  • Installation in Claude Code
  • Installation in Codex CLI
```

---

## 🎯 First Use

### In Claude Code

1. **Open Claude Code**
2. **Create a new project or open existing**
3. **Type in chat:**
   ```
   I need to add authentication to my Next.js app with:
   - Email + password login
   - Google OAuth
   - Device fingerprinting for fraud prevention
   ```
4. **Claude will:**
   - Detect your project type
   - Ask clarification questions
   - Generate complete authentication system

### In Codex CLI

```bash
codex --skill saas-auth-shield "Add authentication with fingerprinting to my Next.js app"
```

---

## 🔄 Updating the Skill

### If Installed via Git

```bash
cd ~/.claude/skills/saas-auth-shield
git pull origin main
```

### If Installed via Submodule

```bash
git submodule update --remote
```

### If Installed Manually

1. Download the latest archive
2. Extract to a temporary location
3. Copy files to `~/.claude/skills/saas-auth-shield/`
4. Verify with `validate-skill.sh`

---

## 🐛 Troubleshooting

### Issue: Skill Not Discovered

**Problem:** Claude Code doesn't recognize the skill

**Solution:**
1. Verify file location: `~/.claude/skills/saas-auth-shield/SKILL.md`
2. Check file permissions: `chmod 644 ~/.claude/skills/saas-auth-shield/SKILL.md`
3. Restart Claude Code
4. Run validation: `bash scripts/validate-skill.sh`

### Issue: Permission Denied

**Problem:** Can't execute shell scripts

**Solution:**
```bash
chmod +x ~/.claude/skills/saas-auth-shield/scripts/*.sh
```

### Issue: Path Not Found

**Problem:** Skills directory doesn't exist

**Solution:**
```bash
# Create the directory
mkdir -p ~/.claude/skills

# Verify it exists
ls -la ~/.claude/
```

### Issue: On Windows, Scripts Don't Run

**Problem:** `.sh` files won't execute on Windows

**Solution:**
- Use Windows Subsystem for Linux (WSL)
- Or use PowerShell to run scripts
- Or use Git Bash

---

## 📁 Directory Structure After Installation

```
~/.claude/skills/
├── saas-auth-shield/          ← Your installed skill
│   ├── SKILL.md                    # Main skill file
│   ├── README.md                   # Documentation
│   ├── template.md                 # User preference template
│   ├── FILE_MANIFEST.md            # File manifest
│   ├── LICENSE                     # MIT License
│   ├── .gitignore                  # Git ignore rules
│   ├── examples/
│   │   └── example-output.md       # Example outputs
│   ├── references/
│   │   ├── env-setup.md            # Environment and provider setup
│   │   ├── fingerprint-options.md  # Fingerprinting tradeoffs
│   │   └── retrofit-guide.md       # Migration guide
│   └── scripts/
│       ├── detect-project.sh       # Project detection
│       └── validate-skill.sh       # Validation script
└── other-skills/
    └── ...
```

---

## 🔐 Security Considerations

### File Permissions

Ensure proper permissions:
```bash
# Make scripts executable
chmod +x ~/.claude/skills/saas-auth-shield/scripts/*.sh

# Ensure files are readable
chmod 644 ~/.claude/skills/saas-auth-shield/*.md
```

### Sensitive Data

**Never commit:**
- `.env` files with API keys
- Database credentials
- OAuth secrets
- Private keys

**Always use:**
- `.env.example` as template
- Environment variables for secrets
- `.gitignore` to prevent accidental commits

---

## 🚀 Quick Start After Installation

### For New Projects

```bash
# In Claude Code, type:
"I want to create a new SaaS app with authentication. 
Should I use email+password, Google OAuth, or both? 
Do I need device fingerprinting?"

# Claude will generate everything
```

### For Existing Projects

```bash
# In Claude Code, type:
"I have a Next.js app with NextAuth. 
Can I upgrade to Better Auth with fingerprinting?"

# Claude will provide migration guide
```

### For Adding to Existing Code

```bash
# In Claude Code, type:
"Add authentication to my existing Next.js app 
without breaking current functionality"

# Claude will integrate seamlessly
```

---

## 📞 Support

### Getting Help

1. **Check examples:** `examples/example-output.md`
2. **Read documentation:** `SKILL.md`
3. **Review retrofit guide:** `references/retrofit-guide.md`
4. **Run detection:** `bash scripts/detect-project.sh`

### Reporting Issues

If you encounter problems:

1. Run validation: `bash scripts/validate-skill.sh`
2. Check file permissions: `ls -la ~/.claude/skills/saas-auth-shield/`
3. Verify SKILL.md exists: `cat ~/.claude/skills/saas-auth-shield/SKILL.md | head -20`
4. Open an issue on GitHub with:
   - Your OS (macOS/Linux/Windows)
   - Your AI editor (Claude Code/Codex)
   - Error message
   - Output of `validate-skill.sh`

---

## 🎓 Next Steps

After installation:

1. **Read SKILL.md** — Understand capabilities
2. **Review examples** — See what it can generate
3. **Try it out** — Use in Claude Code
4. **Read references/** — Use the deeper docs only when needed
5. **Customize** — Adapt to your needs

---

## 📚 Additional Resources

- [Better Auth Documentation](https://www.better-auth.com)
- [Claude Code Guide](https://claude.ai)
- [Codex CLI Documentation](https://platform.openai.com/docs/guides/code)
- [Agent Skills Specification](https://github.com/anthropics/skills)

---

**Installation complete! You're ready to use the SaaS Auth Shield! 🚀**
