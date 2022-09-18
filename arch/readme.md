# Archlinux Setup

Archlinux with btrfs, automatic snapshots, swapfile, disk encryption, and zstd compression.
These were the steps I followed for a clean install without a Desktop Environment or Window Manager.

## archiso

Download the archiso from here archlinux.org. Boot into the iso and check your internet connection:

```
# ip link
# ip addr show
# ping archlinux.org
# timedatectl set-ntp true
```

## Partitions

Before creading the partitions, securely erase the disk.

Boot into the live environment and then use fdisk on your hard drive to create the partitions as shown in the below table. Be sure to format the EFI partitions.

```bash
# fdisk -l
# fdisk /dev/sda
```

Type | Partition | Encryption | Size | Mount Point
-|-|-|-|-
EFI|/dev/sda1|No|300MiB|/mnt/efi
8309|/dev/sda2|LUKS1|Remaining|/mnt

8309 is Linux type with LUKS 

Within fdisk, use this commands
```
n
type: primary
Partition number: default
first sector: default
last sector: +300MiB

t
partition number: 1
hex code: ef

n
type: primary
Partition number: default
first sector: default
last sector: default

t
partition number: 2
hex code: 8309

p
w
```

Then,

```
# mkfs.fat -F32 /dev/sda1
```

## btrfs initialization with encryption

```
# cryptsetup -s 512 luksFormat --type luks1 /dev/sda2
```
Enter a password

```
# cryptsetup luksDump /dev/sda2
# cryptsetup open /dev/sda2 cryptroot
# mkfs.btrfs -L btrfs /dev/mapper/cryptroot
# mount /dev/mapper/cryptroot /mnt
```

### btrfs subvolume setup

Subvolume|Mount point
-|-
@|/
@home|/home
@snapshots|/.snapshots
@var_log|/var/log
@var_cache_pacman_pkg|/var/cache/pacman/pkg
@var_abs|/var/abs
@var_tmp|var/tmp
@srv|/srv
@swap|/swap

```
# btrfs subvolume create /mnt/@
# btrfs subvolume create /mnt/@home
# btrfs subvolume create /mnt/@snapshots
# btrfs subvolume create /mnt/@var_log
# btrfs subvolume create /mnt/@var_cache_pacman_pkg
# btrfs subvolume create /mnt/@var_abs
# btrfs subvolume create /mnt/@var_tmp
# btrfs subvolume create /mnt/@srv
# btrfs subvolume create /mnt/@swap
# umount /mnt
# mount -o noatime,compress-force=zstd,space_cache=v2,subvol=@ /dev/mapper/cryptroot /mnt
```
If the mount command doesn't work, use `subvolid` instead of `subvol`.

```
# mkdir -p /mnt/{boot,home,.snapshots,var/log,var/cache/pacman/pkg,var/abs,/var/tmp,srv,swap}

# mount -o noatime,compress-force=zstd,space_cache=v2,subvol=@home /dev/mapper/cryptroot /mnt/home

# mount -o noatime,compress-force=zstd,space_cache=v2,subvol=@snapshots /dev/mapper/cryptroot /mnt/.snapshots

# mount -o noatime,compress-force=zstd,space_cache=v2,subvol=@var_log /dev/mapper/cryptroot /mnt/var/log

# mount -o noatime,compress-force=zstd,space_cache=v2,subvol=@var_cache_pacman_pkg /dev/mapper/cryptroot /mnt/var/cache/pacman/pkg

# mount -o noatime,compress-force=zstd,space_cache=v2,subvol=@var_abs /dev/mapper/cryptroot /mnt/var/abs

# mount -o noatime,compress-force=zstd,space_cache=v2,subvol=@var_tmp /dev/mapper/cryptroot /mnt/var/tmp

# mount -o noatime,compress-force=zstd,space_cache=v2,subvol=@srv /dev/mapper/cryptroot /mnt/srv

# mount -o noatime,compress-force=zstd,space_cache=v2,subvol=@swap /dev/mapper/cryptroot /mnt/swap

```



## Set up swap file

```
# cd /mnt/swap
# truncate -s 0 /.swapfile
# chattr +C /mnt/swap
# dd if=/dev/zero of=/mnt/swap/swapfile bs=1M count=16384 status=progress
# chmod 600 /mnt/swap/swapfile
# mkswap /mnt/swap/swapfile
# swapon /mnt/swap/swapfile
```


This line is only needed if not using genfstab. It is used after generating /etc/fstab
```
# echo "/swap/swapfile none swap defaults 0 0" >> /etc/fstab
```

## Setting up encryption

```
# cd /
# mkdir /mnt/efi
# mount /dev/sda1 /mnt/efi
# dd bs=512 count=4 if=/dev/random of=/crypto_keyfile.bin iflag=fullblock
# chmod 600 /crypto_keyfile.bin
# cp /crypto_keyfile.bin /mnt
# cryptsetup luksAddKey /dev/sda2 /crypto_keyfile.bin

```

## Switch to chroot

```
# reflector --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
# pacman -Syy
# pacstrap /mnt base linux linux-firmware vim intel-ucode btrfs-progs
# genfstab -U /mnt >> /mnt/etc/fstab
# cat /mnt/etc/fstab
# arch-chroot /mnt
```

## chroot

```shell
$ timedatectl
$ ln -sf /usr/share/zoneinfo/<Region>/<City> /etc/localtime
$ hwclock --systohc
$ vim /etc/locale.gen
```

In vim, uncomment `en_us.UTF-8 UTF-8`

