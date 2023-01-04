{
  description = "Gifa's home";

  inputs = {
    # Package sets
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";

    # Environment/system management
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Other sources
  };

  outputs = { self, nixpkgs, darwin, home-manager, ... }@inputs:
    let
      inherit (darwin.lib) darwinSystem;
      inherit (inputs.nixpkgs.lib) attrValues optionalAttrs singleton;

      # Configuration for `nixpkgs`
      nixpkgsConfig = {
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (pkg: true);
        };
      };

      nixDarwinCommonModules = attrValues self.darwinModules ++ [
        # Main `nix-darwin` config
        ./modules/darwin

        # `home-manager` module
        home-manager.darwinModules.home-manager
        (
          { pkgs, ... }:
          {
            nixpkgs = nixpkgsConfig;

            # Configure default shell for gifaeriyanto to fish
            users.users.gifaeriyanto.shell = pkgs.fish;
            # Somehow this 👆 doesn't work.
            # So I did this instead: https://stackoverflow.com/a/26321141/3187014
            # 
            # ```shell
            # $ sudo sh -c "echo $(which fish) >> /etc/shells"
            # $ chsh -s $(which fish)
            # ```

            # `home-manager` config
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.gifaeriyanto = import ./home;
          }
        )
      ];
    in
    {
      darwinConfigurations = {
        gifaeriyanto = {
          intel = darwinSystem {
            system = "x86_64-darwin";
            modules = nixDarwinCommonModules;
          };

          m1 = darwinSystem {
            system = "aarch64-darwin";
            modules = nixDarwinCommonModules;
          };
        };
      };

      darwinModules = {
        gifa-system = import ./modules/darwin/system.nix;
        gifa-homebrew = import ./modules/darwin/homebrew.nix;

        programs-nix-index =
          # Additional configuration for `nix-index` to enable `command-not-found` functionality with Fish.
          { config, lib, pkgs, ... }:

          {
            config = lib.mkIf config.programs.nix-index.enable {
              # TODO: split below Fish configuration calls to always apply regardless of nix-index.enable settings above
              # https://fishshell.com/docs/3.5/interactive.html?highlight=fish_vi_key_bindings#vi-mode-commands
              # TODO: https://fishshell.com/docs/3.5/language.html#wildcards-globbing
              programs.fish.interactiveShellInit = ''  
                function __fish_command_not_found_handler --on-event="fish_command_not_found"
                  ${if config.programs.fish.useBabelfish then ''
                  command_not_found_handle $argv
                  '' else ''
                  ${pkgs.bashInteractive}/bin/bash -c \
                    "source ${config.programs.nix-index.package}/etc/profile.d/command-not-found.sh; command_not_found_handle $argv"
                  ''}
                end
              '';
            };
          };
      };
    };
}
