{ pkgs, lib, ... }:

{
  environment.systemPackages = [
    pkgs.julia-bin
  ];

  programs.nix-ld = {
    enable = true;

    libraries = with pkgs; [
      # Provides libquadmath.so.0 and related GCC runtime libraries
      gcc.cc.lib

      # Common runtime libraries useful for Julia JLL artifacts
      zlib
      zstd
      bzip2
      xz
      curl
      openssl
      libxml2
    ];
  };
}
