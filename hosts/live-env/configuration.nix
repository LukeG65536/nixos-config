{ config, lib, pkgs, ... }:

{
  services.gnome.gnome-keyring.enable = true;
  environment.systemPackages = with pkgs; [
    lolcat
    kdePackages.filelight
    kdePackages.partitionmanager
    gparted
  ];

}
