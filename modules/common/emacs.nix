{ config, pkgs, lib, ... }:

let
  emacsBaseUnwrapped =
    if pkgs.stdenv.hostPlatform.isLinux then
      # PGTK / Wayland-friendly build for NixOS.
      pkgs.emacs-unstable-pgtk
      else if pkgs.stdenv.hostPlatform.isDarwin then
      # macOS: use the normal non-PGTK overlay build.
      pkgs.emacs-unstable
      else
      pkgs.emacs-unstable;

  # Defensive. Most current Emacs 29/30 overlay builds should already have
  # tree-sitter support, but this makes the intention explicit when the package
  # supports this override.
  emacsBase = emacsBaseUnwrapped.override {
    withTreeSitter = true;
  };

  emacsWithPackages =
    (pkgs.emacsPackagesFor emacsBase).emacsWithPackages
      (epkgs: with epkgs; [
        # Packages with native components / external helpers.
        pdf-tools
        vterm

        # Tree-sitter integration.
        tree-sitter-langs
        nix-ts-mode
        julia-ts-mode
        typst-ts-mode

        # Native treesit grammar registration.
        #
        # Add more grammars here as you start using more *-ts-mode packages.
        (treesit-grammars.with-grammars (grammars: with grammars; [
          tree-sitter-bash
          tree-sitter-nix
          tree-sitter-julia
          tree-sitter-typst
          tree-sitter-markdown
          tree-sitter-python
        ]))
        # For lower maintenance, one can also use:
        # treesit-grammars.with-all-grammars
      ]);
in
{
  environment.systemPackages = [
    emacsWithPackages
  ];
}
