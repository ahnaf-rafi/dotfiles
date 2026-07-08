{ pkgs }:

let
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;

  emacsBaseUnwrapped =
    if isLinux then
      pkgs.emacs-pgtk
    else if isDarwin then
      pkgs.emacs-unstable
    else
      pkgs.emacs-unstable;

  emacsBase = emacsBaseUnwrapped.override {
    withTreeSitter = true;
  };
in
(pkgs.emacsPackagesFor emacsBase).emacsWithPackages (epkgs: with epkgs; [
  # Packages with native components / external helpers.
  pdf-tools
  vterm

  # Tree-sitter integration.
  tree-sitter-langs
  nix-ts-mode
  julia-ts-mode
  typst-ts-mode

  # Treesit grammars.
  (treesit-grammars.with-grammars (grammars: with grammars; [
    tree-sitter-bash
    tree-sitter-toml
    tree-sitter-nix
    tree-sitter-julia
    tree-sitter-typst
    tree-sitter-markdown
    tree-sitter-python
  ]))
  # Can use this for lower maintenance:
  # treesit-grammars.with-all-grammars
])
