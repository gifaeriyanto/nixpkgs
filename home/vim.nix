nixpkgs.overlays = [
   (self: super: {
     neovim = super.neovim.override {
       viAlias = true;
       vimAlias = true;
     };
  })
];

programs.neovim.enable = true;
programs.neovim.viAlias = true;