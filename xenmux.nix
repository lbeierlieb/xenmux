{ lib, pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  virtualisation.xen.enable = true;
  virtualisation.useBootLoader = true;
  virtualisation.installBootLoader = true;
  virtualisation.useEFIBoot = true;
  environment.systemPackages = with pkgs; [
    pciutils
  ];
}
