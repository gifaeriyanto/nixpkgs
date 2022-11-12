{ ... }:

{
  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };  
      
  imports = [
    ./activation.nix
    ./git.nix
    ./packages.nix
    ./shells.nix
    # ./vim.nix
  ];
}  
