{
  ...
}:

{
  home.username = "andrei01tech";
  home.homeDirectory = "/home/andrei01tech";
  home.stateVersion = "25.05";
  programs.nixvim.imports = [
    ../modules/home-manager/nixvim/default.nix
    ../modules/home-manager/nixvim/autocmd.nix
    ../modules/home-manager/nixvim/globals.nix
    ../modules/home-manager/nixvim/keymaps.nix
    ../modules/home-manager/nixvim/opts.nix
  ];
  imports = builtins.attrValues (import ../modules/home-manager);
}
