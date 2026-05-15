pkgs:
let
  lib = pkgs.lib;
  xen_version_test =
    version:
    pkgs.testers.runNixOSTest {
      name = "xen${lib.replaceStrings [ "." ] [ "_" ] version} boot";
      nodes.machine =
        { pkgs, ... }:
        {
          imports = [ (import ./xenmux.nix) ];

          xenmux = {
            enable = true;
            inherit version;
          };

          boot.loader.systemd-boot.enable = true;
          virtualisation.useBootLoader = true;
          virtualisation.installBootLoader = true;
          virtualisation.useEFIBoot = true;
          systemd.services.renamehvc = {
            wantedBy = [ "backdoor.service" ];
            requires = [
              "dev-hvc0.device"
              "dev-hvc1.device"
            ];
            before = [
              "backdoor.service"
            ];
            serviceConfig.Type = "oneshot";
            script = ''
              mv /dev/hvc1 /dev/hvc0
            '';
          };
        };
      testScript = ''
        machine.succeed("xl info | grep xen_version | grep ${version}")
      '';
    };
in
lib.listToAttrs (
  map (version: {
    name = "xen${lib.replaceStrings [ "." ] [ "_" ] version}";
    value = xen_version_test version;
  }) (import ./xen_versions.nix)
)
