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
      # ll = "ls -la";
    };
  };
/*
  programs.kitty = {
    enable = true;
    settings = {
      # font_family = "JetBrains Mono";
      # font_size = "11.0";
      confirm_os_window_close = 0;
    };
    # or, if you'd rather keep your existing kitty.conf as-is:
    # extraConfig = builtins.readFile ./dotfiles/kitty.conf;
  };*/


  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  programs.dank-material-shell = {
    enable = true;
#     niri.enableSpawn = true;
    # check `nix flake show github:AvengeMedia/DankMaterialShell`
    # or the repo's README for the actual option names/defaults —
    # they're still evolving, worth confirming against current docs.
  };

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
  };
}
