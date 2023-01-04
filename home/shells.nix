{ config, pkgs, lib, ... }:

{
  home = with pkgs;{
    packages = with fishPlugins;[
      thefuck
    ];
  };

  programs = {
    fish = {
      # Make Fish the default shell
      enable = true;

      functions = {
        git-branch-update = ''
          set branch $argv[1]
          set currentBranch $(git rev-parse --abbrev-ref HEAD)

          if test $branch
            git checkout $branch
            git pull origin $branch
            git checkout $currentBranch
          else
            echo "Branch name is not specified"
          end
        '';

        git-lazy-rebase = ''
          set branch $argv[1]

          if test $branch
            git-branch-update $branch
            git rebase $branch
          else
            echo "Branch name is not specified"
          end
        '';

        git-lazy-pull = ''
          set branch $argv[1]

          if test $branch
            git-branch-update $branch
            git pull origin $branch
          else
            echo "Branch name is not specified"
          end
        '';

        git-commit-from = ''
          git shortlog -s | grep $argv[1]
        '';

        git-delete-branch = ''
          set branch $argv[1]

          if test $branch
            # delete branch locally
            git branch -d $branch
            # delete branch remotely
            git push origin --delete $branch
          else
            echo "Branch name is not specified"
          end
        '';

        git-spenmo-preview = ''
          set currentBranch $(git rev-parse --abbrev-ref HEAD)
          set previewBranch preview/$currentBranch

          # delete existing branch (if any)
          if test $(git rev-parse --verify --quiet $previewBranch)
            git-delete-branch $previewBranch
          end

          # create preview
          git checkout -b $previewBranch
          git push origin $previewBranch

          # back to working branch
          git checkout $currentBranch
        '';
      };

      # Fish abbreviations
      shellAbbrs = { };

      # Fish alias : register alias command in fish
      shellAliases = {
        # Nix related
        drb = "darwin-rebuild build --flake ~/.config/nixpkgs/";
        drs = "darwin-rebuild switch --flake ~/.config/nixpkgs/";
        dr = "darwin-rebuild switch --flake";

        # is equivalent to: nix build --recreate-lock-file
        flakeup-all = "nix flake update ~/.config/nixpkgs/";
        # example: 
        # $ flakeup home-manager
        flakeup = "nix flake lock ~/.config/nixpkgs/ --update-input";
        nb = "nix build";
        nd = "nix develop";
        nf = "nix flake";
        nr = "nix run";
        ns = "nix search";

        # CD to dir
        cn = "cd ~/.config/nixpkgs";
      };

      shellInit = ''
        # See: https://gist.github.com/tombigel/d503800a282fcadbee14b537735d202c
        # Max open files limit
        ulimit -n 200000
        # Max processes limit
        ulimit -u 2048

        # Fish color
        set -U fish_color_command 6CB6EB --bold
        set -U fish_color_redirection DEB974
        set -U fish_color_operator DEB974
        set -U fish_color_end C071D8 --bold
        set -U fish_color_error EC7279 --bold
        set -U fish_color_param 6CB6EB
        set fish_greeting
      '';

      plugins = with pkgs.fishPlugins;[
        {
          name = "thefuck";
          src = pkgs.fetchFromGitHub {
            owner = "oh-my-fish";
            repo = "plugin-thefuck";
            rev = "6c9a926d045dc404a11854a645917b368f78fc4d";
            sha256 = "1n6ibqcgsq1p8lblj334ym2qpdxwiyaahyybvpz93c8c9g4f9ipl";
          };
        }
        {
          name = "z";
          src = pkgs.fetchFromGitHub {
            owner = "jethrokuan";
            repo = "z";
            rev = "85f863f20f24faf675827fb00f3a4e15c7838d76";
            sha256 = "1kaa0k9d535jnvy8vnyxd869jgs0ky6yg55ac1mxcxm8n0rh2mgq";
          };
        }
      ];
    };

    # Fish prompt and style
    starship = {
      enable = true;
      settings = {
        add_newline = true;
        command_timeout = 1000;
        cmd_duration = {
          format = " [$duration]($style) ";
          style = "bold #EC7279";
          show_notifications = true;
        };
        directory = {
          truncate_to_repo = false;
        };
        nix_shell = {
          format = " [$symbol$state]($style) ";
        };
        battery = {
          full_symbol = "🔋 ";
          charging_symbol = "⚡️ ";
          discharging_symbol = "💀 ";
        };
        git_branch = {
          format = "[$symbol$branch]($style) ";
          symbol = " ";
        };
        gcloud = {
          format = "[$symbol$active]($style) ";
          symbol = "  ";
        };
        aws = {
          symbol = "  ";
        };
        buf = {
          symbol = " ";
        };
        c = {
          symbol = " ";
        };
        conda = {
          symbol = " ";
        };
        dart = {
          symbol = " ";
        };
        directory = {
          read_only = " ";
        };
        docker_context = {
          symbol = " ";
        };
        elixir = {
          symbol = " ";
        };
        elm = {
          symbol = " ";
        };
        golang = {
          symbol = " ";
        };
        haskell = {
          symbol = " ";
        };
        hg_branch = {
          symbol = " ";
        };
        java = {
          symbol = " ";
        };
        julia = {
          symbol = " ";
        };
        memory_usage = {
          symbol = " ";
        };
        nim = {
          symbol = " ";
        };
        nix_shell = {
          symbol = " ";
        };
        nodejs = {
          symbol = " ";
        };
        package = {
          symbol = " ";
        };
        python = {
          symbol = " ";
        };
        spack = {
          symbol = "🅢 ";
        };
        rust = {
          symbol = " ";
        };
      };
    };
  };
}
