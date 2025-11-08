{
  ...
}:

let
  super = "SUPER";
in
{
  wayland.windowManager.hyprland = {
    enable = false;
    xwayland.enable = true;
    settings = {
      input = {
        kb_layout = "us,ru";
        kb_options = "grp:win_space_toggle";
        repeat_rate = 50;
        repeat_delay = 300;
        follow_mouse = 1;
        sensitivity = 0;
      };

      general = {
        gaps_in = 0;
        gaps_out = 0;
        border_size = 1;
        layout = "master";
      };

      exec-once = [
        "ironbar"
      ];

      animations = {
        enabled = false;
      };

      bind = [
        # Basic
        "${super}, Q, killactive,"
        "${super}, M, exit,"

        # Run apps
        "${super}, Return, exec, kitty"
        "${super}, D, exec, rofi -show drun"
        "${super}, E, exec, dolphin"

        # Groups
        "${super}, G, togglegroup"
        "${super}, TAB, changegroupactive, f"
        "${super} SHIFT, TAB, changegroupactive, b"
        "${super}, left, moveintogroup, l"
        "${super}, right, moveintogroup, r"
        "${super}, up, moveintogroup, u"
        "${super}, down, moveintogroup, d"
        "${super} SHIFT, left, moveoutofgroup, l"
        "${super} SHIFT, right, moveoutofgroup, r"
        "${super} SHIFT, up, moveoutofgroup, u"
        "${super} SHIFT, down, moveoutofgroup, d"

        # Move focus
        "${super}, h, movefocus, l"
        "${super}, l, movefocus, r"
        "${super}, k, movefocus, u"
        "${super}, j, movefocus, d"
        "${super}, J, togglesplit, # dwindle"

        "${super}, F, fullscreen"

        # Move window
        "${super} SHIFT, h, swapwindow, l"
        "${super} SHIFT, l, swapwindow, r"
        "${super} SHIFT, k, swapwindow, u"
        "${super} SHIFT, j, swapwindow, d"

        # Resize window
        "${super} CTRL, h, resizeactive, -60 0"
        "${super} CTRL, l, resizeactive, 60 0"
        "${super} CTRL, k, resizeactive, 0 -60"
        "${super} CTRL, j, resizeactive, 0  60"

        # Focus on workspace
        "${super}, 1, workspace, 1"
        "${super}, 2, workspace, 2"
        "${super}, 3, workspace, 3"
        "${super}, 4, workspace, 4"
        "${super}, 5, workspace, 5"
        "${super}, 6, workspace, 6"
        "${super}, 7, workspace, 7"
        "${super}, 8, workspace, 8"
        "${super}, 9, workspace, 9"
        "${super}, 0, workspace, 10"

        "${super} SHIFT, 1, movetoworkspacesilent, 1"
        "${super} SHIFT, 2, movetoworkspacesilent, 2"
        "${super} SHIFT, 3, movetoworkspacesilent, 3"
        "${super} SHIFT, 4, movetoworkspacesilent, 4"
        "${super} SHIFT, 5, movetoworkspacesilent, 5"
        "${super} SHIFT, 6, movetoworkspacesilent, 6"
        "${super} SHIFT, 7, movetoworkspacesilent, 7"
        "${super} SHIFT, 8, movetoworkspacesilent, 8"
        "${super} SHIFT, 9, movetoworkspacesilent, 9"
        "${super} SHIFT, 0, movetoworkspacesilent, 10"

        # TODO: audio
        ", XF86AudioRaiseVolume, exec, pamixer -i 5 "
        ", XF86AudioLowerVolume, exec, pamixer -d 5 "
        ", XF86AudioMute, exec, pamixer -t"
        ", XF86AudioMicMute, exec, pamixer --default-source -m"

        # Brightness control
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%- "
        ", XF86MonBrightnessUp, exec, brightnessctl set +5% "
      ];

      bindm = [
        "${super}, mouse:272, movewindow"
        "${super}, mouse:273, resizewindow"
      ];
    };
  };
}
