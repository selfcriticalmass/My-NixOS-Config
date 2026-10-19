{ ... }:

{
  virtualisation.waydroid.enable = true;

  # Binder IPC is required by Waydroid. `ashmem_linux` was removed from the
  # kernel (replaced by memfd_create) and no longer exists, so requesting it
  # makes systemd-modules-load fail at boot.
  boot.kernelModules = [ "binder_linux" ];

  # `psi=1` is already set by the nixpkgs waydroid module.

  # After first rebuild: sudo waydroid init
  # Then: waydroid show-full-ui
}
