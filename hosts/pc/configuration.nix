{ config, pkgs, ... }:

{

  imports = [
    ./hardware-configuration.nix
  ];


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
