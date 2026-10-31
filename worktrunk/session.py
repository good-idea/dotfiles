#!/usr/bin/env python3
"""Personal Worktrunk foreground tmux workflow (not a project hook).

wt new BRANCH [--autostart] [--model PI_PATTERN] [--no-attach]
wt session [--autostart] [--model PI_PATTERN] [--no-attach]

Shared project setup belongs in blocking pre-start hooks. Existing sessions are
identified by canonical worktree path, never by a possibly colliding name.
"""
import argparse
import fcntl
import hashlib
import json
import os
from pathlib import Path
import re
import shlex
import shutil
import subprocess
import sys


def output(*args):
    return subprocess.check_output(args, text=True).strip()


def safe_name(value):
    # Includes tmux's invalid ':' and '.' and target-pattern metacharacters.
    return re.sub(r"[^A-Za-z0-9_ -]+", "-", value).strip(" -")[:120] or "worktree"


def context():
    root = Path(output("git", "rev-parse", "--show-toplevel")).resolve()
    common = Path(output("git", "rev-parse", "--git-common-dir")).resolve()
    repo = common.parent.name if common.name == ".git" else common.name
    result = subprocess.run(["git", "symbolic-ref", "--quiet", "--short", "HEAD"],
                            text=True, stdout=subprocess.PIPE)
    branch = result.stdout.strip() if result.returncode == 0 else ""
    remotes = output("git", "remote", "-v")
    meljac = re.search(r"github\.com[:/]good-idea/meljac-na(?:\.git)?(?:\s|$)", remotes)
    match = re.fullmatch(r"(?:[^/]+/)?(\d{3})-([^/]+)", branch)
    task = None
    if match:
        candidate = Path("docs/tasks") / f"{match[1]}-{match[2]}" / "TASK.md"
        if (root / candidate).is_file():
            task = (candidate.as_posix(), match[1], bool(meljac))
    if task:
        prefix = "mna" if meljac else repo
        name = f"{prefix}-{match[1]} {match[2]}"
    else:
        identity = branch or f"{root.name}-{output('git', 'rev-parse', '--short', 'HEAD')}"
        name = f"{repo}-{identity}"
    return root, safe_name(name), task


def sessions():
    result = subprocess.run(["tmux", "list-sessions", "-F",
                             "#{session_id}\t#{session_name}\t#{@worktrunk_path}"],
                            text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if result.returncode:
        # No server is the normal first-session case, not a broken tmux config.
        if any(s in result.stderr for s in ("no server running", "no sessions", "error connecting", "No such file or directory")):
            return []
        raise RuntimeError(result.stderr.strip())
    return [line.split("\t", 2) for line in result.stdout.splitlines()]


def pane_command(args, task):
    pi = shutil.which("pi")
    if not pi:
        raise RuntimeError("pi CLI not found in PATH")
    cmd = [pi]
    if args.model:
        cmd += ["--model", args.model]
    if task:
        path, task_id, meljac = task
        if meljac:
            cmd = ["env", f"PI_SESSION_TAGS=project:meljac__task:{task_id}"] + cmd
        skill = ".agents/skills/execute-task/SKILL.md"
        if Path(skill).is_file():
            prompt = (f"Read the execute-task skill at {skill}, then read {path} and execute this task. "
                      "Follow AGENTS.md and CONTRIBUTING.md. Work only in this worktree. "
                      "Do not wrap, merge, or remove the worktree.")
        else:
            prompt = f"Read the task context at {path}. Work only in this worktree."
        cmd += ["--", prompt]
    shell = os.environ.get("SHELL", "/bin/sh")
    # A tmux shell command (not injected keystrokes): no startup race or quoting
    # through the user's interactive shell. Keep a shell open after Pi exits.
    return shlex.join(cmd) + "; exec " + shlex.quote(shell) + " -l"


def session(args):
    root, base, task = context()
    if not shutil.which("tmux"):
        raise RuntimeError("tmux not found in PATH")
    # Require a terminal before creating anything, unless explicitly detached.
    if not args.no_attach and not os.environ.get("TMUX"):
        if not (sys.stdin.isatty() and sys.stdout.isatty()):
            raise RuntimeError("attach requires a terminal; use --no-attach for detached creation")
    # Serialize this helper's name allocation + metadata assignment, not attach.
    lock_path = Path(__file__).resolve().with_suffix(".lock")
    with lock_path.open("a") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        existing = sessions()
        target = next((sid for sid, _, path in existing if path == str(root)), None)
        if target:
            print(f"Using existing tmux session {target}; autostart skipped.", flush=True)
        else:
            names = {name for _, name, _ in existing}
            name = base
            digest = hashlib.sha256(os.fsencode(root)).hexdigest()[:10]
            counter = 0
            while name in names:
                counter += 1
                name = f"{base}-{digest}" + (f"-{counter}" if counter > 1 else "")
            command = pane_command(args, task) if args.autostart else None
            cmd = ["tmux", "new-session", "-d", "-P", "-F", "#{session_id}",
                   "-s", name, "-c", str(root)]
            if command:
                cmd += [command]
            target = output(*cmd)
            subprocess.run(["tmux", "set-option", "-t", target,
                            "@worktrunk_path", str(root)], check=True)
            print(f"Created tmux session {name} ({target}) in {root}", flush=True)
    if args.no_attach:
        print(f"Attach with: tmux attach-session -t {shlex.quote(target)}")
        return
    action = "switch-client" if os.environ.get("TMUX") else "attach-session"
    os.execvp("tmux", ["tmux", action, "-t", target])


def require_approvals():
    """Refusal must abort creation, not let wt skip setup and run --execute."""
    def state():
        data = json.loads(output("wt", "config", "approvals", "list", "--format=json"))
        value = data.get("state")
        if value not in ("no_commands", "approved", "approval_required"):
            raise RuntimeError(f"unknown Worktrunk approval state: {value!r}")
        return value

    if state() == "approval_required":
        # Inherit the foreground terminal and NEVER auto-approve. Even a zero
        # status can mean declined, so the subsequent read is authoritative.
        result = subprocess.run(["wt", "config", "approvals", "add"])
        after = state()
        if result.returncode or after == "approval_required":
            raise RuntimeError("project commands are not approved; no worktree created")


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("operation", choices=("new", "session"))
    parser.add_argument("branch", nargs="?")
    parser.add_argument("--autostart", action="store_true")
    parser.add_argument("--model", help="Pi model pattern or provider/id (no legacy low/mid/high aliases)")
    parser.add_argument("--no-attach", action="store_true")
    args = parser.parse_args()
    if args.model and (not args.autostart or args.model in ("low", "mid", "high") or not args.model.strip()):
        parser.error("--model requires --autostart and a Pi model pattern/id, not low/mid/high")
    if args.operation == "new":
        if not args.branch or args.branch.startswith("-"):
            parser.error("new requires a branch name")
        require_approvals()
        flags = []
        if args.autostart:
            flags += ["--autostart"]
        if args.model:
            flags += ["--model", args.model]
        if args.no_attach:
            flags += ["--no-attach"]
        os.execvp("wt", ["wt", "switch", "--create", args.branch, "--no-cd", "--base", "@",
                          "--execute", sys.executable, "--", str(Path(__file__).resolve()), "session", *flags])
    if args.branch:
        parser.error("session takes no branch; run it in the target worktree")
    session(args)


if __name__ == "__main__":
    try:
        main()
    except (RuntimeError, subprocess.CalledProcessError, OSError, ValueError) as error:
        print(f"worktrunk session: {error}", file=sys.stderr)
        sys.exit(1)
