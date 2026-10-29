{ config, lib, pkgs, ... }:

{

  nixpkgs.overlays = [
    (final: prev: {
      khal = prev.khal.overrideAttrs (_: {
        # Nixpkgs' Sphinx hook needs a single string with structured attrs.
        sphinxBuilders = [ "html man" ];
      });
    })
  ];

  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "framework";
  
  environment.systemPackages = with pkgs; [
    framework-tool
    prismlauncher
    lolcat
    kdePackages.filelight
  ];

  services.framework-control.enable = true;

  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["duffy"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;


  services.upower.enable = true;

  services.power-profiles-daemon.enable = true;

  # The current Nixpkgs framework-laptop-kmod package lacks a certificate
  # expected by the kernel module aggregator with linuxPackages_latest.
  hardware.framework.enableKmod = lib.mkForce false;

  zramSwap.enable = true;

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

  systemd.services.docker = {
    after = lib.mkForce [ "firewalld.service" "containerd.service" "time-set.target" ];
    wants = lib.mkForce [ "containerd.service" ];
  };

  systemd.services."NetworkManager-wait-online".enable = false;
  
  services.tailscale.enable = true;
  users.users.duffy.extraGroups = [ "docker" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
}
