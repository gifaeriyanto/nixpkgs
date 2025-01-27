{ pkgs, config, ... }:

{
  home = {
    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "22.05";

    # Environment variables to always set at login.
    # https://nix-community.github.io/home-manager/options.html#opt-home.sessionVariables
    sessionVariables = {
      # Silence Fish greeting
      # https://fishshell.com/docs/current/cmds/fish_greeting.html
      fish_greeting = "";
    };

    packages = with pkgs; [
      ################################## 
      # Common
      ################################## 
      curl
      wget
      tree
      gnupg

      ################################## 
      # Nix-related Packages
      ################################## 
      cachix # to store cache binaries on cachix.org
      nix-prefetch-git # to get git signatures for fetchFromGit

      ##################################
      # Shell Integration
      ##################################
      bat
      bottom
      home-manager
      jq
      neofetch

      ##################################
      # Development Tools
      ##################################
      asciinema
      gh
      ghq
      micro
      nixpkgs-fmt
    ];
  };
}
