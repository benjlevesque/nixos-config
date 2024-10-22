# nixos-config
Personal dotfiles and configuration for use on both laptop and desktop.

Features:
- home-manager
- disk partition with `disko`
- full disk encryption
- Gnome desktop environment


## Setup blank pc

> ⚠️ Use at your own risk. This configuration is intended for my personal use, and tested on my machine. You typically need a different `hardware-config.nix` to use this.

- boot from USB stick
- clone the config
```bash
nix-shell -p git
git clone https://github.com/benjlevesque/nixos-config
```
- create a disk encryption secret 
```bash
vim /tmp/secret.key
```

- Create disk partitions (⚠️ this wipes the disk ⚠️)
```bash
sudo nix \
  --experimental-features "nix-command flakes" \
  run github:nix-community/disko -- \
  --mode disko nixos-config/hosts/laptop/disks.nix
```

- By now you should have `/mnt` mounted.
- Move the nix config to the new partition
```bash
sudo mkdir /mnt/etc
sudo cp -r nixos-config/ /mnt/etc/nixos
```
- Verify your machine configuration against live one
```bash
sudo nixos-generate-config --no-filesystems --root /tmp/nixos-config-new
```

- Run installation
```bash
sudo nixos-install --root /mnt --flake '/mnt/etc/nixos#comet'
#or, without a root password (remember to setup user password later) 
sudo nixos-install --root /mnt --no-root-passwd --flake '/mnt/etc/nixos#comet'
```

- Set user password
```bash
sudo nixos-enter --root /mnt -c 'passwd benji'
```

- `reboot`



## First boot

- setup fingerprint scans
- generate ssh key
```bash
ssh-keygen
```

- import gpg secret key + mark ultimate
```bash
gpg --import /path/to/key.gpg
gpg --edit KEY_ID trust
# choose 5, then `quit`
```
- get passwords
- setup GH
```bash
gh auth login --git-protocol ssh
```
