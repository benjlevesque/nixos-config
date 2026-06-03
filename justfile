default:
  @just --list

# Rebuilds the system
rebuild:
	nixos-rebuild --flake ~/.nixos --sudo switch
# Uprades the system 
upgrade:
	nixos-rebuild --flake ~/.nixos --sudo switch --upgrade
