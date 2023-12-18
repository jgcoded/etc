# Archlinux Setup

Archlinux with btrfs, automatic snapshots, swapfile, disk encryption, and zstd compression.
These were the steps I followed for a clean install without a Desktop Environment or Window Manager.

## archiso

Download the archiso from here archlinux.org. Boot into the iso and check your internet connection:

```
root@archiso ~ # ip link
root@archiso ~ # ip addr show
root@archiso ~ # ping archlinux.org
root@archiso ~ # timedatectl set-ntp true
```

## Partitions

Before creading the partitions, securely erase the disk.

Boot into the live environment and then use fdisk on your hard drive to create the partitions as shown in the below table. Be sure to format the EFI partitions.

```
root@archiso ~ # fdisk -l
root@archiso ~ # fdisk /dev/sda
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
root@archiso ~ # mkfs.fat -F32 /dev/sda1
```

## btrfs initialization with encryption

```
root@archiso ~ # cryptsetup -s 512 luksFormat --type luks1 /dev/sda2
```
Enter a password

```
root@archiso ~ # cryptsetup luksDump /dev/sda2
root@archiso ~ # cryptsetup open /dev/sda2 cryptroot
root@archiso ~ # mkfs.btrfs -L btrfs /dev/mapper/cryptroot
root@archiso ~ # mount /dev/mapper/cryptroot /mnt
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
root@archiso ~ # btrfs subvolume create /mnt/@
root@archiso ~ # btrfs subvolume create /mnt/@home
root@archiso ~ # btrfs subvolume create /mnt/@snapshots
root@archiso ~ # btrfs subvolume create /mnt/@var_log
root@archiso ~ # btrfs subvolume create /mnt/@var_cache_pacman_pkg
root@archiso ~ # btrfs subvolume create /mnt/@var_abs
root@archiso ~ # btrfs subvolume create /mnt/@var_tmp
root@archiso ~ # btrfs subvolume create /mnt/@srv
root@archiso ~ # btrfs subvolume create /mnt/@swap
root@archiso ~ # umount /mnt
root@archiso ~ # mount -o noatime,compress-force=zstd,space_cache=v2,subvol=@ /dev/mapper/cryptroot /mnt
```
If the mount command doesn't work, use `subvolid` instead of `subvol`.

```
root@archiso ~ # mkdir -p /mnt/{boot,home,.snapshots,var/log,var/cache/pacman/pkg,var/abs,/var/tmp,srv,swap}
root@archiso ~ # mount -o noatime,compress-force=zstd,space_cache=v2,subvol=@home /dev/mapper/cryptroot /mnt/home
root@archiso ~ # mount -o noatime,compress-force=zstd,space_cache=v2,subvol=@snapshots /dev/mapper/cryptroot /mnt/.snapshots
root@archiso ~ # mount -o noatime,compress-force=zstd,space_cache=v2,subvol=@var_log /dev/mapper/cryptroot /mnt/var/log
root@archiso ~ # mount -o noatime,compress-force=zstd,space_cache=v2,subvol=@var_cache_pacman_pkg /dev/mapper/cryptroot /mnt/var/cache/pacman/pkg
root@archiso ~ # mount -o noatime,compress-force=zstd,space_cache=v2,subvol=@var_abs /dev/mapper/cryptroot /mnt/var/abs
root@archiso ~ # mount -o noatime,compress-force=zstd,space_cache=v2,subvol=@var_tmp /dev/mapper/cryptroot /mnt/var/tmp
root@archiso ~ # mount -o noatime,compress-force=zstd,space_cache=v2,subvol=@srv /dev/mapper/cryptroot /mnt/srv
root@archiso ~ # mount -o noatime,compress-force=zstd,space_cache=v2,subvol=@swap /dev/mapper/cryptroot /mnt/swap

```



## Set up swap file

