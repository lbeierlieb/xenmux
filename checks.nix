{ pkgs }:
{
  xen4_20_2 = pkgs.testers.runNixOSTest {
    name = "xen4_20_2 boot";
    nodes.machine =
      { pkgs, ... }:
      {
        imports = [ (import ./xenmux.nix) ];

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
      machine.wait_for_unit("multi-user.target", timeout=300)
      machine.succeed("cat /sys/hypervisor/version/major | grep 4")
      machine.succeed("cat /sys/hypervisor/version/minor | grep 20")
      machine.succeed("cat /sys/hypervisor/version/extra | grep 2")
    '';
  };
}
