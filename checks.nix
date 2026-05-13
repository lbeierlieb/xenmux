{ pkgs }:
let
  xen_version_test =
    {
      major,
      minor,
      extra,
    }:
    let
      maj = toString major;
      min = toString minor;
      ex = toString extra;
    in
    pkgs.testers.runNixOSTest {
      name = "xen${maj}_${min}_${ex} boot";
      nodes.machine =
        { pkgs, ... }:
        {
          imports = [ (import ./xenmux.nix) ];

          xenmux = {
            enable = true;
            inherit major minor extra;
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
        machine.succeed("cat /sys/hypervisor/version/major | grep ${maj}")
        machine.succeed("cat /sys/hypervisor/version/minor | grep ${min}")
        machine.succeed("cat /sys/hypervisor/version/extra | grep ${ex}")
      '';
    };
in
{
  xen4_20_3 = xen_version_test {
    major = 4;
    minor = 20;
    extra = 3;
  };
  xen4_20_2 = xen_version_test {
    major = 4;
    minor = 20;
    extra = 2;
  };
  xen4_20_1 = xen_version_test {
    major = 4;
    minor = 20;
    extra = 1;
  };
  xen4_20_0 = xen_version_test {
    major = 4;
    minor = 20;
    extra = 0;
  };
  xen4_19_5 = xen_version_test {
    major = 4;
    minor = 19;
    extra = 5;
  };
  xen4_19_4 = xen_version_test {
    major = 4;
    minor = 19;
    extra = 4;
  };
  xen4_19_3 = xen_version_test {
    major = 4;
    minor = 19;
    extra = 3;
  };
  xen4_19_2 = xen_version_test {
    major = 4;
    minor = 19;
    extra = 2;
  };
  xen4_19_0 = xen_version_test {
    major = 4;
    minor = 19;
    extra = 0;
  };
}
