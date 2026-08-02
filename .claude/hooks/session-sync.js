#!/usr/bin/env node
/**
 * SessionStart hook - keeps the laptop and the desktop from diverging.
 *
 * CLAUDE.md rule: "git pull at the start of a session before editing anything."
 * The repo is the ONLY channel between the two machines, so a session that
 * starts on stale HEAD will happily contradict work the other box already did.
 * This makes the pull structural instead of something I have to remember.
 *
 * Deliberately conservative. It will fast-forward, and that is all:
 *   - never merges, never rebases, never touches a dirty working tree
 *   - never force-anything, never pushes
 *   - if it cannot fast-forward cleanly it SAYS SO and leaves the tree alone
 *
 * A hook that silently rewrote the working tree would be far more dangerous
 * than one that occasionally reports "you need to sort this out by hand".
 *
 * Always exits 0. A backup/sync helper must never be the reason a session
 * fails to start.
 */

const { execSync } = require('child_process');

const repo = process.env.CLAUDE_PROJECT_DIR || process.cwd();

function git(args, timeout = 15000) {
  return execSync(`git ${args}`, {
    cwd: repo,
    encoding: 'utf8',
    timeout,
    stdio: ['ignore', 'pipe', 'pipe'],
  }).trim();
}

function emit(context, systemMessage) {
  const out = {
    hookSpecificOutput: {
      hookEventName: 'SessionStart',
      additionalContext: context,
    },
  };
  if (systemMessage) out.systemMessage = systemMessage;
  process.stdout.write(JSON.stringify(out));
  process.exit(0);
}

let branch;
try {
  git('rev-parse --is-inside-work-tree');
  branch = git('rev-parse --abbrev-ref HEAD');
} catch {
  process.exit(0); // Not a git repo. Nothing to say.
}

const lines = [];
let notable = null;

// A dirty tree is not an error - it just means we must not move HEAD.
let dirty = false;
try {
  dirty = git('status --porcelain').length > 0;
} catch { /* ignore */ }

// Fetch. The most likely failure here is simply being offline, which is fine.
let online = true;
try {
  git('fetch origin --quiet', 25000);
} catch {
  online = false;
}

if (!online) {
  lines.push(
    `Repo sync: OFFLINE - could not reach origin. Working from local HEAD on ` +
    `'${branch}'. Anything the other machine pushed is NOT here yet, so treat ` +
    `the repo as possibly stale before making decisions from it.`
  );
  emit(lines.join('\n'), 'Repo sync: offline, working from local HEAD');
}

let ahead = 0;
let behind = 0;
let hasUpstream = true;
try {
  const counts = git(`rev-list --left-right --count HEAD...origin/${branch}`);
  const parts = counts.split(/\s+/);
  ahead = parseInt(parts[0], 10) || 0;
  behind = parseInt(parts[1], 10) || 0;
} catch {
  hasUpstream = false;
}

if (!hasUpstream) {
  emit(`Repo sync: no origin/${branch} to compare against. Local-only branch.`);
}

if (behind === 0 && ahead === 0) {
  lines.push(`Repo sync: up to date with origin/${branch}.`);
  if (dirty) lines.push('Working tree has uncommitted changes.');
  emit(lines.join(' '));
}

// Behind, and safe to fast-forward.
if (behind > 0 && ahead === 0 && !dirty) {
  let incoming = '';
  try {
    incoming = git(`log --oneline HEAD..origin/${branch}`);
  } catch { /* ignore */ }

  try {
    git('merge --ff-only FETCH_HEAD', 20000);
    lines.push(
      `Repo sync: pulled ${behind} commit(s) from origin/${branch} ` +
      `(fast-forward). This is work from the OTHER machine - read it before ` +
      `assuming anything about current state:`
    );
    if (incoming) lines.push(incoming);
    notable = `Repo sync: fast-forwarded ${behind} commit(s) from the other machine`;
  } catch (e) {
    lines.push(
      `Repo sync: ${behind} commit(s) behind origin/${branch}, and the ` +
      `fast-forward FAILED. Do not edit until this is resolved. ` +
      `Error: ${String(e.message).split('\n')[0]}`
    );
    notable = 'Repo sync: pull failed - resolve before editing';
  }
  emit(lines.join('\n'), notable);
}

// Everything below is a state a hook must not "fix" on its own.
if (behind > 0 && dirty) {
  lines.push(
    `Repo sync: ${behind} commit(s) behind origin/${branch}, but the working ` +
    `tree is DIRTY so nothing was pulled. Commit or stash first, then pull. ` +
    `Editing now risks conflicting with the other machine.`
  );
  notable = `Repo sync: ${behind} behind, tree dirty - not pulled`;
} else if (behind > 0 && ahead > 0) {
  lines.push(
    `Repo sync: branches have DIVERGED - ${ahead} local commit(s) and ` +
    `${behind} remote commit(s). Not pulled: this needs a human decision ` +
    `about merge vs rebase. The two machines have both moved.`
  );
  notable = `Repo sync: DIVERGED (${ahead} local / ${behind} remote)`;
} else if (ahead > 0) {
  lines.push(
    `Repo sync: ${ahead} local commit(s) not yet pushed. The other machine ` +
    `cannot see this work until it is pushed.`
  );
  notable = `Repo sync: ${ahead} commit(s) unpushed`;
}

if (dirty && !lines.some((l) => l.includes('DIRTY'))) {
  lines.push('Working tree has uncommitted changes.');
}

emit(lines.join('\n'), notable);
