# Decoupling the Emacs setup into Vim/Neovim and external tools

## 1. Existing features and how to decouple them

This inventory is based on the configuration loaded by
[init.el](.config/emacs/init.el), the modules in
[lisp/](.config/emacs/lisp/), the custom
[snippets](.config/emacs/snippets/), and the literate source
[ar-emacs.org](.config/emacs/ar-emacs.org). It also accounts for the existing
Vim, Neovim, tmux, shell, and Zathura configuration in this repository.
“Configured” describes what the files request; it does not establish that every
package or integration currently works.

**Usage correction:** Julia LSP was abandoned because it repeatedly broke in
Emacs. The remaining `eglot-jl` configuration records an earlier attempt, not a
working feature that must be preserved. LSP is welcome in the proposed setup,
including another attempt at Julia support.

The proposed division of work is:

| Component | Responsibility |
| --- | --- |
| Vim/Neovim | Text editing, buffers, selections, local keybindings, completion, diagnostics, and navigation within source files. |
| Language servers | Semantic completion, definitions, references, hover documentation, and supported refactoring operations. |
| tmux | Persistent project sessions, shells, REPLs, and build processes. |
| Lazygit | Interactive Git status, staging, and branch management from a tmux pane. |
| Yazi | Directory browsing, file operations, bulk renaming, and previews. |
| fzf, fd, and ripgrep | Selecting files, projects, bibliography entries, and search results. |
| Zathura | PDF reading and source/PDF synchronization. |
| Kitty graphics / Sixel | Displaying images within a supporting terminal; Überzug++ is an alternative rendering backend where needed. |
| Bash | Launching and connecting programs; short commands with little structured state. |
| Python | Bibliography processing, structured search output, path handling, and scripts with substantial parsing or state. |

Neovim is the stronger starting point for this arrangement because it includes
an LSP client. Vim remains viable with an LSP client plugin. Most external
commands can be shared between them; the editor adapters will differ. The
installed executables inspected for this note are Neovim 0.12.6 and Vim 9.2;
other machines should be checked separately.

### 1.1. Modal editing, keybindings, and everyday text editing

**Current setup.**
[ar-keybind.el](.config/emacs/lisp/ar-keybind.el),
[ar-leader.el](.config/emacs/lisp/ar-leader.el), and
[ar-editor.el](.config/emacs/lisp/ar-editor.el) provide Evil, Evil Collection,
leader/localleader commands, which-key, visual-line movement, selection-preserving
indentation, surround operations, paired delimiters, and an escape sequence.
They also configure two-space indentation, an 80-column guide, soft wrapping,
trailing-whitespace removal, and undo/redo.

**Decoupling.** Native modal editing
replaces much of this configuration. The existing
[Vim keybindings](.vim/keybinds.vim) and
[Neovim keybindings](.config/nvim/lua/base/keybinds.lua) already preserve the space
leader, `SPC m` localleader, `fd` escape, `gj`/`gk` movement, visual indentation,
and several Emacs-style insert-mode motions.

Use native options for wrapping, indentation, column guides, whitespace display,
and undo. Neovim already enables persistent undo. Add a small save hook if the
Emacs whitespace-cleanup policy is wanted; displaying whitespace does not remove
it. Keep swap/recovery files as well: persistent undo alone does not protect
unsaved edits after a crash.

Simple automatic pairs can use local mappings. An automatic which-key popup
is optional. `:map` and a short keybinding reference cover discovery. Keep `.`
for repeat in Vim and Neovim.

#### 1.1.1. Surround editing

Use `vim-surround` in both editors for a shared setup, or use `vim-surround`
in Vim and `nvim-surround` in Neovim for Lua customization with the same core
keys. Both support `ysiw)` to wrap a word in parentheses, `cs)]` to change
parentheses to brackets, `ds]` to remove brackets, and `S)` to wrap a visual
selection. The closing delimiter in `ysiw)` produces `(word)` without padding.

