{ pkgs, config, lib, ... }:
{
  # Nix configuration -------------------------------------------------------

  users.nix.configureBuildUsers = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  nix = {
    binaryCaches = [
      "https://cache.nixos.org/"
      "https://gifaeriyanto.cachix.org/"
    ];

    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "gifaeriyanto.cachix.org-1:j7EC4jvKpt9K25C0tS2kSX8XFdYBEmVLk/7APU4+7aE="
    ];

    trustedUsers = [
      "@admin"
    ];

    # Enable experimental nix command and flakes
    # package = pkgs.nixUnstable;
    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
    ''
    + lib.optionalString (pkgs.system == "aarch64-darwin") ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
  };

  programs = {
    # https://github.com/bennofs/nix-index
    nix-index.enable = true;

    # Install and setup ZSH to work with nix(-darwin) as well.
    # It will create /etc/bashrc that loads the nix-darwin environment.
    zsh.enable = true;

    # Always enable the shell system-wide, even if it's already enabled in your home.nix. Otherwise it wont source the necessary files.
    # https://nixos.wiki/wiki/Command_Shell#Changing_default_shell
    fish = {
      enable = true;
      # Undefined in home-manager
      useBabelfish = true;
      babelfishPackage = pkgs.babelfish;
      # Needed to address bug where $PATH is not properly set for fish:
      # https://github.com/LnL7/nix-darwin/issues/122
      shellInit = ''
        for p in (string split : ${config.environment.systemPath})
          if not contains $p $fish_user_paths
            set -g fish_user_paths $fish_user_paths $p
          end
        end
      '';
    };
  };


  # Auto upgrade nix package and the daemon service.
  # Without this configuration, the switch command won't work due to this error:
  # error: The daemon is not enabled but this is a multi-user install, aborting activation
  services.nix-daemon.enable = true;

  environment = {
    # Add shells installed by nix to /etc/shells file
    shells = with pkgs; [
      bashInteractive
      fish
      zsh
    ];

    variables = {
      SHELL = "${pkgs.fish}/bin/fish";
    };
  };

  # Fonts
  fonts = {
    # fonts.enable = true;
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];
  };
}
