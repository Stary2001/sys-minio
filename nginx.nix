{ config, pkgs, ... }: {
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts = {
      "minio.9net.org" = {
        enableACME = true;
        forceSSL = true;
      };
  };

  security.acme = {
    acceptTerms = true;
    defaults = { email = "chloe@9net.org"; };

    certs = { };
  };
}
