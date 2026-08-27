# Migrating from asdf to mise

`mise` is already installed and supports the existing project-level `.tool-versions` files. There is no need to convert them to `mise.toml`; `mise` automatically treats `nodejs` as an alias for `node`.

## 1. Use existing project `.tool-versions` files

Continue using the existing `.tool-versions` files. Install a project's declared tools with:

```sh
mise install
```

This replaces:

```sh
asdf install
```

## 2. Move global versions into mise

The current `~/.tool-versions` contains global defaults. Move those defaults into mise's global configuration:

```sh
mise use -g \
  node@24.16.0 \
  ruby@3.0.1 \
  elixir@1.15.7-otp-26 \
  erlang@26.2.1 \
  python@3.12.1

mv ~/.tool-versions ~/.tool-versions.asdf-backup
```

This creates `~/.config/mise/config.toml`.

## 3. Replace asdf shell initialization

In `~/.dotfiles/zsh/zshrc.sh`, replace:

```sh
# ASDF
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
```

with:

```sh
eval "$(mise activate zsh)"
```

Keep the existing `compinit` setup.

## 4. Update the `pi` wrapper

In `~/.dotfiles/zsh/aliases.sh`, replace:

```sh
ASDF_NODEJS_VERSION=24.16.0 command pi "$@"
```

with:

```sh
mise x node@24.16.0 -- pi "$@"
```

The mise-managed Node installation currently has an older version of `pi`. Update it first:

```sh
mise x node@24.16.0 -- npm install -g @earendil-works/pi-coding-agent
```

Also replace `@mariozechner/pi-coding-agent` with `@earendil-works/pi-coding-agent` in `~/.default-npm-packages`.

> Note: mise still supports `~/.default-npm-packages`, but this mechanism is deprecated and is scheduled for removal in a future mise release. The global npm CLIs can later be moved to mise's `npm:` backend.

## 5. Reinstall asdf's remaining Node versions

Node `22.12.0` and `24.16.0` are already installed under mise. Install the remaining versions currently managed by asdf:

```sh
mise install \
  node@16.20.2 \
  node@21.1.0 \
  node@22.14.0 \
  node@24.11.0
```

Other project versions can be installed on demand by entering the project and running:

```sh
mise install
```

## 6. Restart and verify

Restart zsh and inspect the resulting environment:

```sh
exec zsh
mise doctor
type -a node npm pi
node --version
```

Test several projects that declare different versions in `.tool-versions`.

Confirm that `type -a node npm pi` no longer reports paths under `~/.asdf`.

## 7. Remove asdf

Once the mise-managed tools work correctly:

```sh
brew uninstall asdf
mv ~/.asdf ~/.asdf.backup
exec zsh
```

Keep the backup temporarily. After confirming that no required tools or global packages are missing:

```sh
rm -rf ~/.asdf.backup
```

## 8. Update project documentation

Replace instructions that say:

```sh
asdf install
```

with:

```sh
mise install
```

Known documentation containing asdf instructions includes:

- `~/Sites/meljac/meljac/GETTING_STARTED.md`
- `~/Sites/spherical/living-infra-website/README.md`
- `~/Sites/spherical/field-kit/README.md`
- `~/Sites/littleplains/little-plains/README.md`
- `~/Sites/littleplains/sonata-web/README.md`
- Several projects under `~/Sites/sanctuary/`
- `~/Sites/teaching/kelley-workspace/docs/syllabus/000-setup/HOMEWORK.md`
