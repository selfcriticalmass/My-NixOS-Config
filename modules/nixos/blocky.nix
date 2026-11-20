{ pkgs, ... }:

{
  services.blocky = {
    enable = true;
    settings = {
      # Blocky listens on port 53 for DNS queries
      ports.dns = 53;

      # Upstream DNS servers Blocky will use to resolve non-blocked queries
      upstreams.groups.default = [
        "https://family.cloudflare-dns.com/dns-query" # Cloudflare DoH
      ];
      # Needed to resolve the DoH hostname if no system resolver is available
      bootstrapDns = {
        upstream = "https://family.cloudflare-dns.com/dns-query";
        ips = [ "1.1.1.3" "1.0.0.3" ];
      };

      # Domain blocking configuration
      blocking = {
        # Define blocklist groups
        denylists = {
          # A group using an online list of ad domains
          ads = [
            "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
          ];
          # A group for manual/custom domains (see below for file details)
          custom = [ "/etc/blocky/custom-denylist.txt" ];
        };

        # Apply the lists to clients. `default` applies to everyone.
        clientGroupsBlock = {
          default = [ "ads" "custom" ];
        };
      };
    };
  };

  # Ensure the directory for the custom file exists
  systemd.tmpfiles.rules = [
    "d /etc/blocky 0755 root root -"
  ];
}
