{
  pkgs,
  lib,
  config,
  ...
}:

let
  inherit (lib.types) str;

  inherit (lib)
    mkOption
    mkEnableOption
    mkIf
    mkMerge
    ;

  cfg = config.modules.system;
in
{
  options.modules.system = {
    timeZone = mkOption {
      type = str;
      default = "Europe/London";
    };

    networking = {
      hostName = mkOption {
        type = str;
        default = "nixos";
      };
    };

    docker = mkEnableOption "Enable docker service";

    syncthing = {
      enable = mkEnableOption "Enable Syncthing";
      user = mkOption { type = str; };
      dataDir = mkOption { type = str; };
      configDir = mkOption { type = str; };
    };
  };

  config = mkMerge [
    # general
    {
      time.timeZone = cfg.timeZone;
      time.hardwareClockInLocalTime = true;

      boot = {
        loader = {
          timeout = 10;
          efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot";
          };
          # grub = {
          #   enable = true;
          #   default = "saved";
          #   extraConfig = ''
          #     GRUB_TIMEOUT_STYLE=menu
          #     GRUB_SAVEDEFAULT=true
          #   '';
          #   device = "nodev";
          #   efiSupport = true;
          #   efiInstallAsRemovable = true;
          #   useOSProber = true;
          #   configurationLimit = 10;
          # };
        };
        # kernelParams = [
        #   "mem_sleep=s2idle"
        # ];
        supportedFilesystems = [ "ntfs" ];
        # kernelPackages = pkgs.linuxPackages_latest;
      };

      environment.systemPackages = with pkgs; [
        os-prober
        sbctl
      ];

      boot.lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };

      nix = {
        optimise.automatic = true;
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 7d";
        };
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
        };
      };
      nixpkgs.config.allowUnfree = true;
      programs.nix-ld.enable = true;
    }

    {
      networking.hostName = cfg.networking.hostName;
      networking.networkmanager.enable = true;
    }

    (mkIf cfg.docker {
      virtualisation.docker = {
        enable = true;
      };
      environment.systemPackages = with pkgs; [
        docker-compose
        docker-buildx
        kubectl
      ];
    })

    (mkIf cfg.syncthing.enable {
      services = {
        syncthing = {
          enable = true;
          user = cfg.syncthing.user;
          dataDir = cfg.syncthing.dataDir;
          configDir = cfg.syncthing.configDir;
          overrideDevices = false;
          overrideFolders = false;
        };
      };

      networking.firewall.allowedTCPPorts = [
        8384
        22000
      ];
      networking.firewall.allowedUDPPorts = [
        22000
        21027
      ];
    })
  ];
}