```
root@archiso ~ # truncate -s 0 /mnt/swap/swapfile
root@archiso ~ # chattr +C /mnt/swap
root@archiso ~ # dd if=/dev/zero of=/mnt/swap/swapfile bs=1M count=16384 status=progress
root@archiso ~ # chmod 600 /mnt/swap/swapfile
root@archiso ~ # mkswap /mnt/swap/swapfile
root@archiso ~ # swapon /mnt/swap/swapfile
```

## Setting up encryption

```
root@archiso ~ # mkdir /mnt/efi
root@archiso ~ # mount /dev/sda1 /mnt/efi
root@archiso ~ # dd bs=512 count=4 if=/dev/random of=/crypto_keyfile.bin iflag=fullblock
root@archiso ~ # chmod 600 /crypto_keyfile.bin
root@archiso ~ # cp /crypto_keyfile.bin /mnt
root@archiso ~ # cryptsetup luksAddKey /dev/sda2 /crypto_keyfile.bin

```

## Switch to chroot

```
root@archiso ~ # reflector --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
root@archiso ~ # pacman -Syy
root@archiso ~ # pacstrap /mnt base linux linux-firmware vim intel-ucode btrfs-progs
root@archiso ~ # genfstab -U /mnt >> /mnt/etc/fstab
root@archiso ~ # cat /mnt/etc/fstab
root@archiso ~ # arch-chroot /mnt
```

## chroot

```
[root@archiso /]# timedatectl
[root@archiso /]# ln -sf /usr/share/zoneinfo/<Region>/<City> /etc/localtime
[root@archiso /]# hwclock --systohc
[root@archiso /]# vim /etc/locale.gen
```

In vim, uncomment `en_us.UTF-8 UTF-8`. Then `:wq`.

```
[root@archiso /]# locale-gen
[root@archiso /]# echo "LANG=en_US.UTF-8" >> /etc/locale.conf
[root@archiso /]# echo "my-arch-hostname" >> /etc/hostname
[root@archiso /]# echo "127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.1.1\tmy-arch-hostname.localdomain\tmy-arch-hostname" >> /etc/hosts
[root@archiso /]# echo "PRUNENAMES=\".snapshots\"" >> /etc/updatedb.conf
[root@archiso /]# pacman -Syu networkmanager network-manager-applet grub bash-completion efibootmgr wpa_supplicant git reflector snapper bluez bluez-utils cups hplip xdg-user-dirs xdg-utils alsa-utils pulseaudio pulseaudio-bluetooth dialog base-devel linux-headers
```

## Grub setup

Do these steps while still in arch chroot

```
[root@archiso /]# vim /etc/mkinitcpio.conf
```

Set Modules, Binaries, and Files in the mkinitcpio.conf file:
```
MODULES=(btrfs)
BINARIES=(/usr/bin/btrfs)
FILES=(/crypto_keyfile.bin)

```

And add `encrypt` and `resume` to `HOOKS`. For example:
```conf
HOOKS=(base udev autodetect modconf block encrypt filesystems keyboard resume fsck)
```

And then `:wq`.

```
[root@archiso /]# mkinitcpio -p linux
[root@archiso /]# vim /etc/default/grub
```

Set
```
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

And then, `:wq`. Finally,

```
[root@archiso /]# grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
[root@archiso /]# grub-mkconfig -o /boot/grub/grub.cfg
[root@archiso /]# chmod 600 /boot/initramfs-linux*
```

## systemd setup


```
[root@archiso /]# systemctl enable NetworkManager
[root@archiso /]# systemctl enable bluetooth
[root@archiso /]# systemctl enable cups
```

## User setup
```
[root@archiso /]# useradd -m -G wheel myusername
[root@archiso /]# passwd myusername
[root@archiso /]# EDITOR=vim visudo
```

In vim, uncomment the `%wheel` line. Then `:wq`. Finally,

```
[root@archiso /]# passwd
[root@archiso /]# exit
root@archiso ~ # reboot
```

## Troubleshooting First Reboot
If after the first reboot you are thrown into a grub> prompt, then boot back into the archiso and do:
```
root@archiso ~ # cryptsetup open /dev/sda2 cryptroot
root@archiso ~ # mount -o noatime,compress-force=zstd,space_cache=v2,subvol=@ /dev/mapper/cryptroot /mnt
root@archiso ~ # arch-chroot /mnt
[root@archiso /]# grub-mkconfig -o /boot/grub/grub.cfg
```

## After the first reboot 

If everything went well, you will be asked to enter the disk password. Then, you can log in with your user account. If that worked, then congratulations! You made it past the hardest part.

## Connect to wifi

```
$ nmtui
```

## Setting up automatic backups

```
$ sudo umount /.snapshots
$ sudo rm -r /.snaphots
$ sudo snapper -c root create-config /.
$ sudo btrfs subvolume delete /.snapshots
$ sudo mkdir /.snapshots
$ sudo mount -a
$ sudo chmod 750 /.snapshots
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

