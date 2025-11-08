{
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
    xboxController = mkEnableOption "";
  };

  config = mkMerge [
    (mkIf cfg.xboxController {
      hardware.xone.enable = true;
    })

    (mkIf (cfg.graphics || cfg.amdgpu) {
      hardware.graphics.enable32Bit = true;
    })

    (mkIf cfg.amdgpu {
      boot.initrd.kernelModules = [ "amdgpu" ];
      services.xserver.videoDrivers = [ "amdgpu" ];
    })

    (mkIf cfg.bluetooth {
      services.blueman.enable = true;
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
