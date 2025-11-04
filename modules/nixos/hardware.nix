{
  pkgs,
  lib,
  config,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf mkMerge;

  cfg = config.modules.hardware;
in
{

  options.modules.hardware = {
    graphics = mkEnableOption "Enable graphnic";
    amdgpu = mkEnableOption "Load AMD graphic drivers and services to adjust";
    bluetooth = mkEnableOption "Bluetooth";
  };

  config = mkMerge [
    {
      hardware.xone.enable = true;
    }

    (mkIf (cfg.graphics || cfg.amdgpu) {
      hardware.graphics.enable32Bit = true;
    })

    (mkIf cfg.amdgpu {
      boot.initrd.kernelModules = [ "amdgpu" ];
      services.xserver.videoDrivers = [ "amdgpu" ];

      environment.systemPackages = [ pkgs.lact ];
      systemd.packages = [ pkgs.lact ];
      systemd.services.lactd.wantedBy = [ "multi-user.target" ];
    })

    (mkIf cfg.bluetooth {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            Experimental = true;
          };
        };
      };
    })
  ];
}
