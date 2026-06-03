default:
  @just --list

# Rebuilds the system
rebuild:
	nixos-rebuild --flake ~/.nixos --sudo switch
# Uprades the system 
upgrade:
	nixos-rebuild --flake ~/.nixos --sudo switch --upgrade

# Upgrade home-manager only
home-switch:
	nix run home-manager/master -- switch --flake .

