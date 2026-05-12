{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.xenmux;
  xen_source_hash = {
    "4.20.2" = "ZDPjsEAEH5bW0156MVvOKUeqg+mwdce0GFdUTBH39Qc";
    "4.20.1" = "mqVuMqvSNIEGynnVHvg8M/4DG7sDls3tf32EQsn0PsI";
  };
  xen_package =
    {
      major,
      minor,
      extra,
    }:
    let
      maj = toString major;
      min = toString minor;
      ex = toString extra;
      version_string = "${maj}.${min}.${ex}";
    in
    pkgs.xen.overrideAttrs (old: {
      version = version_string;
      src = pkgs.fetchFromGitHub {
        owner = "xen-project";
        repo = "xen";
        tag = "RELEASE-${version_string}";
        hash = "sha256-${xen_source_hash.${version_string}}=";
      };
    });
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
    virtualisation.xen.package = xen_package {
      major = cfg.major;
      minor = cfg.minor;
      extra = cfg.extra;
    };
  };
}
