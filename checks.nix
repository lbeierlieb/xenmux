{ pkgs }:
{
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
}