```
$ sudo chmod a+rx /.snapshots
$ chown :users /.snapshots
$ sudo systemctl enable --now snapper-timeline.timer
$ sudo systemctl enable --now snapper-cleanup.timer
```

And also add backups snapshots of grub via `snap-pac-grub` from the AUR.

```
$ git clone https://aur.archlinux.org/yay.git
$ cd yay
$ makepkg -si
$ yay -Y --gendb
$ yay -Syu --devel
$ yay -Y --devel --save
$ yay -Syu snap-pac-grub snapper-gui-git snap-pac rsync
```

To enable backups when the kernel is updated, make a `50-bootbackup.hook`:

```
$ sudo mkdir /etc/pacman.d/hooks
$ sudo vim /etc/pacman.d/hooks/50-bootbackup.hook
```

```
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


This completes the setup.


## What to do when things break

First, boot into Archlinux ISO

Then, open all snapshots with vim. Use `:n` and `:rew` to find the snapshot number N as shown in `<num>N</num>`

```
root@archiso ~ # cryptsetup open /dev/sda2 cryptroot
root@archiso ~ # mount /dev/mapper/cryptroot /mnt
root@archiso ~ # vim /mnt/@snapshots/*/info.xml
root@archiso ~ # mv /mnt/@ /mnt/@.broken
root@archiso ~ # btrfs subvolume snapshot /mnt/@snapshots/N/snapshot /mnt/@
```

and then reboot. You are now recovered!

You can also view the system log with
```
journalctl -s -1h
```

### What to do when you end up on the GRUB Rescue shell due to invalid passphrase

Sometimes you may mistakenly enter the wrong passphrase to decrypt the disk at boot time. You will end up at the GRUB Rescue shell. Use these commands to try again:

```
> cryptomount -a
> insmod normal
> normal
```


### What to do when the system goes directly to BIOS after decrypting the disk

One time I missed [this post](https://archlinux.org/news/grub-bootloader-upgrade-and-configuration-incompatibilities/) in the archlinux home page about a change in Grub. After a grub package update it is advised to run both, installation and regeneration of configuration. The high level description of the steps:

1. Boot to the Archlinux Live USB
2. Use `fdisk -l` to identify the EFI and disk partitions
3. mount those partitions
4. chroot
5. Run grub commands
6. reboot

```
root@archiso ~ # fdisk -l
root@archiso ~ # cryptsetup open /dev/sda2 cryptroot
root@archiso ~ # mount -o noatime,compress-force=zstd,space_cache=v2,subvol=@ /dev/mapper/cryptroot /mnt
root@archiso ~ # mount /dev/sda1 /mnt/efi
root@archiso ~ # arch-chroot /mnt
[root@archiso /]# grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
[root@archiso /]# grub-mkconfig -o /boot/grub/grub.cfg
[root@archiso /]# chmod 600 /boot/initramfs-linux*
[root@archiso /]# exit
root@archiso ~ # systemctl reboot
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
$ sudo pacman -Syu compsize
$ compsize -x /
```

List subvolumes

```
# btrfs subvolume list /
```


