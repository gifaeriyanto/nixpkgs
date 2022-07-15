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

    installNode =
      runCommands (
        ''
          # make cache folder (if missing) and take ownership
          sudo mkdir -p /usr/local/n
          sudo chown -R $(whoami) /usr/local/n

          # make sure the required folders exist (safe to execute even if they already exist)
          sudo mkdir -p /usr/local/bin /usr/local/lib /usr/local/include /usr/local/share

          # take ownership of Node.js install destination folders
          sudo chown -R $(whoami) /usr/local/bin /usr/local/lib /usr/local/include /usr/local/share

          # install nodes
          n lts
          n install 16
          n install 14
        ''
      );
  };
}