{
  pkgs,
  ...
}:

let
  normalExtraGroups = [
    "users"
    "wheel"
    "networkmanager"
    "video"
    "audio"
    "input"
    "docker"
  ];
in
{
  imports = [
    ./hardware-configuration.nix

    ../../modules/nixos/desktop.nix
    ../../modules/nixos/gaming.nix
    ../../modules/nixos/hardware.nix
    ../../modules/nixos/shell.nix
    ../../modules/nixos/system.nix
  ];

  gaming.enable = true;

  modules = {
    hardware = {
      graphics = true;
      amdgpu = true;
      bluetooth = true;
    };
    system = {
      timeZone = "Europe/Moscow";
      docker = true;
      syncthing = {
        enable = true;
        user = "andrei";
        dataDir = "/home/andrei/Documents";
        configDir = "/home/andrei/.config/syncthing";
      };
    };
    desktop = {
      vpn = {
        enable = true;
        amnezia = true;
        forti = true;
      };
      x = true;
      style = true;
      gnome = false;
      plasma = true;
      access = {
        ssh = true;
        samba = true;
      };
    };
    shell = {
      netTools = true;
      hardwareTools = true;
      gpuTools = true;
      gnupg = true;
      languages = {
        go = true;
        node = true;
        nix = true;
      };
    };
  };

  users.users.andrei = {
    isNormalUser = true;
    extraGroups = normalExtraGroups ++ [ "plugdev" ];
    shell = pkgs.zsh;
  };

  users.users.andrei01tech = {
    isNormalUser = true;
    extraGroups = normalExtraGroups ++ [ "ppp" ];
    shell = pkgs.zsh;
  };

  system.stateVersion = "25.05";
}
