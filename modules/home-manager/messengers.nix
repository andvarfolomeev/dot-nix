{
  pkgs,
  ...
}:

{
  home.packages = with pkgs.unstable; [
    discord
    telegram-desktop
    slack
  ];
}
