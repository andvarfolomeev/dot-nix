{
  pkgs,
  lib,
  config,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf optionals;

  cfg = config.modules.shell;
in
{

  options.modules.shell = {
    netTools = mkEnableOption "";
    encryptionTools = mkEnableOption "";
    hardwareTools = mkEnableOption "";
    gpuTools = mkEnableOption "";
    powerTools = mkEnableOption "";
    memoryTools = mkEnableOption "";
    storageTools = mkEnableOption "";
    gnupg = mkEnableOption "";
    languages = {
      go = mkEnableOption "";
      node = mkEnableOption "";
      nix = mkEnableOption "";
    };
  };

  config = {
    environment.systemPackages =
      with pkgs;
      [
        pfetch
        htop
        btop

        wget
        curl

        git
        lazygit

        fzf
        eza
        bat
        ripgrep
        fd
        rip2
        gnumake

        vim
        neovim
        helix

        tmux
        zellij
        kitty

      ]
      ++ optionals cfg.languages.go [
        go
        gopls
      ]
      ++ optionals cfg.languages.node [
        pnpm
        nodejs
        typescript-language-server
        prettierd
        eslint
      ]
      ++ optionals cfg.languages.nix [
        nixd
        nil
        nixfmt-rfc-style
        nixfmt-tree
      ]
      ++ optionals cfg.netTools [
        nettools
        ethtool
        wirelesstools
        iw
      ]
      ++ optionals cfg.encryptionTools [
        sops
      ]
      ++ optionals cfg.hardwareTools [
        lm_sensors
        hwinfo
        lshw
        pciutils
        dmidecode
      ]
      ++ optionals cfg.gpuTools [
        radeontop
        clinfo
        vulkan-tools
      ]
      ++ optionals cfg.powerTools [
        cpupower
        powertop
      ]
      ++ optionals cfg.memoryTools [
        fio
        memtester
        stress-ng
      ]
      ++ optionals cfg.storageTools [
        smartmontools
        nvme-cli
        hdparm
      ];

    environment.variables.EDITOR = "nvim";

    programs.zsh.enable = true;
    programs.mtr.enable = mkIf cfg.netTools true;
    programs.ssh.startAgent = true;

    programs.gnupg.agent = mkIf cfg.gnupg {
      enable = true;
      enableSSHSupport = false;
      pinentryPackage = pkgs.pinentry-tty; # or pinentry-gnome3/pinentry-qt
    };
  };
}
