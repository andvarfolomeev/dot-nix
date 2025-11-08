{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    ;
  cfg = config.modules.gaming;
in
{
  options.modules.gaming = {
    enable = mkEnableOption "Enable module";
    zenKernel = mkEnableOption "Use linux-zen kernel for better desktop/gaming scheduling.";
    steam = mkEnableOption "Enable Steam + Proton GE.";
    lutris = mkEnableOption "Enable Lutris.";
    gamescope = mkEnableOption "Install gamescope compositor.";
    gamemode = mkEnableOption "Enable Feral gamemode.";
    mangoHud = mkEnableOption "Install MangoHud overlay.";
    vkBasalt = mkEnableOption "Install vkBasalt post-processing.";
    coreCtrl = mkEnableOption "Install CoreCtrl and allow tweaks via polkit.";
    kernelParams = mkEnableOption "Apply recommended kernel params for desktop/gaming.";
    sysctl = mkEnableOption "Apply sysctl tuning for smoother frametimes.";
    performanceGovernor = mkEnableOption "Force CPU governor=performance during session.";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      boot = {
        kernelPackages = mkIf cfg.zenKernel pkgs.linuxPackages_zen;
        kernelParams = mkIf cfg.kernelParams [
          "amd_pstate=active"
          "nvme_core.default_ps_max_latency_us=0"
          "mem_sleep=s2idle"
        ];
        kernel.sysctl = mkIf cfg.sysctl {
          "vm.swappiness" = 10;
          "vm.dirty_ratio" = 10;
          "vm.dirty_background_ratio" = 5;
          "kernel.sched_migration_cost_ns" = 5000000;
          "fs.inotify.max_user_watches" = 1048576;
        };
      };

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          mesa
          mesa
          libva
          libvdpau
          vulkan-tools
        ];
      };

      programs = {
        steam = lib.mkIf cfg.steam {
          enable = true;
          gamescopeSession.enable = cfg.gamescope;
          extraCompatPackages = with pkgs; [ proton-ge-bin ];
          dedicatedServer.openFirewall = true;
          remotePlay.openFirewall = true;
          localNetworkGameTransfers.openFirewall = true;
        };

        gamemode.enable = cfg.gamemode;
        gamescope.enable = cfg.gamescope;
      };

      environment.systemPackages = with pkgs; [
        (lib.mkIf cfg.lutris lutris)
        (lib.mkIf cfg.mangoHud mangohud)
        (lib.mkIf cfg.vkBasalt vkbasalt)
        vulkan-tools
        radeontop
        glxinfo
        pciutils
      ];

      environment.sessionVariables = {
        DXVK_ASYNC = "1";
        __GL_GSYNC_ALLOWED = "1";
        __GL_VRR_ALLOWED = "1";
        WLR_NO_HARDWARE_CURSORS = "1";
      };
    }

    (mkIf cfg.performanceGovernor {
      powerManagement.enable = true;
      systemd.services."performance-governor" = lib.mkIf cfg.performanceGovernor {
        description = "Set CPU governor to performance for gaming";
        wantedBy = [ "multi-user.target" ];
        after = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.linuxKernel.packages.linux_zen.cpupower}/bin/cpupower frequency-set -g performance";
        };
      };
    })

    (mkIf cfg.coreCtrl {
      environment.systemPackages = with pkgs; [ corectrl ];

      boot.extraModprobeConfig = lib.mkIf cfg.coreCtrl ''
        options amdgpu ppfeaturemask=0xffffffff
      '';

      services.udev.packages = lib.mkIf cfg.coreCtrl [ pkgs.corectrl ];
      security.polkit.enable = true;
      security.polkit.extraConfig = lib.mkIf cfg.coreCtrl ''
        polkit.addRule(function(action, subject) {
          const ok = subject.isInGroup("wheel");
          const ids = [
            "org.corectrl.helper.init",
            "org.corectrl.helperkiller.init",
            "org.corectrl.helper.set.pstate",
            "org.corectrl.helper.set.powerlimit",
            "org.corectrl.helper.set.fan"
          ];
          if (ok && ids.indexOf(action.id) >= 0) {
            return polkit.Result.YES;
          }
        });
      '';
    })
  ]);
}