```shell
$ locale-gen
$ echo "LANG=en_US.UTF-8" >> /etc/locale.conf
$ echo "my-arch-hostname" >> /etc/hostname
$ echo "127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.1.1\tmy-arch-hostname.localdomain\tmy-arch-hostname" >> /etc/hosts
$ pacman -Syu networkmanager network-manager-applet grub bash-completion efibootmgr wpa_supplicant git reflector snapper bluez bluez-utils cups hplip xdg-user-dirs xdg-utils alsa-utils pulseaudio pulseaudio-bluetooth dialog base-devel linux-headers
```

## Grub setup

Do these steps while still in arch chroot

```shell
$ vim /etc/mkinitcpio.conf
```

Set Modules, Binaries, and Files in the mkinitcpio.conf file:
```conf
MODULES=(btrfs)
BINARIES=(/usr/bin/btrfs)
FILES=(/crypto_keyfile.bin)

```

And add `encrypt` and `resume` to `HOOKS`. For example:
```conf
HOOKS=(base udev autodetect modconf block encrypt filesystems keyboard resume fsck)
```

```shell
$ mkinitcpio -p linux
$ vim /etc/default/grub
```

Set
```conf
GRUB_ENABLE_CRYPTODISK=y
```

And add this to `GRUB_CMDLINE_LINUX`:
```
cryptdevice=/dev/sda2:cryptroot cryptkey=rootfs:/crypto_keyfile.bin crypto=sha256:aes-xts-plain64:512:0:
```

For hibernation, add this to `GRUB_CMDLINE_LINUX_DEFAULT`:

```
resume=UUID=<swap UUID> resume_offset=16400
```

Finally,

```shell
$ grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
$ grub mkconfig -o /boot/grub/grub.cfg
$ chmod 600 /boot/initramfs-linux*
```

## systemd setup


```shell
$ systemctl enable NetworkManager
$ systemctl enable bluetooth
$ systemctl enable cups
```

## User setup
```
$ useradd -m -G wheel myusername
$ passwd myusername
$ EDITOR=vim visudo
```

In vim, uncomment the `%wheel` line. Then continue to set the root password and exit out of archroot and reboot

```shell
$ passwd
$ exit
# reboot
```

## After the first reboot 

If everything went well, you will be asked to enter the disk password. Then, you can log in with your user account. If that worked, then congratulations! You made it past the hardest part.

## Connect to wifi

```shell
$ nmtui
```

## Setting up automatic backups

```Shell
$ sudo umount /.snapshots
$ sudo rm -r /.snaphots
$ sudo snapper -c root create-config /.
$ sudo btrfs subvolume delete /.snapshots
$ sudo mkdir /.snapshots
$ sudo mount -a
$ sudo chmod 750 /.snapshots
$ sudo echo "PRUNENAMES=\".snapshots\"" >> /etc/updatedb.conf
$ sudo vim /etc/snapper/configs/root
```

Set the following in the snapper configs:

```
ALLOW_USERS="myusername"
TIMELINE_MIN_AGE="1800"
TIMELINE_LIMIT_HOURLY="5"
TIMELINE_LIMIT_DAILY="7"
TIMELINE_LIMIT_WEEKLY="0"
TIMELINE_LIMIT_MONTHLY="0"
TIMELINE_LIMIT_YEARLY="0"
```

Exit vim and then:

```shell
$ sudo chmod a+rx /.snapshots
$ chown :users /.snapshots
$ sudo systemctl enable --now snapper-timeline.timer
$ sudo systemctl enable --now snapper-cleanup.timer
```

And also add backups snapshots of grub via `snap-pac-grub` from the AUR.

```shell
$ git clone https://aur.archlinux.org/yay.git
$ cd yay
$ makepkg -si
$ yay -Y --gendb
$ yay -Syu --devel
$ yay -Y --devel --save
$ yay snap-pac-grub snapper-gui-git
```

To enable backups when the kernel is updated, make a `50-bootbackup.hook`:

```shell
$ sudo mkdir /etc/pacman.d/hooks
$ sudo vim /etc/pacman.d/hooks/50-bootbackup.hook
```

```hook
[Trigger]
Operation = Upgrade
Operation = Install
Operation = Remove
Type = Path
Target = usr/lib/modules/*/vmlinuz

[Action]
Depends = rsync
Description = Backing up /boot
When = PostTransaction
Exec = /usr/bin/rsync -a --delete /boot /.bootbackup
```

Then,

```shell
$ sudo pacman -Syu snap-pac rsync
```


## What to do when things break

First, boot into Archlinux ISO

Then, open all snapshots with vim. Use `:n` and `:rew` to find the snapshot number N as shown in `<num>N</num>`

```shell
$ mount /dev/sda3 /mnt
$ vim /mnt/@snapshots/*/info.xml
$ mv /mnt/@ /mnt/@.broken
$ btrfs subvolume snapshot /mnt/@snapshots/N/snapshot /mnt/@
```

and then reboot. You are now recovered!

You can also view the system log with
```bash
$ journalctl -s -1h
```

## btrfs

Filesystem usage
```
$ btrfs filesystem df
# btrfs filesystem usage /
```

defragment
```
# btrfs filesystem defragment -r /
```

View compression ratio
```
$ compsize -x /
```

List subvolumes

```
# btrfs subvolume list /
```

## Troubleshooting First Reboot
If after the first reboot you are thrown into a grub> prompt, then boot back into the archiso and do:
```shell
# cryptsetup open /dev/sda2 cryptroot
# mount -o noatime,compress-force=zstd,space_cache=v2,subvol=@ /dev/mapper/cryptroot /mnt
# arch-chroot /mnt
# grub-mkconfig -o /boot/grub/grub.cfg
```
