#!/usr/bin/env bash
# Deterministic pre-commit secret / privacy scan for this config repo.
#
# Checks every file that would be shared (tracked + staged + untracked, honoring
# .gitignore) against a fixed pattern set. Same input -> same output, no model
# judgment involved. Exits non-zero on any finding.
#
# Exempt a specific line by putting the marker  scan:allow  in a comment on it.
#
# Usage:  bash scripts/scan.sh
set -eu

root="$(git -C "$(dirname "$0")" rev-parse --show-toplevel)"
cd "$root"

# name<TAB>extended-regex  (matched with `grep -nE`, case-sensitive)
patterns='
github-token	\bgh[oprsu]_[A-Za-z0-9]{36}\b
github-pat	\bgithub_pat_[A-Za-z0-9_]{20,}\b
openai-anthropic-key	\bsk-(ant-)?[A-Za-z0-9_-]{20,}\b
aws-access-key-id	\bAKIA[0-9A-Z]{16}\b
slack-token	\bxox[baprs]-[A-Za-z0-9-]{10,}\b
google-api-key	\bAIza[0-9A-Za-z_-]{35}
private-key-block	BEGIN[A-Z ]+PRIVATE KEY
jwt	\beyJ[A-Za-z0-9_-]{8,}\.[A-Za-z0-9_-]{8,}\.[A-Za-z0-9_-]{8,}
aws-secret-access-key	aws_secret_access_key[[:space:]]*=[[:space:]]*[A-Za-z0-9/+]{40}
user-email	adamzartin@gmail\.com
home-path-leak	/(Users|home)/[a-z_][a-z0-9_.-]+/
'

# case-insensitive: name<TAB>regex
ipatterns='
secret-assignment	(api[_-]?key|access[_-]?token|auth[_-]?token|client[_-]?secret|password|passwd)["'"'"']?[[:space:]]*[:=][[:space:]]*["'"'"'][^"'"'"']{8,}["'"'"']
'

# Filenames that should never live in this repo.
bad_paths_re='(^|/)(\.env(\..+)?|id_rsa|id_ed25519|.+\.pem|.+\.key|.+\.p12|.+\.pfx)$|^(sessions|backups|shell-snapshots|file-history|projects|session-env)/'

findings=0
report() { printf '  %s\n' "$1"; findings=$((findings + 1)); }

scan_file() {
  f="$1"
  [ -f "$f" ] || return 0
  case "$f" in scripts/scan.sh) return 0;; esac

  if printf '%s\n' "$f" | grep -qE "$bad_paths_re"; then
    report "$f: filename type not allowed in this repo"
  fi
  grep -Iq . "$f" 2>/dev/null || return 0   # skip binaries

  printf '%s\n' "$patterns" | while IFS='	' read -r name re; do
    [ -n "$name" ] || continue
    grep -nE "$re" "$f" 2>/dev/null | grep -v 'scan:allow' | while IFS= read -r hit; do
      printf '  %s:%s  [%s]\n' "$f" "$hit" "$name"
    done
  done
  printf '%s\n' "$ipatterns" | while IFS='	' read -r name re; do
    [ -n "$name" ] || continue
    grep -niE "$re" "$f" 2>/dev/null | grep -v 'scan:allow' | while IFS= read -r hit; do
      printf '  %s:%s  [%s]\n' "$f" "$hit" "$name"
    done
  done
}

hits="$(
  git ls-files -co --exclude-standard | while IFS= read -r f; do
    scan_file "$f"
  done
)"

if [ -n "$hits" ]; then
  printf '%s\n' "$hits"
  findings=$(printf '%s\n' "$hits" | grep -c .)
fi

# Optional deterministic second pass if a real scanner is installed.
if command -v gitleaks >/dev/null 2>&1; then
  echo "gitleaks: detecting..."
  gitleaks detect --no-banner --redact -s "$root" || findings=$((findings + 1))
fi

if [ "$findings" -gt 0 ]; then
  echo
  echo "FAIL: $findings potential secret/privacy issue(s). Redact, or add 'scan:allow' to an intentional line."
  exit 1
fi
echo "OK: no secrets or private content detected."
