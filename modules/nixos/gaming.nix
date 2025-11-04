{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.gaming;
in
{
  options.gaming = {
    enable = lib.mkEnableOption "Enable all-in-one gaming tweaks for AMD on NixOS";

    useZenKernel = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use linux-zen kernel for better desktop/gaming scheduling.";
    };

    enableSteam = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Steam + Proton GE.";
    };
    enableLutris = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Lutris.";
    };
    enableGamescope = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install gamescope compositor.";
    };
    enableGamemode = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Feral gamemode.";
    };
    enableMangoHud = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install MangoHud overlay.";
    };
    enableVkBasalt = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install vkBasalt post-processing.";
    };
    enableCoreCtrl = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install CoreCtrl and allow tweaks via polkit.";
    };

    setKernelParams = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Apply recommended kernel params for desktop/gaming.";
    };

    setSysctl = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Apply sysctl tuning for smoother frametimes.";
    };

    performanceGovernor = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Force CPU governor=performance during session.";
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.xone.enable = true;

    ######## Kernel & params
    boot = {
      kernelPackages = lib.mkIf cfg.useZenKernel pkgs.linuxPackages_zen;

      kernelParams = lib.mkIf cfg.setKernelParams [
        "amd_pstate=active"
        "nvme_core.default_ps_max_latency_us=0"
        "mem_sleep=s2idle"
        # Иногда помогает стабильности кадров на некоторых платах/GPU:
        "pcie_aspm=off"
      ];

      kernel.sysctl = lib.mkIf cfg.setSysctl {
        "vm.swappiness" = 10;
        "vm.dirty_ratio" = 10;
        "vm.dirty_background_ratio" = 5;
        "kernel.sched_migration_cost_ns" = 5000000;
        "fs.inotify.max_user_watches" = 1048576;
      };
    };

    ######## AMD graphics stack (RADV / Mesa / Vulkan)
    hardware.graphics = {
      enable = true;
      enable32Bit = true; # для Steam/Proton
      extraPackages = with pkgs; [
        mesa
        mesa
        # mesa.vulkan-drivers
        libva
        libvdpau
        vulkan-tools
      ];
    };

    ######## Userspace gaming tools
    programs = {
      steam = lib.mkIf cfg.enableSteam {
        enable = true;
        gamescopeSession.enable = cfg.enableGamescope; # удобная интеграция
        extraCompatPackages = with pkgs; [ proton-ge-bin ];
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true;
      };

      gamemode.enable = cfg.enableGamemode;
      gamescope.enable = cfg.enableGamescope;
    };

    environment.systemPackages = with pkgs; [
      (lib.mkIf cfg.enableLutris lutris)
      (lib.mkIf cfg.enableMangoHud mangohud)
      (lib.mkIf cfg.enableVkBasalt vkbasalt)
      # диагностика
      vulkan-tools
      radeontop
      glxinfo
      pciutils
      (lib.mkIf cfg.enableVkBasalt corectrl)
    ];

    ######## Optional: expose amdgpu ppfeaturemask for CoreCtrl
    boot.extraModprobeConfig = lib.mkIf cfg.enableCoreCtrl ''
      options amdgpu ppfeaturemask=0xffffffff
    '';

    ######## CoreCtrl + polkit rules for tweaking without sudo
    services.udev.packages = lib.mkIf cfg.enableCoreCtrl [ pkgs.corectrl ];

    security.polkit.enable = true;
    security.polkit.extraConfig = lib.mkIf cfg.enableCoreCtrl ''
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

    ######## Performance governor (system-wide, simple)
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

    ######## Nice env knobs for Wayland/DXVK (safe defaults)
    environment.sessionVariables = {
      DXVK_ASYNC = "1";
      __GL_GSYNC_ALLOWED = "1";
      __GL_VRR_ALLOWED = "1";
      WLR_NO_HARDWARE_CURSORS = "1"; # если артефакты курсора — поможет; если ок, можно убрать
      # vkBasalt включается только если нужна пост-обработка:
      # ENABLE_VKBASALT=1 games ...
    };
  };
}
