# xenmux

A NixOS module to easily choose different Xen versions. 

## Usage

In your nixos configuration:

```
imports = [ xenmux ];

xenmux = {
  enable = true;
  version = "4.20.1";
};
```

The upstream Xen module does not support all boot configurations.
We recommend to use EFI boot and the `systemd-boot` bootloader.

When building VMs, nixos usually utilizes QEMU's direct kernel boot, which is problematic because the VM-run script will directly load the linux kernel, skipping your configured bootloader and Xen kernel.
Force to build a qcow2 image instead:

```
virtualisation.useBootLoader = true;
virtualisation.installBootLoader = true;
virtualisation.useEFIBoot = true;
```

## Supported Xen Versions

There is a nixosTest for each Xen version that boots a VM with that version and verifies that `xl info` reports the expected version string.

| version | working |
|---------|---------|
| 4.20.3  | ✅      |
| 4.20.2  | ✅      |
| 4.20.1  | ✅      |
| 4.20.0  | ✅      |
| 4.19.5  | ✅      |
| 4.19.4  | ✅      |
| 4.19.3  | ✅      |
| 4.19.2  | ✅      |
| 4.19.1  | ✅      |
| 4.19.0  | ✅      |
| 4.18.5  | ✅      |
| 4.18.4  | ✅      |
| 4.18.3  | ✅      |
| 4.18.2  | ✅      |
| 4.18.1  | ✅      |
| 4.18.0  | ✅      |
| 4.17.6  | ✅      |
| 4.17.5  | ✅      |
| 4.17.4  | ✅      |
| 4.17.3  | ✅      |
| 4.17.2  | ✅      |

