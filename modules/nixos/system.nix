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
    mkDefault
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
    {
      time.timeZone = cfg.timeZone;
      time.hardwareClockInLocalTime = true;

      i18n.defaultLocale = "en_US.UTF-8";
      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };

      boot = {
        loader = {
          timeout = 10;
          efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot";
          };
        };
        supportedFilesystems = [ "ntfs" ];
        kernelPackages = mkDefault pkgs.linuxPackages_latest;
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
      virtualisation.docker.enable = true;
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
