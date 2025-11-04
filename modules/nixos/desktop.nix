{
  pkgs,
  lib,
  config,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    optionals
    ;

  cfg = config.modules.desktop;
in
{

  options.modules.desktop = {
    vpn = {
      enable = mkEnableOption "Enable VPN clients";
      amnezia = mkEnableOption "Enable Amnezia client";
      forti = mkEnableOption "Enable forti client";
    };
    x = mkEnableOption "Enable X graphic";
    style = mkEnableOption "Enable Stylix";
    gnome = mkEnableOption "Gnome DE";
    plasma = mkEnableOption "Plasma DE";
    access = {
      ssh = mkEnableOption "Open ssh";
      samba = mkEnableOption "Open SAMBA";
    };
    llm = mkEnableOption "Enable LLM Studion";
  };

  config = mkMerge [
    # general
    {
      i18n.defaultLocale = "en_US.UTF-8";
      i18n.extraLocaleSettings = {
        LC_ADDRESS = "ru_RU.UTF-8";
        LC_IDENTIFICATION = "ru_RU.UTF-8";
        LC_MEASUREMENT = "ru_RU.UTF-8";
        LC_MONETARY = "ru_RU.UTF-8";
        LC_NAME = "ru_RU.UTF-8";
        LC_NUMERIC = "ru_RU.UTF-8";
        LC_PAPER = "ru_RU.UTF-8";
        LC_TELEPHONE = "ru_RU.UTF-8";
        LC_TIME = "ru_RU.UTF-8";
      };

      environment.systemPackages =
        (with pkgs; [
          chromium
          keepassxc
          dbeaver-bin
          postman
          obsidian
          kitty

        ])
        ++ (with pkgs.unstable; [
          zed-editor
          code-cursor
        ])
        ++ optionals cfg.llm [ pkgs.lmstudio ];
    }

    (mkIf cfg.style {
      environment.systemPackages = with pkgs; [ jetbrains-mono ];

      stylix = {
        enable = true;
        autoEnable = true;
        polarity = "dark";
        base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
        image = ../../wallpapers/01.jpg;
        cursor = {
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Ice";
          size = 24;
        };
        icons = {
          enable = true;
          light = "Papirus-Light";
          dark = "Papirus-Dark";
          package = pkgs.papirus-icon-theme;
        };
        fonts = {
          serif = {
            package = pkgs.dejavu_fonts;
            name = "DejaVu Serif";
          };
          sansSerif = {
            package = pkgs.dejavu_fonts;
            name = "DejaVu Sans";
          };
          monospace = {
            package = pkgs.jetbrains-mono;
            name = "JetBrains Mono";
          };
          emoji = {
            package = pkgs.noto-fonts-emoji;
            name = "Noto Color Emoji";
          };
        };
      };
    })

    (mkIf (cfg.vpn.enable || cfg.vpn.forti) {
      environment.systemPackages = with pkgs; [
        openfortivpn
        openfortivpn-webview
        openfortivpn-webview-qt
      ];
    })

    (mkIf (cfg.vpn.enable || cfg.vpn.amezia) {
      programs.amnezia-vpn.enable = true;
    })

    (mkIf cfg.x {
      services.xserver.enable = true;
    })

    (mkIf cfg.gnome {
      services.xserver.enable = true;
      services.xserver.desktopManager.gnome.enable = true;
      services.xserver.displayManager.gdm.enable = true;
      environment.systemPackages = [ pkgs.gnomeExtensions.appindicator ];
      services.udev.packages = [ pkgs.gnome-settings-daemon ];
    })

    (mkIf cfg.plasma {
      services.displayManager.sddm.enable = true;
      services.desktopManager.plasma6.enable = true;
    })

    (mkIf cfg.access.ssh {
      services = {
        openssh = {
          enable = true;
          settings.PasswordAuthentication = true;
        };
        xrdp = {
          enable = true;
        };
      };
    })

    (mkIf cfg.access.samba {
      services = {
        samba = {
          enable = true;
          openFirewall = true;
          settings = {
            global = {
              "browseable" = "yes";
              "smb encrypt" = "required";
            };
            homes = {
              browseable = "no";
              "read only" = "no";
              "guest ok" = "no";
            };
          };
        };
      };
    })
  ];
}
