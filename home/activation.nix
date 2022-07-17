{ config, lib, pkgs, ... }:

pkgs.mkShell {
  name = "micro setting";
  shellHook = ''
    microDir=~/.config/micro
    settingFile=$microDir/settings.json

    # check if `settings.json` doesn't exist, create the file
    if ! [ -f "$settingFile" ]; then
      mkdir -p $microDir
      echo "{}" > $settingFile
    fi
    
    # add default setting
    jq '.colorscheme = "solarized"' $settingFile > "tmp" && mv "tmp" $settingFile
  '';
}

# let
#   runCommands = content:
#     lib.hm.dag.entryAfter [ "writeBoundary" ] (
#       lib.optionalString (pkgs.stdenv.isDarwin) (content)
#     );
# in
# {
#   home.activation = {
#     linkApplications =
#       runCommands
#         (
#           let
#             apps = pkgs.buildEnv {
#               name = "home-manager-applications";
#               paths = config.home.packages;
#               pathsToLink = "/Applications";
#             };
#           in
#           # TODO: update baseDir path to ~/Applications,
#           # currently apps that installed under home manager not shown in launchpad and spotlight search
#           ''
#             baseDir="/Applications/Home Manager Apps"
#             if [ -d "$baseDir" ]; then
#               rm -rf "$baseDir"
#             fi
#             mkdir -p "$baseDir"
#             for appFile in ${apps}/Applications/*; do
#               target="$baseDir/$(basename "$appFile")"
#               $DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} -fHRL "$appFile" "$baseDir"
#               $DRY_RUN_CMD chmod ''${VERBOSE_ARG:+-v} -R +w "$target"
#             done
#           ''
#         );

#     installNode =
#       runCommands (
#         ''
#           # make cache folder (if missing) and take ownership
#           sudo mkdir -p /usr/local/n
#           sudo chown -R $(whoami) /usr/local/n

#           # make sure the required folders exist (safe to execute even if they already exist)
#           sudo mkdir -p /usr/local/bin /usr/local/lib /usr/local/include /usr/local/share

#           # take ownership of Node.js install destination folders
#           sudo chown -R $(whoami) /usr/local/bin /usr/local/lib /usr/local/include /usr/local/share
#         ''
#       );

#   };
# }