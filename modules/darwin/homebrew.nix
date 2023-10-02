{ config, lib, ... }:

let
  inherit (lib) mkIf;
  mkIfCaskPresent = cask: mkIf (lib.any (x: x == cask) config.homebrew.casks);
  brewEnabled = config.homebrew.enable;
in

{
  environment.shellInit = mkIf brewEnabled ''
    eval "$(${config.homebrew.brewPrefix}/brew shellenv)"
  '';

  # https://docs.brew.sh/Shell-Completion#configuring-completions-in-fish
  # For some reason if the Fish completions are added at the end of `fish_complete_path` they don't
  # seem to work, but they do work if added at the start.
  programs.fish.interactiveShellInit = mkIf brewEnabled ''
    if test -d (brew --prefix)"/share/fish/completions"
      set -p fish_complete_path (brew --prefix)/share/fish/completions
    end
    if test -d (brew --prefix)"/share/fish/vendor_completions.d"
      set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
    end
  '';

  homebrew.enable = true;

  homebrew.global = {
    brewfile = true;
    lockfiles = true;
  };

  homebrew.onActivation = {
    autoUpdate = true;
    cleanup = "zap";
    upgrade = true;
  };

  # Prefer installing application from the Mac App Store
  homebrew.masApps = {
    DropOver = 1355679052;
    HiddenBar = 1452453066;
    Keynote = 409183694;
    Numbers = 409203825;
    Pages = 409201541;
    Slack = 803453959;
    Telegram = 747648890;
    Whatsapp = 1147396723;
    # Xcode = 497799835;
  };

  homebrew.brews = [
    "n"
    "pinentry-mac"
    "yarn"
  ];

  # If an app isn't available in the Mac App Store, or the version in the App Store has
  # limitiations, e.g., Transmit, install the Homebrew Cask.
  homebrew.casks = [
    "discord"
    "firefox"
    "google-chrome"
    "iterm2"
    "notion"
    "raycast"
    "rectangle"
    "shottr"
    "spotify"
    "steam"
    "vlc"
    "zoom"
  ];
}
