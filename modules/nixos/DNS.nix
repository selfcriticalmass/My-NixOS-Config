{ ... }:

{
  # Point system DNS to the local Blocky instance
  networking.nameservers = [ "127.0.0.1" ];

  # Prevent NetworkManager from overwriting /etc/resolv.conf
  networking.networkmanager.dns = "none";
}
