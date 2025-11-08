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
    hypr = mkEnableOption "Hyprland";
    access = {
      ssh = mkEnableOption "Open ssh";
      samba = mkEnableOption "Open SAMBA";
    };
    llm = mkEnableOption "Enable LLM Studion";
  };

  config = mkMerge [
    {
      environment.systemPackages =
        (with pkgs; [
          librewolf
          chromium
          keepassxc
          dbeaver-bin
          postman
          obsidian
          kitty
          wireguard-ui

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
      services.xserver = {
        enable = true;
        xkb = {
          layout = "us,ru";
          options = "grp:win_space_toggle";
        };
        excludePackages = [ pkgs.xterm ];
      };
    })

    (mkIf cfg.gnome {
      services.xserver.desktopManager.gnome.enable = true;
      services.xserver.displayManager.gdm.enable = true;
      environment.systemPackages = [ pkgs.gnomeExtensions.appindicator ];
      services.udev.packages = [ pkgs.gnome-settings-daemon ];
    })

    (mkIf cfg.plasma {
      services.displayManager.sddm.enable = true;
      services.desktopManager.plasma6 = {
        enable = true;
        enableQt5Integration = true;
      };
      programs.xwayland.enable = true;

      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        pulse.enable = true;
      };

      xdg.portal = {
        enable = true;
        config = {
          common.default = [ "kde" ];
          kde.default = [ "kde" ];
        };
        extraPortals = with pkgs; [
          kdePackages.kwallet
          kdePackages.xdg-desktop-portal-kde
          pkgs.xdg-desktop-portal-gtk
        ];
      };

      environment.systemPackages = with pkgs; [
        kdePackages.xdg-desktop-portal-kde
        kdePackages.kpipewire
      ];

      environment.variables.NIXOS_OZONE_WL = "1";

      systemd.user.services.xdg-desktop-portal.environment = {
        XDG_CURRENT_DESKTOP = "KDE";
        XDG_SESSION_TYPE = "wayland";
        KDE_FULL_SESSION = "true";
      };
    })

    (mkIf cfg.hypr {
      services.displayManager.sddm.enable = true;

      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
      };

      environment.systemPackages =
        (with pkgs; [
          ironbar
          rofi
        ])
        ++ (with pkgs.libsForQt5; [
          dolphin
          networkmanager-qt
          bluez-qt
          xwaylandvideobridge
        ]);

      services = {
        udisks2 = {
          enable = true;
          mountOnMedia = true;
        };
        pipewire = {
          enable = true;
          alsa = {
            enable = true;
            support32Bit = true;
          };
          pulse.enable = true;
          wireplumber.enable = true;
        };
        tumbler.enable = true;
      };
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
