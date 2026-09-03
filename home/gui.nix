{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.dankMaterialShell.homeModules.dank-material-shell
    inputs.zen-browser.homeModules.beta
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  home.username = "duffy";
  home.homeDirectory = "/home/duffy";
  home.stateVersion = "25.05";

  
  programs.home-manager.enable = true;
  
  home.packages = with pkgs; [
    xwayland-satellite
    kitty
    alacritty
    firefox
    kdePackages.kate
    github-desktop
    nautilus
    obsidian
    spotify
    vesktop
    darktable
    feh
    mpv
    wl-clipboard
    libinput    
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.iosevka
    gimp
    prusa-slicer
  ];

  
  services.flatpak = {
    enable = true;

    remotes = [{
      name = "flathub";
      location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    }];

    packages = [
      "com.github.tchx84.Flatseal"
      "org.gnome.gitlab.YaLTeR.Identity"
      "org.vinegarhq.Sober"
    ];

  };

  
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 16;
  };

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.tela-icon-theme;
      name = "Tela-dark";
    };
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 16;
    };
  };


  fonts.fontconfig.enable = true;


  programs.dank-material-shell = {
    enable = true;
  };

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
  };
}
