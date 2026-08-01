#!/usr/bin/env node
/**
 * PreToolUse hook - enforces the approval queue.
 *
 * CLAUDE.md rule (decided 2026-07-31): Claude posts ONLY from
 * publisher/approved/. Anything still in publisher/queue/ at post time is
 * skipped, never posted anyway, never guessed at. Silence means no.
 *
 * This makes that gate structural rather than a promise Claude has to
 * remember on every run. It fires on shell commands that look like they
 * invoke a publish/upload path, and denies unless the command is clearly
 * operating on approved/.
 *
 * Deliberately conservative: it would rather block a legitimate dry run
 * (easy to notice and re-issue) than let one unapproved post go out.
 */

// Looks like an attempt to actually publish something.
const PUBLISH_INTENT =
  /publisher[\\/][^\s|;&]*(publish|post|upload)|(publish|upload)-(to-)?(youtube|instagram|tiktok|x)|\/publish\b/i;

// Reading, listing, or drafting is always fine.
const READ_ONLY = /^\s*(ls|dir|cat|type|Get-Content|Get-ChildItem|head|tail|less|more|wc|stat|Test-Path)\b/i;

let raw = '';
process.stdin.on('data', (c) => (raw += c));
process.stdin.on('end', () => {
  let payload;
  try {
    payload = JSON.parse(raw);
  } catch {
    process.exit(0);
  }

  const cmd = String((payload.tool_input || {}).command || '');
  if (!cmd) process.exit(0);
  if (READ_ONLY.test(cmd)) process.exit(0);
  if (!PUBLISH_INTENT.test(cmd)) process.exit(0);

  // A publish path that never mentions approved/ is exactly what the rule forbids.
  const touchesApproved = /approved/i.test(cmd);
  const touchesQueue = /queue/i.test(cmd);

  if (!touchesApproved || touchesQueue) {
    process.stdout.write(
      JSON.stringify({
        hookSpecificOutput: {
          hookEventName: 'PreToolUse',
          permissionDecision: 'deny',
          permissionDecisionReason:
            'Blocked by the approval gate. Posts may only be published from ' +
            'publisher/approved/. This command either targets publisher/queue/ ' +
            'or does not name approved/ at all. Connor moves a file into ' +
            'approved/ to green-light it - unapproved items are skipped, not posted. ' +
            '(Rule: CLAUDE.md "How we work together" #2.)',
        },
      })
    );
    process.exit(0);
  }
  process.exit(0);
});
