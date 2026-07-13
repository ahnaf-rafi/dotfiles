{
  description = "Ahnaf Rafi's Nix Config";

  inputs = {
    # Nixpkgs stable.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    # Nixpkgs unstable.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Emacs overlay.
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = { self, nixpkgs, emacs-overlay, ... }@inputs: {
    nixosConfigurations = {
      nigel = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/nigel/configuration.nix
        ];
      };

      leonard = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/leonard/configuration.nix
        ];
      };
    };
  };
}
