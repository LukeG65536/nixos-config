{ config, pkgs, ... }:

{

  imports = [
    ./hardware-configuration.nix
  ];

  services.udev.extraRules = ''
    SUBSYSTEM=="input", ATTRS{name}=="ELAN9008:00 04F3:2C8C Stylus", ENV{LIBINPUT_IGNORE_DEVICE}="1"
  '';

  services.gnome.gnome-keyring.enable = true;


  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.systemPackages = with pkgs; [
    lolcat
  ];


  programs.fish.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config/#laptop";
  };
}