| Plugin | Editors | Pros | Tradeoffs |
| --- | --- | --- | --- |
| `vim-surround` | Vim and Neovim | Familiar Evil Surround commands and one configuration across both editors. Supports common delimiters and tags. | Upstream recommends `vim-repeat` for dot-repeat of `ds`, `cs`, and `yss`. Custom pairs use Vimscript. [vim-surround](https://github.com/tpope/vim-surround), [vim-repeat](https://github.com/tpope/vim-repeat) |
| `nvim-surround` | Neovim | Same core keys, built-in dot-repeat, and buffer-local Lua customization. Optional Tree-sitter integration for defining surrounds. | Neovim only. Extra matching and customization are most useful once there is a specific surround to add. [nvim-surround](https://github.com/kylechui/nvim-surround) |
| `mini.surround` | Neovim | Available as a standalone module with dot-repeat, configurable search for previous or next pairs, and find/highlight commands. | Defaults are `sa`, `sd`, and `sr`. Remap to preserve muscle memory or learn the new keys. The default `s` prefix takes over Vim's normal-mode `s`. [mini.surround](https://nvim-mini.org/mini.nvim/doc/mini-surround.html) |
| `vim-sandwich` | Vim and Neovim | Filetype recipes support more complex pairs, including LaTeX quotations and math delimiters. | More configuration to learn. Defaults use an `s` prefix, with surround-style mappings available. [VimTeX's comparison](https://github.com/lervag/vimtex/blob/master/doc/vimtex.txt) |

Load one general surround plugin per editor. Let VimTeX handle TeX-specific
changes such as `dse` for removing an environment wrapper or `ds$` for removing
math delimiters. Review overlapping mappings in a TeX buffer if adding custom
recipes. [VimTeX help](https://github.com/lervag/vimtex/blob/master/doc/vimtex.txt)

### 1.2. Buffers, windows, frames, and persistent sessions

**Current setup.**
[ar-bufwinframes.el](.config/emacs/lisp/ar-bufwinframes.el) provides buffer
switching, Ibuffer, reloading, splits, and frame commands. The
[Emacs service](.config/systemd/user/emacs.service) starts a daemon to which
clients can connect.

**Decoupling: straightforward for the workflow.** Use editor buffers and splits
for source files; use tmux panes and windows for separate processes. Native
`:ls`, `:buffer`, `:bnext`, `:bprevious`, and window commands cover the basic
buffer workflow. Recent files can use the editor's persisted old-file list.

The existing [tmux configuration](.config/tmux/tmux.conf) already has Vim-like
navigation, directory-preserving splits, copy mode, and a status line. A small
project launcher can create or attach to a session containing the editor, a
REPL, and a shell/build pane. Closing a terminal then leaves those processes
running while the tmux server survives. Recovery after reboot is a separate
problem; saving a layout does not preserve a live Julia process.

Neovim's server interface can reopen files in an existing editor. Multiple
independent editor processes do not share buffers as Emacs daemon frames do.
Choose one editor process per project when shared state matters, and identify
its server explicitly. Fullscreen and font-size changes belong to the terminal
and window manager.

### 1.3. Files, directories, project roots, and remote work

**Current setup.**
[ar-files.el](.config/emacs/lisp/ar-files.el) configures Dired/Dirvish, editable
directory operations, recent files, path copying, and external opening of Office
documents. [ar-projects-vc.el](.config/emacs/lisp/ar-projects-vc.el) uses
`project.el`, with `.project` and `Project.toml` as additional root markers.
Dirvish also contains remote/sudo shortcuts; one SSH entry is a placeholder.

**Decoupling: use Yazi for interactive file management.** It is a good match for
the Dired/Dirvish role: directory navigation, selection, copying/moving,
renaming, trash, tabs, and previews. It also uses fd/ripgrep for searches and
fzf for navigation. Yazi is already listed in
[the Arch setup instructions](setup-instructions-arch.org).
Native netrw can remain a basic fallback. The repository already has
[cdg-path-handler](bin/cdg-path-handler), [cdgadd](bin/cdgadd),
[cppath](bin/cppath), and [mycp](bin/mycp).

Start with Yazi in its own tmux pane/window. Set text-file opening to the chosen
editor, PDFs to Zathura, and other documents to their external applications.
An editor plugin is unnecessary for this arrangement. To open files in an
already running Neovim, route the opener to that project's server explicitly.
Launching `$EDITOR` normally creates another editor process.

Yazi's shell wrapper can return its final directory to the calling shell through
`--cwd-file`. Use a shell function for this: a child process cannot change its
parent shell's directory. Keep fzf for quick selections where a full directory
browser would be unnecessary.

Yazi also supports bulk renaming: select several files and invoke rename to edit
their names in `$EDITOR`. This covers much of the editable-directory workflow
without writing a new renaming tool. Reserve Python for specialized rules such
as renaming PDFs from bibliography metadata.

Project selection can build on the directory bookmarks. Define root detection
once, with explicit treatment of nested `Project.toml` files, `.project`
markers, and Git repositories. A Julia package inside a larger repository may
need a different environment root from the repository root. Pass that decision
to the REPL, file search, and language server.

For remote computation, SSH into the host and run tmux, Yazi, and the editor
there. This also puts the language server beside the project dependencies.
Remote file browsing alone does not reproduce TRAMP's handling of remote
processes and environments.

References: [Yazi quick start](https://yazi-rs.github.io/docs/quick-start/) and
[bulk renaming](https://yazi-rs.github.io/docs/configuration/keymap/#rename).

### 1.4. Search, fuzzy selection, and command completion

**Current setup.**
[ar-completion.el](.config/emacs/lisp/ar-completion.el) combines Vertico,
Orderless, Consult, Marginalia, history, Corfu, and Cape. This covers several
different jobs: selecting commands/files, annotated candidate lists, searching
buffers/projects, browsing the kill ring, and completing text at the cursor.
Consult previews are explicitly disabled. [ar-search.el](.config/emacs/lisp/ar-search.el)
adds ripgrep, line search, Evil Snipe, substitution previews, and match counts.

**Decoupling: easy for file/project search; editor integration is still needed.**
Use fzf for choosing candidates, `rg` for finding content, and quickfix/location
lists for retaining results and jumping among them. The shell already loads fzf
integration and defines fd-based search commands in [.bashrc](.bashrc).
Native `/`, `?`, `f`, `t`, and substitution commands cover everyday search;
Neovim's `inccommand` can provide substitution preview. Two-character Snipe
behavior is a separate convenience, not an exact match for native `f`/`t`.

A thin editor command should supply candidates and consume the selected result.
For project text searches, `rg --json` gives Python structured locations without
splitting filenames at colons. For filenames, use NUL-delimited input/output
with fzf. Commands expecting one selection must override the global fzf `-m`
setting. Cancellation should leave the current buffer and directory unchanged.

Searching unsaved text, listing buffers, and browsing registers require data
from the editor. External `rg` only sees saved files. Native word/path completion
and LSP completion cover typing assistance; fzf is the chooser for a different
part of the workflow. An fzf editor plugin is optional if maintaining the thin
adapter becomes more work than using an existing one.

### 1.5. LSP, diagnostics, symbols, and completion

**Current setup.**
[ar-coding-tools.el](.config/emacs/lisp/ar-coding-tools.el) configures Eglot,
Flymake, Consult-Eglot, Eldoc, and Tree-sitter mode selection. Intended features
include diagnostics, symbol search, rename, and documentation, with inlay hints
disabled. TeX/BibTeX explicitly request `texlab`; Julia has the abandoned
`eglot-jl` setup. There is no comparable explicit Python server configuration
in these modules. Nix, Lua, and Markdown have dedicated mode configuration;
Typst has parser registration and a few snippets. Preserve their filetype,
syntax, and indentation support independently of whether a server is enabled.

**Decoupling: a good fit for Neovim's built-in LSP client.** Define server
commands, filetypes, and roots using `vim.lsp.config`, then activate them with
`vim.lsp.enable`. Native diagnostics, hover, references, rename, symbol lists,
and LSP completion avoid requiring a separate completion/UI framework.
`nvim-lspconfig` is an optional collection of maintained server configurations;
the client itself is built in. Its older `require('lspconfig').SERVER.setup`
interface should not be the starting point for new configuration.

For Vim, use one client such as `yegappan/lsp`, with the same external server
executables. Language servers and their runtimes still need installation and
version management even when the editor-plugin count is zero.

Keep `texlab` for TeX/BibTeX, and evaluate Julia separately below. Add Python or
other servers when needed. Preserve explicit control over formatting: automatic
server formatting could change the existing LaTeX layout conventions. Likewise,
configure whether VimTeX or LSP supplies TeX completion rather than allowing
attachment order to decide. Tree-sitter parsers provide another capability and
are not a prerequisite for LSP; start with existing syntax support and add
parsers only for a specific editing need.

References: [Neovim LSP](https://neovim.io/doc/user/lsp/),
[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig),
[Vim LSP](https://github.com/yegappan/lsp), and
[texlab](https://github.com/latex-lsp/texlab).

### 1.6. Julia LSP: a fresh attempt with isolated dependencies

**Actual usage.** Julia LSP was stopped because it repeatedly broke in Emacs.
[ar-julia.el](.config/emacs/lisp/ar-julia.el) still contains `eglot-ensure`,
`eglot-jl-init`, and a long connection timeout. Those declarations do not
override that usage history.

**Assessment.** Neovim offers a direct, inspectable way to launch the server and
check attachment. That should make editor-side setup easier to reason about.
It will still use `LanguageServer.jl`, so Julia/package compatibility, environment
selection, and indexing problems can remain. The available evidence does not
identify which of these caused the previous failures.

For the first attempt, use the maintained `julials` configuration from
`nvim-lspconfig`. The upstream Julia instructions use a dedicated environment at
`~/.julia/environments/nvim-lspconfig`, containing `LanguageServer`,
`SymbolServer`, and `StaticLint`, and enable it with
`vim.lsp.enable('julials')`. Treat the following as the design for making that
setup reproducible:

1. Record the Julia executable/version and the working server package manifest.
   Update this environment deliberately, with a recoverable previous version.
2. Keep the **server installation environment** separate from the **research
   project being analyzed**. Pass the research environment explicitly when
   necessary. Installing the server into every paper's `Project.toml` adds
   unrelated dependencies to the research project.
3. Make the launch command inspectable. Use `--startup-file=no` for the server
   to avoid interactive startup customizations affecting it. Keep protocol
   stdout free of shell messages and logging.
4. Validate the server packages with the chosen executable before debugging
   editor attachment. Then check `:checkhealth vim.lsp` and the LSP log for the
   actual command, project root, initialization, and diagnostics.
5. Try a small Julia project first, then one real research project. Check a
   dependency import, completion, hover, definition lookup, diagnostics, and a
   cold restart. Allow time for initial compilation/indexing.
6. Keep REPL execution operational when LSP is disabled or restarting.

A custom launcher remains possible: the LanguageServer documentation exposes a
server environment and a separate analyzed environment. Use that route only if
the maintained configuration cannot express the required setup. Successful
package loading by itself is not an end-to-end LSP test.

References: [Julia's Vim/Neovim setup instructions](https://github.com/julia-vscode/LanguageServer.jl/wiki/Vim-and-Neovim)
and [LanguageServer.jl usage](https://github.com/julia-vscode/LanguageServer.jl).

### 1.7. Julia, Python, and other REPLs

**Current setup.** Julia has `julia-repl` backed by vterm, line/region sending,
and `--threads=auto --project=@.`. It also has LaTeX-style Unicode substitution
on Tab. The custom hooks are attached to `julia-mode`, while `.jl` files are
also assigned to `julia-ts-mode`; the files alone do not establish whether all
bindings reach the mode used in practice.

The existing Neovim [Julia](.config/nvim/after/ftplugin/julia.lua) and
[Python](.config/nvim/after/ftplugin/python.lua) files open terminal REPLs.
They do not implement active line/selection sending. The Julia launcher there
also lacks the explicit project/thread flags from the Emacs configuration;
interactive shell aliases should not be relied upon by editor process launches.

**Decoupling: strong fit for tmux and a small adapter.** Start Julia explicitly
in the chosen project directory with `julia --project=@. --threads=auto`.
Store a stable tmux pane ID for each REPL, and send selected source to that pane.
The session then survives editor restarts. Python and R can use the same
transport with language-specific paste behavior.

There are two reasonable implementations:

| Approach | Work required |
| --- | --- |
| A `repl-send` script plus editor mappings | The editor extracts a line or exact selection. The script accepts text on stdin, addresses a specific tmux pane, and pastes through a uniquely named tmux buffer. Handle bracketed paste, submission, and missing/stale targets explicitly. |
| `vim-slime` | One plugin provides selection sending to tmux, Neovim terminals, and Vim terminals. Configure the target and paste behavior, then reuse the existing localleader keys. |

For a custom sender, use tmux buffer loading/pasting rather than constructing
shell commands from source text. Preserve indentation, quotes, Unicode, and
newlines. Python compound statements and Julia multiline expressions need
explicit trials in the chosen REPL. A line, a characterwise selection, and a
rectangular selection are distinct operations; define supported behavior.

Sending a whole file can instead use a language-specific file-execution command,
which helps preserve source filenames in errors. Define whether that operation
uses the saved file or current unsaved contents. Neovim terminal channels are
another transport, but their jobs normally share the editor's lifetime.

Unicode entry should work without LSP. A checked-in abbreviation table generated
from Julia's symbol completions, with a small editor lookup command, is a useful
separate feature. Full function/block selection would require syntax awareness;
start with lines and explicit visual selections.

References: [vim-slime targets](https://github.com/jpalardy/vim-slime) and
[paste configuration](https://github.com/jpalardy/vim-slime/blob/main/doc/vim-slime.txt).

### 1.8. LaTeX compilation, errors, and source/PDF synchronization

**Current setup.**
[ar-latex.el](.config/emacs/lisp/ar-latex.el) requests AUCTeX, master-file
compilation, SyncTeX, PDF Tools refresh, cleaning, and `texlab` diagnostics.
The default command is `LaTeXMk`, but the calls loading/configuring the bundled
`auctex-latexmk.el` are commented out. Registration of that command cannot be
assumed from the tracked configuration alone.

**Decoupling: compilation is easy; editor/viewer routing needs care.** Put engine
and bibliography build settings in a project `.latexmkrc` or build command.
Run `latexmk` in a tmux pane, with SyncTeX enabled and the intended master file
selected. A continuous build is useful, but should have a single owner: avoid
starting competing watchers from tmux, VimTeX, and LSP.

For an editor-native experience, **VimTeX is a worthwhile plugin**. It supports
builds, TeX log parsing into quickfix, document navigation, and viewer integration.
It works with both Vim and Neovim. Alternatively, keep the build command external
and import its diagnostics into quickfix. TeX logs include wrapped and nested
messages, so a generic `filename:line` parser is only a partial replacement.

The existing [vimura](bin/vimura) is a starting point for inverse search, with
several integration gaps:

- The Neovim branch uses `nvim --remote +%{line}`. Neovim's documented remote
  interface does not support Vim's `+{cmd}` form here. Use an explicit server
  address and an editor callback/RPC operation that opens the file and moves
  the cursor, or use VimTeX's integration.
- A viewer launched outside Neovim needs to know which editor server to target.
  One fixed global name is ambiguous when multiple projects are open.
- Quote viewer arguments and source paths correctly. The current wrapper has
  unquoted shell expansions. Test paths containing spaces.
- Forward search needs the source file, line/column, and the correct output PDF.
  Test included chapter files and separate output directories as well as the
  master file.

For Vim, check the build's client/server capabilities and available backend on
each machine. The interactive `vim` alias is not automatically applied inside
scripts. The viewer must call the intended executable explicitly.

References: [VimTeX](https://github.com/lervag/vimtex),
[Zathura SyncTeX](https://pwmt.org/projects/zathura/documentation/), and
[Neovim remote commands](https://neovim.io/doc/user/remote/).

### 1.9. LaTeX editing, formatting, references, and previews

**Current setup.** AUCTeX, RefTeX, `evil-tex-ts`, and custom functions provide
structural editing and navigation. The configuration has specific formatting
choices: `\(...\)` inline math, braces after `_`/`^`, no extra brace or
`\left` indentation, unchanged indentation in theorem-like environments and
frames, and special list indentation with four-space continuation lines.
RefTeX supplies a contents view and several citation-command formats.
`preview-auto` requests automatic rendered previews in the source buffer.

**Decoupling: mixed.** `latexmk` and Zathura cover the rendered document;
VimTeX provides TeX-aware navigation, text objects, completion, and indentation.
`texlab` supplies semantic assistance. These still require local configuration
to match the exact formatting choices above.

The existing [Neovim TeX file](.config/nvim/after/ftplugin/tex.lua) already covers
80-column text, spell checking, inline math, sub/superscripts, quotation marks,
and some pairing. Its `_`, `^`, and `$` mappings are unconditional, whereas
AUCTeX's behavior is context-sensitive. Add context checks where necessary;
do not assume these mappings reproduce the Emacs behavior in prose, comments,
verbatim material, and math equally well.

Keep indentation and text-object logic close to the editor. A Python formatter
is appropriate for an explicit batch operation, but recreating a TeX parser for
every cursor action is substantial maintenance. Compare representative source
blocks before choosing a formatter or indentation configuration: nested lists,
theorems, frames, aligned equations, and custom macros are the relevant cases.
Preserve custom citation commands and labels when moving the snippets.

Inline rendered previews are the main visual feature without a simple
equivalent in this proposed stack. Zathura provides an external PDF view; it
does not render formulas within the source buffer. Retain occasional Emacs use
if those previews remain valuable, or evaluate additional preview tooling as
a separate decision.

### 1.10. Snippets and reusable text

**Current setup.** Yasnippet loads a substantial custom collection for LaTeX,
Julia, Org, and a few Typst expressions. This includes mirrored environment
names, optional theorem titles/labels, selected-text wrapping, and tab stops.
Some snippets execute Elisp: integrals/sums conditionally add limits, and Julia
loops offer a choice of iteration operator.

**Decoupling: static templates are easy; interactive snippets belong in the
editor.** Plain files inserted with `:read` or abbreviations cover fixed text.
Neovim's built-in `vim.snippet` handles LSP-style snippet expansion and tab-stop
navigation. A small local table and trigger mapping can cover straightforward
custom snippets, but Yasnippet files and their Elisp expressions need conversion.

For the full dynamic collection, one engine such as
[LuaSnip](https://github.com/L3MON4D3/LuaSnip) is reasonable in Neovim. Port the
frequently used snippets first and retain the current key conventions.
A Python conversion helper could translate simple placeholders and flag Elisp
forms for manual rewriting. It should not silently turn dynamic behavior into
literal text.

Bash/Python are useful for generating template content. Tracking live tab stops,
mirrored fields, cursor positions, and undo inside an unsaved buffer is better
handled by the editor or a snippet engine.

### 1.11. Bibliography management, citation keys, and reading lists

**Current setup.**
[ar-bibtex.el](.config/emacs/lisp/ar-bibtex.el) configures BibLaTeX editing,
aligned fields, `texlab`, and custom citation keys. The key combines a
four-digit year, one author name, and three retained title words in CamelCase,
with a substantial stop-word list. [ar-tools.el](.config/emacs/lisp/ar-tools.el)
configures Ebib with `~/Dropbox/bib/bibliography.bib`, associated PDFs under
`~/Dropbox/bib/pdf/`, database merging, and an Org reading list. These paths
are configuration values, not confirmation of the current files' contents.

**Decoupling: an especially good Python use case.** A bibliography command could
parse the database once, offer author/year/title candidates through fzf, and
return a selected key. The same command could open the associated PDF through
Zathura, print an entry, generate a key, or append a reading-list item.
The editor would insert the key or wrap it in the chosen citation command.
[ris2bib](bin/ris2bib) already delegates RIS conversion to external programs.

Use a real BibTeX parser for nested braces, strings, multiline fields, and
concatenated values. Preserve the current key rules, including author-name
handling and ignored title words. Add a collision policy for newly generated
keys. Existing keys should remain stable unless references are migrated too.

Begin with read-only selection and PDF opening. Database rewriting and merging
need further work to retain comments, macros, field order, braces, and encoding.
Ebib's interactive database editor is a larger feature than an fzf picker.
Keeping `.bib` as the source of truth and treating any search index as
rebuildable avoids committing to a second bibliography format.

### 1.12. PDF reading, terminal images, and other document formats

**Current setup.** PDF Tools provides in-editor reading, outlines, page movement,
text copying, and source synchronization. The configuration also loads `nov`
for EPUB and `csv-mode` for CSV. Office documents already open externally.

**Decoupling: PDF reading is already largely in place.**
[zathurarc](.config/zathura/zathurarc), [zath](bin/zath), and
[fzath](bin/fzath) provide viewer settings, detached launching, and fuzzy PDF
selection. Zathura supports the reading/navigation and SyncTeX tasks needed
here. PDF annotation editing should be evaluated separately if it becomes a
requirement; the tracked setup does not establish an annotation workflow.

Repair the picker interface before general reuse: `fzath` consumes a single
selection, while global fzf options allow multiple selections. The same
filename-delimiter and cancellation rules from Section 1.4 apply.
For CSV, Python's `csv` module suits transformations and checks. EPUB reading
can move to a separate reader. Neither requires an editor plugin merely to
keep the document workflow available.

#### 1.12.1. Terminal images: Yazi, Kitty, and Überzug++

Image display can also move outside Emacs. The
[Sway configuration](.config/sway/config) selects Kitty as its terminal, and
both [Kitty](.config/kitty/kitty.conf) and [foot](.config/foot/foot.ini) have
configuration files here. Start with native terminal graphics.

| Task | Proposed tool |
| --- | --- |
| Browse images alongside other files | Yazi's preview pane. |
| Display an image from a Kitty shell | `kitten icat "figure.png"`. |
| Use a general terminal image command | `chafa "figure.png"`; Chafa supports graphics protocols and character-based fallback. |
| Supply a backend when native graphics are unavailable | Überzug++ (`ueberzugpp`). |
| Read and synchronize a complete PDF | Zathura; Yazi previews help select the document. |

Überzug++ draws images for other programs, using terminal protocols or X11/Wayland
windows. It supports Sway and integration with Yazi and fzf. It is useful when
the chosen terminal/application needs such a backend; it does not supply the
file-management interface.

Yazi supports Kitty graphics and foot's Sixel directly, so neither terminal
requires Überzug++ for ordinary Yazi previews. For tmux, Yazi documents these
settings, which are absent from the tracked configuration:

```tmux
set -g allow-passthrough on
set -ga update-environment TERM
set -ga update-environment TERM_PROGRAM
```

Keep `default-terminal` as `tmux-256color`. Try a separate test server before
restarting sessions containing live REPLs. For foot, check that the tmux build
has Sixel enabled. Run `ya env` in the target pane to inspect adapter detection.

Prefer a real terminal pane for Yazi. Its documentation reports that Neovim's
embedded terminal lacks graphics protocols; fallback rendering there can need
extra positioning configuration. Graphics in a terminal also do not by
themselves implement source-buffer LaTeX previews: formula rendering and
placement still need integration.

Add preview helpers according to the files used: Poppler for PDFs, `resvg` for
SVG, FFmpeg for video thumbnails, and 7-Zip for archives. A custom script that
produces plots can save an image and invoke `kitten icat` or Chafa. Detailed
inspection with zoom/pan can still use an external image viewer.

References: [Yazi image support](https://yazi-rs.github.io/docs/image-preview/),
[preview dependencies](https://yazi-rs.github.io/docs/installation/),
[Kitty icat](https://sw.kovidgoyal.net/kitty/kittens/icat/),
[Überzug++](https://github.com/jstkdng/ueberzugpp), and
[Chafa](https://hpjansson.org/chafa/).

### 1.13. Spelling, prose editing, and the visual interface

**Current setup.** Jinx checks English through Enchant, with custom exclusions
for selected LaTeX command arguments. Olivetti adjusts the writing view.
Modus themes, JuliaMono, Doom Modeline, icons, and TODO highlighting control
appearance.

**Decoupling: mostly native configuration.** Use Vim/Neovim spell checking,
`]s`/`[s`, `z=`, and `zg`. The Neovim TeX file already enables spelling, and
the repository includes [en.utf-8.add](.config/nvim/spell/en.utf-8.add).
Merge the words from the [Enchant dictionary](.config/enchant/en_US.dic) into
that spellfile, removing duplicates, and let Vim/Neovim rebuild its compiled
spelling file. Test exclusions around labels, citation keys, custom commands,
and math against actual TeX examples.

Keep the font in terminal configuration and use a simple editor status line.
Column guides, wrapping, TODO highlights, and reduced UI need few settings.
A dedicated writing layout can approximate Olivetti's focus, although centered
buffer margins may need a small local function. Theme/icon parity can be
decided after the editing workflow works.

### 1.14. Org files, notes, export, and literate configuration

**Current setup.** [ar-org.el](.config/emacs/lisp/ar-org.el) provides shortcuts to
todo, bookmark, and reading-list files; heading/link/source-block navigation;
checkbox toggling; inline images; LaTeX-fragment preview; and export commands.
There is no custom agenda, capture, or clocking setup in the inspected modules.
The configuration itself is an Org document with an after-save tangling hook.
Org/Jupyter snippets exist, but a configured notebook execution stack was not
found in the loaded modules.

**Decoupling: easy for plain notes, partial for Org semantics.** Editing text,
finding headings, jumping to known files, and maintaining simple checklists can
use native editing plus small scripts. Existing Org syntax can remain in place
while usage is assessed; a format conversion is not necessary to start.

Org export, Babel execution/tangling, and inline previews are richer operations.
Keep Emacs available as a batch tool for exact Org export/tangling, or retain it
for those tasks interactively. An alternative exporter needs validation on the
actual documents; it should not be assumed to reproduce Org behavior exactly.

For the new editor configuration, ordinary commented Lua/Vimscript files fit
the existing repository structure. If the Emacs literate configuration is edited
later, account for its tangling hook so generated `.el` changes are not
accidentally overwritten.

### 1.15. Git, help, and configuration maintenance

**Current setup.** Magit, built-in VC, and Git Gutter provide repository actions
and hunk navigation. Helpful, Elisp Demos, Info, and Eldoc support documentation
and introspection. Elpaca manages packages; several startup functions optimize
Emacs-specific initialization and report timing/package counts.

Keep the Git CLI for scripts and one-off commands. Use **Lazygit** as the
default interactive UI in a project tmux pane. It covers the repository-wide
tasks I use Magit for and works from either Vim or Neovim. Choose **Neogit**
if I prefer Magit's status buffer and command popups inside the editor, or
**Fugitive** if I want the same editor integration in Vim and Neovim.

| Repository UI | Pros | Tradeoffs and upstream docs |
| --- | --- | --- |
| Lazygit | Standalone TUI with line and hunk staging, branch and worktree management, and interactive rebase. | Separate pane and keymap. Editor buffers and their unsaved edits stay in the editor. [Lazygit](https://github.com/jesseduffield/lazygit) |
| vim-fugitive | Works in Vim and Neovim. `:Git` opens interactive status, `:Gdiffsplit` works with the index, and `:Git blame` follows the current file. Diff splits and quickfix fit normal Vim navigation. | Discovering commands and mappings takes some reading. Branch and rebase workflows are more command-oriented than Lazygit's panels or Magit's popups. [Fugitive](https://github.com/tpope/vim-fugitive) |
| Neogit | Closest to Magit inside Neovim. Status sections, inline hunks, and action popups keep staging and commits in the editor. | Neovim only. Built-in diffs are inline. Side-by-side review can use the optional Diffview or CodeDiff integration. [Neogit](https://github.com/NeogitOrg/neogit) |
| vimagit | Magit-style staging in a single `:Magit` buffer in Vim or Neovim. Review folded diffs, stage or unstage files, hunks, or selected lines, and commit or amend in the same buffer. Vimscript with Git as its only external dependency. | Narrower workflow than Fugitive or Neogit. Keep the CLI or Lazygit for pushing, switching branches, stashing, and browsing history. Visual staging is limited to a single hunk at a time. Refreshes rebuild the buffer and can be slow with large diffs or long lines. [vimagit](https://github.com/jreybert/vimagit) |
| Gitu | Standalone TUI with Magit-inspired bindings, line staging, fixup commits, and interactive rebase. | Its documented scope covers a subset of Magit's workflows. Check the operations I rely on before choosing it as the main UI. [Gitu](https://github.com/altsem/gitu) |
| Tig | History, blame, and patch browsing with Git revision and path arguments. The status view also supports staging. | Its main strength is repository inspection. Use Git commands for workflows such as interactive rebase. [Tig manual](https://jonas.github.io/tig/doc/manual.html) |
| GitUI | Standalone TUI with context help and file, hunk, and line staging. | Upstream lists interactive rebase on the roadmap and documents limitations around sparse repositories and HTTPS credentials. [GitUI](https://github.com/gitui-org/gitui) |
| Git Cola | Desktop GUI with visual staging and a commit graph browser. Useful when I want a separate graphical window. | Requires a graphical session and a separate window. For ordinary SSH sessions, use a TUI. [Git Cola manual](https://git-cola.github.io/share/doc/git-cola/html/git-cola.html) |

| Editor add-on | Pros | Tradeoffs and upstream docs |
| --- | --- | --- |
| Gitsigns / vim-gitgutter | Restore change markers, hunk navigation, and local hunk staging. Use Gitsigns in Neovim or vim-gitgutter in Vim. | Scope is the file being edited. Keep a repository UI for branch and commit workflows. [Gitsigns](https://github.com/lewis6991/gitsigns.nvim), [vim-gitgutter](https://github.com/airblade/vim-gitgutter) |
| Diffview | One Neovim tab for reviewing changes across files, browsing file history, and resolving conflicts in a three-way diff. Integrates with Neogit. | Adds a review interface and assumes familiarity with Vim diff commands. [Diffview](https://github.com/sindrets/diffview.nvim) |
| CodeDiff | Neovim review workspace with character-level highlighting, file and hunk staging, and conflict resolution. Also integrates with Neogit. | Uses a native diff library that it downloads by default. Pick one dedicated diff viewer if the workflow calls for it. [CodeDiff](https://github.com/esmuellert/codediff.nvim) |

Start with **Lazygit plus the CLI**. Add Gitsigns if I miss the Emacs Git
Gutter while editing. For TeX review, try `git diff --word-diff` when a
paragraph reflow makes the line diff hard to read.

Use `:help`, `:verbose map`, `:verbose set`, manual pages, and LSP hover for
documentation and configuration inspection. `.bashrc` already chooses Neovim
as the manual-page viewer. Emacs Lisp introspection remains useful when working
on the old setup, but does not need a new counterpart in every tool.

A few pinned editor packages can use native package loading; a large plugin
manager is optional. Keep script configuration independent of either editor.
Emacs garbage-collection, native-compilation, and autoload-generation settings
have no behavior to migrate into the new workflow.

### 1.16. A practical minimal-plugin starting point

The most useful first version would be **Neovim + tmux + Yazi + fzf/fd/rg +
Lazygit + Zathura + latexmk + language servers**, running in Kitty and building on the
files already present here. Use native image previews first and add Überzug++
if a particular terminal/application requires it.
Keep short editor-specific adapters for operations involving buffers,
selections, and cursor placement.

| Editor component | Initial decision | Reason |
| --- | --- | --- |
| Native Neovim LSP and completion | Use | Covers the client side without a separate completion framework. |
| `nvim-lspconfig` | Use for the Julia trial | Reuses maintained server launch/root configuration and upstream setup instructions. |
| VimTeX | Use | The LaTeX workflow justifies its document-aware editing and integration. |
| LuaSnip | Add when porting dynamic snippets | The current collection contains behavior beyond fixed text insertion. |
| `vim-slime` | Choose it or one small custom sender | Particularly useful if both tmux and editor-terminal targets are wanted. |
| Fuzzy finder, file tree, status-line, and key-hint plugins | Defer | Yazi covers file management. Native features and external commands cover the remaining initial workflow. |
| Editor Git plugins | Optional | Start with Lazygit in tmux. Add Gitsigns for hunk markers or choose Neogit or Fugitive for Git inside the editor. |
| General surround plugin | Use | Choose `vim-surround` for both editors or `nvim-surround` in Neovim and `vim-surround` in Vim. |

The initial Neovim setup uses `nvim-lspconfig`, VimTeX, and one surround
plugin. Snippets and REPL transport have separate candidates. Check
plugin/editor version requirements on every machine and pin compatible
revisions.

These are candidate script interfaces for subsequent implementation, not
commands created by this document:

| Proposed command | Language | Purpose |
| --- | --- | --- |
| `project-open` | Bash, or Python if state grows | Choose a project, resolve its roots, and create/attach to its tmux session. |
| `file-pick` | Bash | Return a selected path to a shell function or editor adapter. |
| `project-search` | Python | Convert structured ripgrep results into selections or editor locations. |
| `repl-send` | Bash | Send stdin to a named REPL target, if using the custom transport. |
| `bib-pick` / `bib-key` | Python | Select bibliography records and implement the existing citation-key policy. |
| `tex-build` | Bash | Invoke a project's latexmk settings from a predictable directory. |
| `tex-view` / `tex-inverse` | Bash/Python plus an editor callback | Route PDF/source locations if that work is not delegated to VimTeX. |
| `julia-lsp` | Bash, only if needed | Launch the isolated server with explicit runtime and project arguments. |

Give each operation one owner. Scripts should expose useful standalone commands;
the editor supplies current-buffer information and applies results. Preserve
exit status, use argument lists/quoting for paths, and keep diagnostics separate
from machine-readable output.

Start by verifying one LaTeX project and one Julia project end to end. The
important checks are source/PDF synchronization from an included file, the
existing indentation/snippet conventions, accurate line/selection sending,
REPL survival across editor restart, and Julia LSP behavior across a cold
restart. Full Ebib editing, inline previews, and Org export are the larger
remaining decisions. This inventory proposes the separation; it does not claim
that those replacements have already been implemented or tested.
