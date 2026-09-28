{ config, pkgs, ... }:

{

  imports = [
    ./hardware-configuration.nix
  ];


  networking.hostName = "pc";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.systemPackages = with pkgs; [
    lolcat
    openrgb
    clinfo
    rocmPackages.rocminfo
  ];
  
  services.tailscale.enable = true;

  
  services.hardware.openrgb.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd   # OpenCL ICD for ROCm
    ];
  };


  users.users.duffy.extraGroups = [ "video" "render" ];

  
  boot.kernelModules = [ "i2c-dev" "i2c-piix4" ]; # or i2c-i801 depending
}
