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
    wootility
    openrgb
  ];
  
  services.tailscale.enable = true;

  
  services.hardware.openrgb.enable = true;

  boot.kernelModules = [ "i2c-dev" "i2c-piix4" ]; # or i2c-i801 depending


  programs.fish.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config/#laptop";
  };
  
  programs.fish.shellAliases = {
    re = "nh os switch --update -H pc";
    gre = "cd ~/nixos-config; git add -A; git commit -m \"auto commit gen \"(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | tail -1 | awk '{print $1}'); git push; nh os switch -H pc"; 
  };
}
