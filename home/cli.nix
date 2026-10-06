{ config, pkgs, inputs, ... }:

{



  # Let home-manager manage itself
  programs.home-manager.enable = true;


  # imports = [ inputs.yazelix.homeManagerModules.default ];

  # programs.yazelix.enable = true;

  
  home.packages = with pkgs; [
    git
    vim
    fastfetch
    gh
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
    gcc
    cmake
    duf
    file
    bindfs
    xhost
    delta
    nix-output-monitor
    xonsh
  ];


  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "${config.home.homeDirectory}/nixos-config";
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
      # cudaPackages.cudatoolkit
      # cudaPackages.cuda_cudart
      # cudaPackages.cuda_nvcc
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
      egrep = "egrep --color";
      rebuild = "re";
    };

    functions = {
      ure = {
        description = "Update flake inputs and rebuild NixOS configuration";
        body = ''
          re --update $argv
        '';
      };

      re = {
        description = "Preview git diff and rebuild NixOS configuration";
        body = ''
          set -l config_dir "$HOME/nixos-config"
          if not test -d "$config_dir"
            echo (set_color red)"Error: $config_dir does not exist!"(set_color normal)
            return 1
          end

          set -l changes (git -C "$config_dir" status --porcelain)
          if test -n "$changes"
            echo (set_color yellow --bold)":: Pending changes in $config_dir:"(set_color normal)
            git -C "$config_dir" status --short
            echo ""
            echo (set_color yellow --bold)":: Diff preview:"(set_color normal)
            if command -q delta
              git -C "$config_dir" diff HEAD | delta --paging=never
            else
              git -C "$config_dir" diff HEAD --color=always
            end
            echo ""
          end

          set -l nh_args $argv
          if not contains -- -H $nh_args; and not contains -- --hostname $nh_args
            if test (hostname) = "nixos"
              if test -d /sys/class/power_supply/BAT0 -o -d /sys/class/power_supply/BAT1
                set -a nh_args -H laptop
              else
                set -a nh_args -H pc
              end
            end
          end

          echo (set_color cyan --bold)":: Rebuilding NixOS with nh..."(set_color normal)
          nh os switch "$config_dir" $nh_args
          set -l switch_status $status

          if test $switch_status -eq 0
            set -l gen
            if test -e /nix/var/nix/profiles/system
              set gen (readlink /nix/var/nix/profiles/system | string match -r '[0-9]+')
            end
            if test -n "$gen"
              echo (set_color green --bold)":: Successfully switched to generation $gen!"(set_color normal)
            else
              echo (set_color green --bold)":: Successfully switched NixOS configuration!"(set_color normal)
            end
          else
            echo (set_color red --bold)":: NixOS switch failed with exit code $switch_status"(set_color normal)
            return $switch_status
          end
        '';
      };

      gre = {
        description = "Failproof rebuild, commit generation, and push to Git";
        body = ''
          set -l config_dir "$HOME/nixos-config"
          if not test -d "$config_dir"
            echo (set_color red)"Error: $config_dir does not exist!"(set_color normal)
            return 1
          end

          set -l nh_args
          set -l commit_msg ""
          set -l i 1
          while test $i -le (count $argv)
            set -l arg $argv[$i]
            switch $arg
              case -u --update --dry -d --diff --nom
                set -a nh_args $arg
              case -H --hostname
                set -a nh_args $arg
                set i (math $i + 1)
                if test $i -le (count $argv)
                  set -a nh_args $argv[$i]
                end
              case -m --message
                set i (math $i + 1)
                if test $i -le (count $argv)
                  set commit_msg $argv[$i]
                end
              case "-*"
                set -a nh_args $arg
              case "*"
                if test -z "$commit_msg"
                  set commit_msg $arg
                else
                  set commit_msg "$commit_msg $arg"
                end
            end
            set i (math $i + 1)
          end

          set -l changes (git -C "$config_dir" status --porcelain)
          set -l unpushed (git -C "$config_dir" log @{u}..HEAD --oneline 2>/dev/null)

          if test -n "$changes"
            echo (set_color yellow --bold)":: Pending changes in $config_dir:"(set_color normal)
            git -C "$config_dir" status --short
            echo ""
            echo (set_color yellow --bold)":: Diff preview:"(set_color normal)
            if command -q delta
              git -C "$config_dir" diff HEAD | delta --paging=never
            else
              git -C "$config_dir" diff HEAD --color=always
            end
            echo ""
          else if test -n "$unpushed"
            echo (set_color yellow --bold)":: Unpushed commits in $config_dir:"(set_color normal)
            git -C "$config_dir" log @{u}..HEAD --oneline
            echo ""
          else
            echo (set_color blue)":: Working tree is clean and up to date."(set_color normal)
          end

          if not contains -- -H $nh_args; and not contains -- --hostname $nh_args
            if test (hostname) = "nixos"
              if test -d /sys/class/power_supply/BAT0 -o -d /sys/class/power_supply/BAT1
                set -a nh_args -H laptop
              else
                set -a nh_args -H pc
              end
            end
          end

          echo (set_color cyan --bold)":: Building and switching NixOS..."(set_color normal)
          nh os switch "$config_dir" $nh_args
          set -l switch_status $status

          if test $switch_status -ne 0
            echo ""
            echo (set_color red --bold)":: Switch FAILED (exit code $switch_status)!"(set_color normal)
            echo (set_color red)":: No git changes were committed or pushed. Fix the errors above and try again."(set_color normal)
            return $switch_status
          end

          set -l gen
          if test -e /nix/var/nix/profiles/system
            set gen (readlink /nix/var/nix/profiles/system | string match -r '[0-9]+')
          end

          if test -n "$gen"
            echo (set_color green --bold)":: Switch succeeded! Activated generation: $gen"(set_color normal)
          else
            echo (set_color green --bold)":: Switch succeeded!"(set_color normal)
          end

          set -l has_changes (git -C "$config_dir" status --porcelain)
          if test -n "$has_changes"
            set -l final_msg ""
            if test -n "$commit_msg"
              if test -n "$gen"
                set final_msg "$commit_msg (gen $gen)"
              else
                set final_msg "$commit_msg"
              end
            else
              if test -n "$gen"
                set final_msg "auto commit gen $gen"
              else
                set final_msg "auto commit NixOS generation"
              end
            end

            echo (set_color cyan)":: Staging and committing changes: \"$final_msg\""(set_color normal)
            git -C "$config_dir" add -A
            and git -C "$config_dir" commit -m "$final_msg"
            and begin
              echo (set_color cyan)":: Pushing to remote..."(set_color normal)
              git -C "$config_dir" push
              and echo (set_color green --bold)":: Successfully pushed generation $gen to git!"(set_color normal)
            end
          else
            set -l still_unpushed (git -C "$config_dir" log @{u}..HEAD --oneline 2>/dev/null)
            if test -n "$still_unpushed"
              echo (set_color cyan)":: Pushing previously committed changes..."(set_color normal)
              git -C "$config_dir" push
              and echo (set_color green --bold)":: Pushed to git successfully!"(set_color normal)
            else
              echo (set_color blue)":: No changes to commit or push."(set_color normal)
            end
          end
        '';
      };
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

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    shellWrapperName = "y";
  };
}
