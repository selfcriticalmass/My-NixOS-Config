# Determinate Nix manages /etc/nix/nix.conf itself.
# Custom settings go in /etc/nix/nix.custom.conf, managed declaratively here.
# The standard `nix.*` module options below still apply — the Determinate
# module redirects their generated output into nix.custom.conf, which
# determinate-nixd includes from its managed nix.conf.
{ config, lib, ... }:

{
  nix = {
    settings.auto-optimise-store = true;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  environment.etc."nix/nix.custom.conf" = {
    text = ''
      # Managed by NixOS (modules/nixos/determinate.nix) — do not edit manually.

      # Parallel evaluation: 0 = use all available cores
      eval-cores = 0
    '';
    mode = "0644";
  };
}
