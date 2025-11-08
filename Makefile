update:
	nix flake update
	nixos-rebuild switch --flake .#pc --impure --upgrade --option allow-dirty true

switch:
	nixos-rebuild switch --flake .#pc --impure --option allow-dirty true

test:
	nixos-rebuild test --flake .#pc --impure
