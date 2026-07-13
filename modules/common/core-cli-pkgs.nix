{ config, pkgs, lib, inputs, ... }:

{

  programs.bash.enable = true;
  programs.neovim.enable = true;

  environment.systemPackages = with pkgs; [
    # CLI software
    vim-full
    git
    curl
    zip
    unzip
    stow
    fzf
    fd
    ripgrep
    delta
    htop
    pciutils
    rclone
  ];
}
