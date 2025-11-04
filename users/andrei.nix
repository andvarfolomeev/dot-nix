{
  ...
}:

{
  home.username = "andrei";
  home.homeDirectory = "/home/andrei";
  home.stateVersion = "25.05";
  imports = builtins.attrValues (import ../modules/home-manager);
}
