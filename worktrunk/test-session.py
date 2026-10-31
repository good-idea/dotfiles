#!/usr/bin/env python3
"""Disposable Git + real wt integration; tmux/Pi are never run.

Run: python3 ~/.config/worktrunk/test-session.py
The tmux double records the process boundary and models only session metadata.
"""
import json
import os
from pathlib import Path
import pty
import shlex
import subprocess
import tempfile
import unittest

HELPER = Path(__file__).with_name("session.py")
CONFIG = Path(__file__).with_name("config.toml")
FAKE_TMUX = '''#!/usr/bin/env python3
import json, os, pathlib, sys
p = pathlib.Path(os.environ['FAKE_STATE'])
s = json.loads(p.read_text()) if p.exists() else {'sessions': [], 'calls': []}
a = sys.argv[1:]
s['calls'].append({'args': a, 'cwd': os.getcwd(), 'setup': pathlib.Path('setup-ready').exists(), 'tty': os.isatty(0)})
code = 0
if a[0] == 'list-sessions':
 for entry in s['sessions']:
  print(entry['id'] + '\\t' + entry['name'] + '\\t' + entry.get('path', ''))
elif a[0] == 'new-session':
 entry = {'id': '$' + str(len(s['sessions'])), 'name': a[a.index('-s')+1]}
 s['sessions'].append(entry)
 print(entry['id'])
elif a[0] == 'set-option':
 entry = next(x for x in s['sessions'] if x['id'] == a[a.index('-t')+1])
 entry['path'] = a[-1]
elif a[0] not in ('attach-session', 'switch-client'):
 code = 89
p.write_text(json.dumps(s))
sys.exit(code)
'''


