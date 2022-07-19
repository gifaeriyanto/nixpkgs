{
  # Trackpad
  system.defaults.trackpad = {
    Clicking = true;
  };

  # Finder
  system.defaults.finder = {
    FXEnableExtensionChangeWarning = true;
    ShowStatusBar = true;
    ShowPathbar = true;
    FXPreferredViewStyle = "icnv";
    AppleShowAllExtensions = true;
  };

  # Launchd
  launchd.launchd.SoftResourceLimits = {
    # See: https://gist.github.com/tombigel/d503800a282fcadbee14b537735d202c
    NumberOfFiles = 200000;
    NumberOfProcesses = 2048;
  };
}
