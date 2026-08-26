{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "nixos";

  networking.networkmanager.enable = true;

  time.timeZone = "America/Denver";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  users.users."duffy" = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "Luke Gottschall";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  nixpkgs.config.allowUnfree = true;


  services.locate.enable = true;
  services.locate.package = pkgs.mlocate; # or pkgs.plocate

  
  environment.localBinInPath = true;
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    openssl
    libffi
    glibc
    curl        
    icu         
    ncurses     
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  services.syncthing = {
    enable = false;
    openDefaultPorts = true; # Open ports in the firewall for Syncthing. (NOTE: this will not open syncthing gui port)
    user = "duffy"; 
    group = "users";
    dataDir = "/home/duffy"; 
    configDir = "/home/duffy/.config/syncthing";
  };

  programs.steam = {
    enable = false;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };


  security.rtkit.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  security.polkit.enable = true;



  programs.niri.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${config.programs.niri.package}/bin/niri-session";
       	user = "duffy";
      };
    };
  };
  systemd.user.services.niri.enableDefaultPath = false;


  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting
    '';
  };


  system.stateVersion = "26.05";
}
