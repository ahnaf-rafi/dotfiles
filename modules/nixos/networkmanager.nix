{ config, pkgs, lib, ...}:

{
  networking = {

    # Use NetworkManager (nmcli or nmtui) for configuring network connections.
    networkmanager = {
      enable = true;
      wifi.backend = "wpa_supplicant";
      plugins = with pkgs; [ networkmanager-openconnect ];
    };

  };

  environment.systemPackages = with pkgs; [ networkmanagerapplet ];

  # Allow legacy crypto for eduroam (lowers OpenSSL security level for
  # wpa_supplicant only)
  systemd.services.wpa_supplicant.environment.OPENSSL_CONF = pkgs.writeText "openssl.cnf" ''
    openssl_conf = openssl_init

    [openssl_init]
    ssl_conf = ssl_sect

    [ssl_sect]
    system_default = system_default_sect

    [system_default_sect]
    Options = UnsafeLegacyRenegotiation
    CipherString = DEFAULT:@SECLEVEL=0
  '';
}
