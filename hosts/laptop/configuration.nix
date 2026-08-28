{ config, pkgs, ... }:

{

  imports = [
    ./hardware-configuration.nix
  ];


  services.udev.extraRules = ''
    SUBSYSTEM=="input", ATTRS{name}=="ELAN9008:00 04F3:2C8C", ENV{LIBINPUT_IGNORE_DEVICE}="1"
  '';
  

  services.upower.enable = true;

  hardware.nvidia.powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main = {
          capslock = "esc";
        };
      };
    };
  };

  environment.etc."libinput/local-overrides.quirks".text = ''
    [keyd virtual keyboard]
    MatchUdevType=keyboard
    MatchName=keyd*keyboard
    AttrKeyboardIntegration=internal
  '';
 
  services.libinput = {
    enable = true;
  };
  
  services.gnome.gnome-keyring.enable = true;

  virtualisation.docker.enable = true;
  services.tailscale.enable = true;
  users.users.duffy.extraGroups = [ "docker" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  zramSwap.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.systemPackages = with pkgs; [
    lolcat
    kdePackages.filelight
  ];


  programs.fish.shellAliases = {
    re = "sudo nixos-rebuild switch --flake ~/nixos-config/#laptop";
    gre = "cd ~/nixos-config; git add -A; git commit -m auto; git push; sudo nixos-rebuild switch --flake ~/nixos-config/#laptop"; 
  };
}
