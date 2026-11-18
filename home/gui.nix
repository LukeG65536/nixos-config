{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    inputs.dankMaterialShell.homeModules.dank-material-shell
    inputs.zen-browser.homeModules.beta
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  home.username = "duffy";
  home.homeDirectory = "/home/duffy";
  home.stateVersion = "25.05";

  home.file.".config/DankMaterialShell".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos-config/dotfiles/DankMaterialShell";

  home.file.".config/niri".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos-config/dotfiles/niri";  

  home.file.".config/kitty".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos-config/dotfiles/kitty";

  # Remove the legacy profile link before Home Manager checks the new link
  # forest. It was created by the DMS module in an older generation.
  home.activation.removeLegacyDmsWantedLink = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    legacy_link="$HOME/.config/systemd/user/graphical-session.target.wants/dms.service"
    if [ -L "$legacy_link" ] && [ "$(readlink "$legacy_link")" = "/etc/profiles/per-user/duffy/share/systemd/user/dms.service" ]; then
      rm "$legacy_link"
    fi
  '';
  
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
    # (darktable.overrideAttrs (oldAttrs: {
    #   cmakeFlags = (oldAttrs.cmakeFlags or []) ++ [ "-DUSE_AI=OFF" ];
    # }))
    darktable
    vesktop
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
    vscode
    slack
    gparted
    kdePackages.partitionmanager
    kdePackages.filelight
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
    gtk3.extraConfig = {
      "gtk-decoration-layout" = ":none";
    };
    gtk4.extraConfig = {
      "gtk-decoration-layout" = ":none";
    };
  };


  fonts.fontconfig.enable = true;


  programs.dank-material-shell = {
    enable = true;
    systemd = {
      enable = true;
      restartIfChanged = true;
      target = "niri.service";
    };
  };

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
  };

  programs.feh = {
    enable = true;
  
    buttons = {
      prev_img = null;
      next_img = null;
    
      zoom_in = 4;
      zoom_out = 5;
    };
  
    themes = {
      feh = [
        "--auto-zoom"
        "--scale-down"
        "-F"
      ];
    };
  };
}
