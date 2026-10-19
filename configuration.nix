{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    # Core
    ./modules/nixos/determinate.nix
    ./modules/nixos/bootloader.nix
    ./modules/nixos/locale.nix
    ./modules/nixos/networking.nix

    # Hardware & Services
    ./modules/nixos/audio.nix
    ./modules/nixos/DNS.nix
    ./modules/nixos/printing.nix
    ./modules/nixos/xserver.nix

    # Applications
    ./modules/nixos/postgres.nix
    ./modules/nixos/waydroid.nix
  ];

  programs.nix-ld.enable = true;

  users.users.rijan = {
    isNormalUser = true;
    description = "Rijan";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.fish;
  };

  home-manager.users.rijan = import ./modules/home-manager/rijan.nix;

  # Needed so Fish is added to /etc/shells
  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    plink2
    mzmine
    snpeff
    edge-tts
    ferrite
  ];

  # system.autoUpgrade is intentionally disabled. It rebuilt from the flake
  # as committed on GitHub, whose flake.lock lags behind this working tree,
  # so it re-activated an old nixpkgs closure at every boot/04:00 and kept
  # two full sets of packages (julia, rustc, zoom, ...) alive in the store.
  # Update deliberately with scripts/update-nixos.sh instead.

  # Do NOT change after initial install — breaks stateful services.
  # To upgrade NixOS, update the nixpkgs input in flake.nix instead.
  system.stateVersion = "25.05";

  # Nix config is now managed by Determinate Nix (see modules/nixos/determinate.nix)
}
