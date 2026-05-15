{
  description = "A NixOS module to easily choose different Xen versions.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      xenmux-module = import ./xenmux.nix;
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosModules.default = xenmux-module;
      checks.${system} = import ./checks.nix pkgs;
      packages.x86_64-linux = import ./xen_packages.nix pkgs;
    };
}
