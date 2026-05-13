{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.xenmux;
  xen_source_hash = {
    "4.20.3" = "+qTHIsDD2A5lVwmpJ7artnzdviT1XN05CYeu7JFxfqc";
    "4.20.2" = "ZDPjsEAEH5bW0156MVvOKUeqg+mwdce0GFdUTBH39Qc";
    "4.20.1" = "mqVuMqvSNIEGynnVHvg8M/4DG7sDls3tf32EQsn0PsI";
    "4.20.0" = "jmWixFEUa2h5L7nwVhk1W6wB4KZyhi7VDKVGpJi2w80";
    "4.19.5" = "Sd350dK03SrLOyBrmrEkSKi7lkS7rH19ygJUEIIeI7Q";
    "4.19.4" = "lG6KDBuh07jL/sWbrv26YpZZYWEG4SA36opVzK/mlNE";
    "4.19.3" = "U4a071Ryf7XxJaTLsTpi1pWGQozFAT57f8kgSsCIJ2w";
    "4.19.2" = "3jgSgTozlx+XwH5xZBgS9JL6V/tfI6RMclMNIxQ8JNo";
    "4.19.1" = "GZ/Y1uHta/XgrXVV+we6dTWgSo5Z6qgYe0qAs9bjsjY";
    "4.19.0" = "Y7EKojIBu/x1NDj7MZc20uDcCWA8RYdpw158NiCBZes";
    "4.18.5" = "DhRRHsximX0YDJHI9Y5nVL6Vn0yO4w9bCWhEy0sPhZg";
  };
  xen_extra_patches = { };
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
      patches = lib.take 1 old.patches ++ (xen_extra_patches.${version_string} or [ ]);
      configureFlags = (old.configureFlags or [ ]) ++ [ "--disable-ocamltools" ];
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
