{
  lib,
  pkgs,
  ...
}:

{
  programs.zed-editor = {
    enable = true;
    package = pkgs.unstable.zed-editor;
    userKeymaps = [
      {
        bindings = {
          "ctrl-shift-j" = "workspace::ToggleBottomDock";
        };
      }
      {
        context = "Editor && VimControl && vim_mode == normal";
        bindings = {
          j = [
            "workspace::SendKeystrokes"
            "g j"
          ];
          k = [
            "workspace::SendKeystrokes"
            "g k"
          ];

          "] j" = "pane::GoForward";
          "[ j" = "pane::GoBack";
          "] b" = "pane::ActivateNextItem";
          "[ b" = "pane::ActivatePreviousItem";
          "] c" = "project_panel::SelectNextGitEntry";
          "[ c" = "project_panel::SelectPrevGitEntry";

          "space shift-b" = "git::Branch";

          tab = "tab_switcher::Toggle";

          "space q" = "pane::CloseActiveItem";
          "space x" = "pane::CloseActiveItem";

          "space f" = "file_finder::Toggle";
          "space b" = "tab_switcher::Toggle";
          "space s" = "project_symbols::Toggle";
          "space S" = "outline::Toggle";
          "space d" = "diagnostics::Deploy";
          "space /" = "pane::DeploySearch";
          "shift shift" = "pane::DeploySearch";

          "g /" = "pane::DeploySearch";
          "g s" = "outline::Toggle";
          "g d" = "editor::GoToDefinition";
          "g y" = "editor::GoToTypeDefinition";
          "g r" = "editor::FindAllReferences";
          "g i" = "editor::GoToImplementation";

          "space a" = "editor::ToggleCodeActions";
          "space r" = "editor::Rename";
          "shift-k" = "editor::Hover";

          "s c" = [
            "vim::PushChangeSurrounds"
            { }
          ];
          "s d" = "vim::PushDeleteSurrounds";

          s = "vim::PushSneak";
          "shift-s" = "vim::PushSneakBackward";
        };
      }
      {
        context = "Editor && VimControl && (vim_mode == normal || vim_mode == visual)";
        bindings = {
          "+" = "vim::SelectLargerSyntaxNode";
          "-" = "vim::SelectSmallerSyntaxNode";
        };
      }
      {
        context = "vim_mode == visual";
        bindings = {
          "s a" = [
            "vim::PushAddSurrounds"
            { }
          ];
        };
      }
    ];
    userSettings = {
      show_edit_predictions = false;
      # vim
      vim_mode = true;
      vim = {
        use_system_clipboard = "on_yank";
      };
      relative_line_numbers = true;
      # ui
      theme = lib.mkForce "Gruvbox Dark Hard";
      icon_theme = "Material Icon Theme";
      ui_font_size = lib.mkForce 15;
      ui_font_family = lib.mkForce "JetBrains Mono NL";
      buffer_font_size = lib.mkForce 15;
      buffer_font_family = lib.mkForce "JetBrains Mono NL";
      buffer_line_height = "standard";
      tabs = {
        close_position = "left";
        file_icons = false;
        git_status = false;
        activate_on_close = "history";
        show_close_button = "hover";
        show_diagnostics = "off";
      };
      # panels
      git_panel = {
        dock = "right";
      };
      terminal = {
        font_family = "JetBrains Mono NL";
        line_height = "standard";
      };
      # lsp
      inlay_hints = {
        enabled = false;
      };
      auto_install_extensions = {
        "docker-compose" = true;
        dockerfile = true;
        env = true;
        "git-firefly" = true;
        "gruvbox-material" = true;
        html = true;
        log = true;
        make = true;
        "material-icon-theme" = true;
        "mcp-server-context7" = true;
        "mcp-server-sequential-thinking" = true;
        nix = true;
        proto = true;
        sql = true;
        toml = true;
        vue = true;
        lua = true;
      };
      lsp = {
        nixd = {
          initialization_options = {
            formatting = {
              command = [ "nixfmt" ];
            };
          };
        };
      };
      languages = {
        Nix = {
          "language_servers" = [ "nixd" ];
        };
      };
    };
  };
}
