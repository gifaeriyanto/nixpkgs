{ config, lib, pkgs, ... }:

let
  runCommands = content:
    lib.hm.dag.entryAfter [ "writeBoundary" ] (
      lib.optionalString (pkgs.stdenv.isDarwin) (content)
    );
in
{
  home.activation = {
    linkApplications =
      runCommands
        (
          let
            apps = pkgs.buildEnv {
              name = "home-manager-applications";
              paths = config.home.packages;
              pathsToLink = "/Applications";
            };
          in
          ''
            baseDir="/Applications/Home Manager Apps"
            if [ -d "$baseDir" ]; then
              rm -rf "$baseDir"
            fi
            mkdir -p "$baseDir"
            for appFile in ${apps}/Applications/*; do
              target="$baseDir/$(basename "$appFile")"
              $DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} -fHRL "$appFile" "$baseDir"
              $DRY_RUN_CMD chmod ''${VERBOSE_ARG:+-v} -R +w "$target"
            done
          ''
        );
  };
}