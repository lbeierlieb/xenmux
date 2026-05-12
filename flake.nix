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
      checks = {
        xen4_20 = pkgs.testers.runNixOSTest {
          name = "xen4_20 boot";
          nodes.machine =
            { pkgs, ... }:
            {
              imports = [ (import ./xenmux.nix) ];
            };
          testScript = ''
            machine.wait_for_unit("multi-user.target", timeout=300)
            machine.succeed("cat /sys/hypervisor/version/major | grep 4")
            machine.succeed("cat /sys/hypervisor/version/minor | grep 20")
            machine.succeed("cat /sys/hypervisor/version/extra | grep 2")
          '';
        };
      };
    };
}
