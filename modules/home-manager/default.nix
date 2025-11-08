let
  dir = ./.;

  files = builtins.filter (
    name: builtins.match ".*\\.nix" name != null && name != "default.nix" && name != "nixvim"
  ) (builtins.attrNames (builtins.readDir dir));

  toAttr = name: {
    name = builtins.replaceStrings [ ".nix" ] [ "" ] name;
    value = import (dir + "/${name}");
  };
in
builtins.listToAttrs (map toAttr files)
