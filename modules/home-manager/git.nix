{
  ...
}:

{
  programs.git = {
    enable = true;
    lfs.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
      include.path = "~/.gituser";
      push = {
        autoSetupRemote = true;
      };
    };
  };
}
