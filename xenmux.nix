{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.xenmux;
  xen_packages = import ./xen_packages.nix pkgs;
in
{
  options.xenmux = {
    enable = lib.mkEnableOption "xenmux";
    version = lib.mkOption { };
  };
  config = lib.mkIf cfg.enable {
    virtualisation.xen.enable = true;
    virtualisation.xen.package = xen_packages."xen-${cfg.version}";
  };
}
