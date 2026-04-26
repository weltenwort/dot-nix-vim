---
name: nixvim-config
description: Configure this nixvim flake — add or modify modules, variants, plugins, LSP servers, formatters, and linters. Use when editing files under modules/ or variants/, enabling nixvim plugins, wiring new languages, adding new variants to flake.nix, or troubleshooting `nix build` of this flake.
license: MIT
compatibility: opencode
metadata:
  audience: nixvim-users
  workflow: nix-flake
---

## When to use this skill

Load this skill when the task involves any of:

- Editing files under `modules/` or `variants/`.
- Adding or configuring a nixvim plugin (`plugins.<name>.enable`, `plugins.<name>.settings`).
- Adding a language (LSP + formatter + linter) to the editor.
- Adding a new variant package to `flake.nix`.
- Diagnosing `nix build`, `nix flake check`, or `nix run` failures originating from this repo.

## Repo layout

- `flake.nix` — wires nixvim via `nixvim.makeNixvimWithModule` and exposes one package per variant under `perSystem.packages`. The `default` package points at the `simple` variant.
- `variants/*.nix` — top-level, user-facing configs. A variant `imports` feature and language modules and sets baseline `opts`, `globals`, `keymaps`, and any plugin configuration that is specific to that persona.
- `modules/*.nix` — reusable fragments that get imported by variants. Two patterns:
  - **Feature modules** (e.g. `modules/lint.nix`) — enable and configure a single nixvim plugin in one place.
  - **Language modules** (e.g. `modules/lang-nix.nix`) — wire LSP server + formatter-by-ft + linter-by-ft + any CLI tools into `extraPackages` for one language.

## Module conventions

Follow the shape already used in this repo:

```nix
{ pkgs, lib, ... }: {
  config = {
    # plugin enables, settings, extraPackages, keymaps, etc.
  };
}
```

- Arguments: accept `{ pkgs, lib, ... }` (or `{ ... }` when neither is needed, as in `modules/lint.nix`).
- Wrap everything in a top-level `config = { ... };` attrset. Nixvim merges `config.plugins.<name>` across all imported modules, so it is fine (and encouraged) to split plugin configuration across multiple modules.
- When you need Lua values, raw expressions, or helpers like `listToUnkeyedAttrs` / `mkRaw`, bind `helpers = lib.nixvim` inside a `let` block (see `variants/simple.nix` for the pattern around `plugins.mini.modules.clue`).
- Keep user-facing ergonomics (keymaps, `opts`, `globals`) in the **variant**, not in feature modules. Feature modules should stay reusable across variants.

## How to add a plugin

1. Decide where it belongs:
   - Cross-cutting feature used by multiple variants → new file in `modules/`.
   - Variant-specific → add directly inside `variants/<variant>.nix`.
2. Enable it:
   ```nix
   config.plugins.<name>.enable = true;
   ```
3. Configure it via `plugins.<name>.settings` (upstream plugin options) and any nixvim-specific sub-attributes (e.g. `keymaps`, `autoCmd`, `modules`). Use `helpers.mkRaw "<lua expr>"` for raw Lua.
4. If the plugin shells out to a CLI (ripgrep, fd, language servers, formatters…), add the binary to `extraPackages`:
   ```nix
   config.extraPackages = [ pkgs.ripgrep ];
   ```
5. If the plugin belongs in a new module, `imports` it from the variants that need it.

## How to add a language

Mirror `modules/lang-nix.nix`. Create `modules/lang-<lang>.nix`:

```nix
{ pkgs, ... }: {
  config = {
    extraPackages = [
      pkgs.<formatter-or-linter-cli>
    ];

    plugins.conform-nvim.settings.formatters_by_ft = {
      <filetype> = [ "<formatter-name>" ];
    };

    plugins.lint.lintersByFt = {
      <filetype> = [ "<linter-name>" ];
    };

    plugins.lsp.servers.<server-name>.enable = true;
  };
}
```

Then add `../modules/lang-<lang>.nix` to the `imports` list of any variant that should ship it (e.g. `variants/simple.nix`).

Notes:
- The LSP umbrella (`plugins.lsp.enable = true;`) and conform/lint plugin enables already live in the variant or in feature modules — the language module only adds its per-filetype entries; do not re-enable the plugins in the language module.
- The `formatters_by_ft` key uses filetype names (e.g. `nix`, `python`, `javascript`), not file extensions.

## How to add a variant

1. Create `variants/<name>.nix` with the same skeleton as `variants/simple.nix`:
   ```nix
   { pkgs, lib, ... }: {
     imports = [
       ../modules/lint.nix
       # ...language and feature modules
     ];
     config = {
       globals = { ... };
       opts = { ... };
       # plugins, keymaps, etc.
     };
   }
   ```
2. Wire it up in `flake.nix` inside `perSystem`, next to `simpleNvim`:
   ```nix
   <name>Nvim = nixvim.makeNixvimWithModule {
     inherit pkgs;
     module = import ./variants/<name>.nix;
   };
   ```
   Then expose it under `packages`:
   ```nix
   packages.<name> = <name>Nvim;
   ```
   Update `packages.default` only if this new variant should become the default build.

## Discovering nixvim options

Two authoritative sources:

- **Options search site:** https://nix-community.github.io/nixvim/ — search by plugin or option name for attribute paths, types, defaults, and usage examples. This is the fastest way to confirm `plugins.<name>.settings.*` shape.
- **Source repository:** https://github.com/nix-community/nixvim — when the search site is ambiguous, incomplete, or out of date:
  - Browse `plugins/` and `modules/` for the authoritative module definition and its option types.
  - Check `tests/` for realistic, working configuration snippets.
  - Cross-reference issues and recent commits, especially for options introduced after the nixvim rev pinned in `flake.lock`.

Always match the option surface to the pinned revision in `flake.lock`, not the latest docs, if the two disagree.

## Testing changes

After every change to a module, variant, or `flake.nix`:

1. `nix flake check` — catches evaluation errors and option typos without a full build.
2. `nix build .#simple` (or `.#default`, or the variant you changed) — verifies the full nixvim closure builds.
3. `nix run .#simple` — smoke-test the resulting Neovim interactively when behavior, not just evaluation, matters.

Do not declare a task complete until at least `nix flake check` and `nix build` succeed for the affected variant(s).

## Gotchas

- The skill directory name must be `nixvim-config` and match the `name:` field in this frontmatter.
- Never hand-edit `flake.lock`; run `nix flake update` (or `nix flake lock --update-input <name>`) instead.
- `variants/simple.nix` currently binds `<leader>ph` twice (lines ~224–232, once for `:Pick help` and once for `:Pick files`). Treat this as a known example of the kind of silent conflict to watch for — only fix it if the user asks.
- Feature modules should not set `opts`, `globals`, or user keymaps; keep those in variants so modules stay composable.
- When adding `extraPackages`, prefer packages from `pkgs` of the flake's `nixpkgs` input (already pinned via `nixvim/nixpkgs` in `flake.nix`) to avoid version skew against nixvim-managed tooling.
