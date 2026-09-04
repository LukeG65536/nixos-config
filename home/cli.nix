{ config, pkgs, inputs, ... }:

{



  # Let home-manager manage itself
  programs.home-manager.enable = true;


  imports = [ inputs.yazelix.homeManagerModules.default ];

  programs.yazelix.enable = true;

  
  home.packages = with pkgs; [
    git
    vim
    fastfetch
    gh
    yazi
    eza
    btop
    pyright
    clang-tools   # provides clangd
    ruff
    uv
    tealdeer
    python3Packages.python-lsp-server
    imagemagick
    zip
    unzip
    tree
    nushell
    dgop
    nvd
  ];


  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/duffy/nixos-config";
  };

  
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        line-number = "relative";
        end-of-line-diagnostics = "hint";
        cursor-shape = {
          insert = "bar";
          select = "underline";
        };
        lsp = {
          display-messages = true;
        };
        inline-diagnostics = {
          cursor-line = "error";
          other-lines = "disable";
        };
        indent-guides = {
          render = true;
        };
      };
      keys.normal = {
        C-y = [
          '':sh rm -f /tmp/unique-file''
          '':insert-output yazi "%{buffer_name}" --chooser-file=/tmp/unique-file''
          '':sh printf "\x1b[?1049h\x1b[?2004h" > /dev/tty''
          '':open %sh{cat /tmp/unique-file}''
          '':redraw''
        ];
      };

    };
    
    extraPackages = with pkgs; [
      bash-language-server
      shellcheck
      clang-tools
      cudaPackages.cudatoolkit
      cudaPackages.cuda_cudart
      cudaPackages.cuda_nvcc
    ];
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza --icons --group-directories-first -lh";
      la = "eza --icons --group-directories-first -lha";
      lt = "eza -lT -L 3 --icons --group --group-directories-first";
      feh = "feh --auto-zoom --scale-down";
      "..." = "cd ../..";
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
}