class Workflow(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="wt-personal-")
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name).resolve()
        self.repo = self.root / "demo.repo"
        self.repo.mkdir()
        bin_dir = self.root / "bin"
        bin_dir.mkdir()
        (bin_dir / "tmux").write_text(FAKE_TMUX)
        (bin_dir / "pi").write_text("#!/bin/sh\necho 'ERROR: pi must never execute in tests' >&2\nexit 99\n")
        for p in bin_dir.iterdir():
            p.chmod(0o700)
        self.state = self.root / "state.json"
        config = self.root / 'config.toml'
        config.write_text(CONFIG.read_text())
        self.env = dict(os.environ, PATH=f"{bin_dir}:{os.environ['PATH']}",
                        XDG_CONFIG_HOME=str(self.root / 'xdg'),
                        FAKE_STATE=str(self.state), WORKTRUNK_CONFIG_PATH=str(config),
                        WORKTRUNK_SYSTEM_CONFIG_PATH=str(self.root / "none.toml"),
                        WORKTRUNK_PROJECT_CONFIG_PATH=".config/wt.toml")
        self.env.pop("TMUX", None)
        self.env.pop("WORKTRUNK_WORKTREE_PATH", None)
        self.git("init", "-b", "main")
        self.git("config", "user.name", "Test")
        self.git("config", "user.email", "test@example.invalid")
        (self.repo / "README").write_text("fixture\n")
        self.git("add", ".")
        self.git("commit", "-m", "fixture")

    def run_cmd(self, *cmd, cwd=None, ok=True, terminal=False, env=None, terminal_input=None):
        master = slave = None
        if terminal:
            master, slave = pty.openpty()
            if terminal_input:
                os.write(master, terminal_input)
        try:
            result = subprocess.run(cmd, cwd=cwd or self.repo, env=env or self.env,
                                    stdin=slave if terminal else subprocess.DEVNULL,
                                    stdout=slave if terminal else subprocess.PIPE,
                                    stderr=subprocess.PIPE, text=True, timeout=30)
        finally:
            if master is not None:
                os.close(master)
                os.close(slave)
        if ok:
            self.assertEqual(result.returncode, 0, result.stderr)
        return result

    def git(self, *args):
        return self.run_cmd("git", *args)

    def data(self):
        return json.loads(self.state.read_text())

    def setup_hook(self, fail=False, approve=True):
        (self.repo / ".config").mkdir(exist_ok=True)
        (self.repo / ".config/wt.toml").write_text(
            '[pre-start]\nsetup = "' + ('exit 7' if fail else 'sleep 0.05; touch setup-ready') + '"\n')
        self.git("add", ".")
        self.git("commit", "-m", "setup hook")
        if approve:
            self.run_cmd('wt', 'config', 'approvals', 'add', '--yes')

    def test_new_waits_for_setup_and_bases_on_current_head(self):
        self.setup_hook()
        self.git("checkout", "-b", "source")
        (self.repo / "source-only").write_text("current HEAD\n")
        self.git("add", ".")
        self.git("commit", "-m", "source change")
        self.run_cmd("wt", "-y", "new", "feature/a", "--no-attach")
        created = self.root / "demo.repo.feature-a"
        self.assertTrue((created / "source-only").exists())
        d = self.data()
        call = next(c for c in d['calls'] if c['args'][0] == 'new-session')
        self.assertTrue(call['setup'], 'tmux ran before blocking setup finished')
        self.assertEqual(call['cwd'], str(created))
        self.assertEqual(d['sessions'][0]['name'], 'demo-repo-feature-a')
        self.assertEqual(d['sessions'][0]['path'], str(created))
        self.assertFalse(any(c['args'][0] in ('attach-session', 'switch-client') for c in d['calls']))
        self.run_cmd("wt", "session", "--autostart", "--no-attach", cwd=created)
        self.assertEqual(len(self.data()['sessions']), 1, 'reused session must not launch Pi')

    def test_meljac_new_uses_project_override_without_requiring_task(self):
        self.git('remote', 'add', 'origin', 'git@github.com:good-idea/meljac-na')
        self.run_cmd('wt', 'new', 'chore/no-task', '--no-attach')
        created = self.repo / 'worktrees/chore-no-task'
        self.assertTrue(created.is_dir())
        self.assertEqual(self.data()['sessions'][0]['path'], str(created))
        self.assertEqual(self.data()['sessions'][0]['name'], 'demo-repo-chore-no-task')

    def test_unapproved_noninteractive_new_never_creates_worktree(self):
        self.setup_hook(approve=False)
        result = self.run_cmd('wt', 'new', 'unapproved', '--no-attach', ok=False)
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse((self.root / 'demo.repo.unapproved').exists())
        self.assertNotEqual(self.git('branch', '--list', 'unapproved').stdout.strip(), 'unapproved')
        self.assertFalse(self.state.exists())
        state = self.run_cmd('wt', 'config', 'approvals', 'list', '--format=json')
        self.assertEqual(json.loads(state.stdout)['state'], 'approval_required')

    def test_declined_interactive_new_never_creates_worktree(self):
        self.setup_hook(approve=False)
        result = self.run_cmd('wt', 'new', 'declined', '--no-attach', ok=False,
                              terminal=True, terminal_input=b'n\n')
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('Commands declined', result.stderr, 'fixture must reach actual approval prompt')
        self.assertFalse((self.root / 'demo.repo.declined').exists())
        self.assertEqual(self.git('branch', '--list', 'declined').stdout.strip(), '')
        self.assertFalse(self.state.exists())
        state = self.run_cmd('wt', 'config', 'approvals', 'list', '--format=json')
        self.assertEqual(json.loads(state.stdout)['state'], 'approval_required')

    def test_interactive_approval_allows_setup_before_session(self):
        self.setup_hook(approve=False)
        self.run_cmd('wt', 'new', 'accepted', '--no-attach', terminal=True, terminal_input=b'y\n')
        self.assertTrue((self.root / 'demo.repo.accepted/setup-ready').exists())
        creation = next(c for c in self.data()['calls'] if c['args'][0] == 'new-session')
        self.assertTrue(creation['setup'])
        state = self.run_cmd('wt', 'config', 'approvals', 'list', '--format=json')
        self.assertEqual(json.loads(state.stdout)['state'], 'approved')

    def test_failed_setup_never_creates_tmux(self):
        self.setup_hook(fail=True)
        result = self.run_cmd("wt", "-y", "new", "broken", "--no-attach", ok=False)
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse(self.state.exists())

    def test_collision_and_canonical_path_reuse(self):
        self.git("checkout", "-b", "feature/a")
        self.run_cmd("wt", "session", "--no-attach")
        other = self.root / "other tree"
        self.git("worktree", "add", "-b", "feature.a", str(other))
        self.run_cmd("wt", "session", "--no-attach", cwd=other)
        d = self.data()
        self.assertEqual(d['sessions'][0]['name'], 'demo-repo-feature-a')
        self.assertNotEqual(d['sessions'][1]['name'], 'demo-repo-feature-a')
        self.assertEqual(len(d['sessions']), 2)
        link = self.root / "symlink"
        link.symlink_to(other, target_is_directory=True)
        self.run_cmd("wt", "session", "--no-attach", cwd=link)
        self.assertEqual(len(self.data()['sessions']), 2)

    def test_task_autostart_is_quoted_and_process_scoped(self):
        self.git("remote", "add", "origin", "git@github.com:good-idea/meljac-na.git")
        self.git("checkout", "-b", "feat/007-example-task")
        task = self.repo / "docs/tasks/007-example-task/TASK.md"
        task.parent.mkdir(parents=True)
        task.write_text('---\nid: "007"\n---\n')
        skill = self.repo / '.agents/skills/execute-task/SKILL.md'
        skill.parent.mkdir(parents=True)
        skill.write_text('Local execute-task skill fixture\n')
        model = "provider/id:high; touch NEVER"
        self.run_cmd("wt", "switch", "@", "--no-cd", "--execute", "wt", "--", "session", "--",
                     "--autostart", "--model", model, "--no-attach")
        d = self.data()
        self.assertEqual(d['sessions'][0]['name'], 'mna-007 example-task')
        args = next(c['args'] for c in d['calls'] if c['args'][0] == 'new-session')
        command = shlex.split(args[-1].split('; exec ')[0])
        self.assertEqual(command[:2], ['env', 'PI_SESSION_TAGS=project:meljac__task:007'])
        self.assertEqual(command[3:5], ['--model', model])
        self.assertIn('docs/tasks/007-example-task/TASK.md', command[-1])
        self.assertIn('Read the execute-task skill', command[-1])
        self.assertFalse((self.repo / '.env').exists())
        self.assertFalse((self.repo / 'NEVER').exists())

    def test_generic_task_without_skill_has_reference_not_invented_tags(self):
        self.git('checkout', '-b', 'feat/008-another-task')
        task = self.repo / 'docs/tasks/008-another-task/TASK.md'
        task.parent.mkdir(parents=True)
        task.write_text('Task fixture\n')
        self.run_cmd('wt', 'session', '--autostart', '--no-attach')
        data = self.data()
        self.assertEqual(data['sessions'][0]['name'], 'demo-repo-008 another-task')
        command = next(c['args'][-1] for c in data['calls'] if c['args'][0] == 'new-session')
        self.assertIn('docs/tasks/008-another-task/TASK.md', command)
        self.assertNotIn('execute-task', command)
        self.assertNotIn('PI_SESSION_TAGS=', command)

    def test_generic_autostart_and_detached_head_need_no_task(self):
        self.git("checkout", "--detach")
        self.run_cmd("wt", "session", "--autostart", "--no-attach")
        d = self.data()
        self.assertRegex(d['sessions'][0]['name'], r'^demo-repo-demo-repo-[a-f0-9]+$')
        cmd = next(c['args'][-1] for c in d['calls'] if c['args'][0] == 'new-session')
        self.assertNotIn('PI_SESSION_TAGS=', cmd)
        self.assertNotIn('--model', cmd)
        self.assertNotIn('TASK.md', cmd)

    def test_attach_and_switch_use_foreground_terminal(self):
        self.run_cmd("wt", "session", terminal=True)
        last = self.data()['calls'][-1]
        self.assertEqual(last['args'], ['attach-session', '-t', '$0'])
        self.assertTrue(last['tty'])
        env = dict(self.env, TMUX='/fake,1,0')
        self.run_cmd("wt", "switch", "@", "--no-cd", "--execute", "wt", "--", "session", "--", "--autostart", env=env, terminal=True)
        last = self.data()['calls'][-1]
        self.assertEqual(last['args'], ['switch-client', '-t', '$0'])
        self.assertTrue(last['tty'])
        self.assertEqual(len(self.data()['sessions']), 1)

    def test_invalid_options_do_not_create_worktrees_or_sessions(self):
        for args in [('new', 'bad', '--model', 'sonnet'), ('new', 'bad', '--autostart', '--model', 'low'),
                     ('session', '--model'), ('session', '--unknown')]:
            result = self.run_cmd('wt', *args, ok=False)
            self.assertNotEqual(result.returncode, 0)
        self.assertFalse(self.state.exists())
        self.assertFalse((self.root / 'demo.repo.bad').exists())

    def test_nonterminal_requires_explicit_no_attach(self):
        result = self.run_cmd('wt', 'session', ok=False)
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse(self.state.exists())


if __name__ == '__main__':
    unittest.main(verbosity=2)
