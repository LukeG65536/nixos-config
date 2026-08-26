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
  
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "catppuccin_mocha";
      editor.line-number = "relative";
    };
    extraPackages = with pkgs; [
      bash-language-server   # Provides autocomplete, diagnostics, and hover details
      shellcheck             # Optional: Provides excellent bash linting/error checking
    ];
  };


  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza --icons --group-directories-first -lh";
      la = "eza --icons --group-directories-first -lha";
      lt = "eza -lT -L 3 --icons --group --group-directories-first";
      feh = "feh --auto-zoom --scale-down";
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

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = [
      "--cmd cd" # Replaces the standard 'cd' command with zoxide
    ];
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
