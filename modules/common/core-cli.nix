{ config, pkgs, lib, ... }:

{

  programs.bash.enable = true;
  programs.neovim.enable = true;

  environment.systemPackages = with pkgs; [
    vim-full
    git
    curl
    openssl
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
