#!/usr/bin/env node
/**
 * PreToolUse hook - blocks Write/Edit calls that would put a real credential
 * into a tracked file.
 *
 * CLAUDE.md rule: "Secrets live in .env (gitignored), never in scripts, never
 * in chat." This makes that structural instead of something Claude has to
 * remember on every single write.
 *
 * .env itself is exempt - that is the one place credentials belong.
 */

const PATTERNS = [
  [/AIza[0-9A-Za-z_-]{35}/, 'Google / YouTube API key'],
  [/EAA[A-Za-z0-9]{60,}/, 'Meta / Instagram access token'],
  [/sk-[A-Za-z0-9]{20,}/, 'OpenAI-style secret key'],
  [/\bghp_[A-Za-z0-9]{36}\b/, 'GitHub personal access token'],
  [/-----BEGIN (?:[A-Z ]+ )?PRIVATE KEY-----/, 'private key block'],
];

let raw = '';
process.stdin.on('data', (c) => (raw += c));
process.stdin.on('end', () => {
  let payload;
  try {
    payload = JSON.parse(raw);
  } catch {
    process.exit(0); // Never block on a parse failure.
  }

  const input = payload.tool_input || {};
  const filePath = String(input.file_path || '');

  // .env is where credentials are supposed to live.
  if (/(^|[\\/])\.env$/.test(filePath)) process.exit(0);

  const haystack = [input.content, input.new_string, input.command]
    .filter(Boolean)
    .join('\n');
  if (!haystack) process.exit(0);

  for (const [re, label] of PATTERNS) {
    if (re.test(haystack)) {
      process.stdout.write(
        JSON.stringify({
          hookSpecificOutput: {
            hookEventName: 'PreToolUse',
            permissionDecision: 'deny',
            permissionDecisionReason:
              `Blocked: this write appears to contain a ${label}. ` +
              `Credentials belong in .env (gitignored), never in a tracked file. ` +
              `Reference it as an env var instead.`,
          },
        })
      );
      process.exit(0);
    }
  }
  process.exit(0);
});
