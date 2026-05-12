{ pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  virtualisation.xen.enable = true;
  virtualisation.useBootLoader = true;
  virtualisation.installBootLoader = true;
  virtualisation.useEFIBoot = true;
  environment.systemPackages = with pkgs; [
    pciutils
  ];
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
}
