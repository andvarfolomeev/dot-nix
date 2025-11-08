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

  modules = {
    hardware = {
      graphics = true;
      amdgpu = true;
      bluetooth = true;
      xboxController = true;
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
    desktop = {
      vpn = {
        enable = true;
        amnezia = true;
        forti = true;
      };
      x = true;
      style = false;
      gnome = false;
      plasma = true;
      hypr = false;
      access = {
        ssh = true;
        samba = false;
      };
    };
    gaming = {
      enable = true;
      steam = true;
      gamescope = true;
      gamemode = true;
      mangoHud = true;
      coreCtrl = true;
      performanceGovernor = true;
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
