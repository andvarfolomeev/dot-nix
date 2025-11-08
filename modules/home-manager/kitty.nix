{
  programs.kitty = {
    enable = true;
    settings = {
      enable_audio_bell = false;
      close_on_child_death = true;
      cursor_blink_interval = 0;

      enabled_layouts = "fat, tall, vertical";
      wayland_titlebar_color = "background";

      allow_remote_control = true;
      listen_on = "unix:/tmp/kitty";
      dynamic_background_opacity = true;

      window_padding_width = 5;
      tab_bar_margin_width = 5;

      notify_on_cmd_finish = "unfocused";

      scrollback_pager = "less --chop-long-lines --raw-control-chars +INPUT_LINE_NUMBER";
    };
  };
}
