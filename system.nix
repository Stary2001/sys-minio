{ inputs, lib, ... }: {
  networking = {
    useDHCP = false;

    hostName = "minio"; # Define your hostname.
    hostId = "47ff4681";

    useNetworkd = true;
    interfaces = { "enp6s18" = { useDHCP = true; }; };

    nameservers = [ "8.8.8.8" ];
  };

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [
    22 # ssh
    80 # http
    443 # https
  ];
  networking.firewall.allowedUDPPorts = [ ];

  services.openssh.enable = true;

  users.users.stary = {
    isNormalUser = true;
    createHome = true;
    extraGroups = [ "wheel" ];
  };

  services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";

  system.configurationRevision = lib.mkIf (inputs.self ? rev) inputs.self.rev;
}
