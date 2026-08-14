{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.dankMaterialShell.homeModules.dank-material-shell
    inputs.zen-browser.homeModules.beta
  ];

  home.username = "duffy";
  home.homeDirectory = "/home/duffy";

  home.stateVersion = "25.05";

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza --icons --group-directories-first -lh";
      la = "eza --icons --group-directories-first -lha";
      rebuild = "sudo nixos-rebuild switch --flake /home/duffy/nixos-config#pc";
      y = "yazi";
    };

    interactiveShellInit = ''
      set -g fish_greeting
    '';
  };

  programs.starship = {
    enable = true;
    # Configuration written to ~/.config/starship.toml
    settings = {
      add_newline = false;

      character = {
        success_symbol = "[>](bold green)";
        error_symbol = "[>](bold red)";
      };

      package.disabled = true;
    };
  };

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.tela-icon-theme;
      name = "Tela-dark";
    };
  };

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.iosevka
  ];

  fonts.fontconfig.enable = true;


  programs.dank-material-shell = {
    enable = true;
  };

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
  };
}
