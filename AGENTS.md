# AGENTS.md

Personal nixvim flake. Small repo — the hard-earned context lives in the
`nixvim-config` skill at `.agents/skills/nixvim-config/SKILL.md`. Load that
skill whenever the task touches `flake.nix`, `modules/`, or `variants/`.

## Layout

- `flake.nix` — wires nixvim via `nixvim.makeNixvimWithModule`, exposes one
  package per variant under `perSystem.packages`. `default` currently aliases
  the `simple` variant.
- `variants/*.nix` — user-facing configs. Import modules, set `opts`,
  `globals`, `keymaps`.
- `modules/*.nix` — reusable fragments. Two patterns in use: feature modules
  (`lint.nix`) and language modules (`lang-nix.nix`). Keep keymaps/opts out
  of modules; put them in variants.

## Commands

- `nix flake check` — fast evaluation check, run first after any change.
- `nix build .#simple` (or `.#<variant>`) — verify the closure builds.
- `nix run .#simple` — launch the resulting Neovim to smoke-test behavior.
- `nix flake update` — bump inputs. Never hand-edit `flake.lock`.

Do not mark work complete until at least `nix flake check` and `nix build`
pass for the affected variant.

## Conventions

- Module shape is always `{ pkgs, lib, ... }: { config = { ... }; }` (drop
  unused args as `modules/lint.nix` does). Nixvim merges `config.plugins.*`
  across all imports — split freely.
- Use `helpers = lib.nixvim` inside a `let` block for `mkRaw`,
  `listToUnkeyedAttrs`, etc. (see `variants/simple.nix`).
- Language modules add per-filetype entries only; the base
  `plugins.lsp.enable`, `plugins.conform-nvim.enable`, and `plugins.lint.enable`
  already live in the variant / feature modules — do not re-enable.
- Supported systems in `flake.nix`: `aarch64-linux`, `x86_64-linux`,
  `aarch64-darwin`. Add `x86_64-darwin` only if a user explicitly needs it.

## Discovering nixvim options

- https://nix-community.github.io/nixvim/ — option search.
- https://github.com/nix-community/nixvim — source, tests, and recent changes.
  When docs disagree with the flake, trust the revision pinned in `flake.lock`
  (currently `nix-community/nixvim` rev `e61a31b…`).

## Known quirks

- `variants/simple.nix` binds `<leader>ph` twice (`:Pick help` and
  `:Pick files`, ~lines 224–232). Silent conflict; only fix if the user asks.
- No CI, no formatter config, no tests beyond `nix flake check` / `nix build`.
- No `opencode.json`; skill discovery relies on `.agents/skills/`.
