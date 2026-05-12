{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.xenmux;
in
{
  options.xenmux = {
    enable = lib.mkEnableOption "xenmux";
    major = lib.mkOption { };
    minor = lib.mkOption { };
    extra = lib.mkOption { };
  };
  config = lib.mkIf cfg.enable {
    virtualisation.xen.enable = true;
  };
}
