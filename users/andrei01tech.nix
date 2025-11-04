{
  ...
}:

{
  home.username = "andrei01tech";
  home.homeDirectory = "/home/andrei01tech";
  home.stateVersion = "25.05";
  imports = builtins.attrValues (import ../modules/home-manager);
}
