# Determinate Nix manages /etc/nix/nix.conf itself and redirects the standard
# NixOS-generated nix.conf to /etc/nix/nix.custom.conf (via
# `environment.etc."nix/nix.conf".target`). Do NOT declare
# `environment.etc."nix/nix.custom.conf"` here — it collides with that target
# and the content is silently discarded. Use `nix.settings.*` instead; those
# end up in the generated nix.custom.conf.
{ ... }:

{
  nix = {
    settings = {
      auto-optimise-store = true;

      # Parallel evaluation: 0 = use all available cores
      eval-cores = 0;
    };

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };
  };
}
