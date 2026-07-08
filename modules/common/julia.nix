{ pkgs, lib, ... }:

let
  juliaExtraLibPath =
    "${pkgs.julia}/lib/julia:"
    + lib.makeLibraryPath (with pkgs; [
      # Provides libquadmath.so.0 and related GCC runtime libraries.
      gcc.cc.lib

      # Common runtime libraries useful for Julia JLL artifacts.
      zlib
      zstd
      bzip2
      xz
      curl
      openssl
      libxml2
    ]);

  juliaWrapped = pkgs.writeShellScriptBin "julia" ''
    export LD_LIBRARY_PATH="${juliaExtraLibPath}''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"
    exec -a "$0" ${pkgs.julia}/bin/julia "$@"
  '';
in
{
  environment.systemPackages = [
    juliaWrapped
  ];
}
