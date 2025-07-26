Default nixos install for dev. Featuring:

-Gnome display manager, because it's basic and Enlightenment breaks on 1366x768 screens.

-Flatpaks for anything that I think might get broken or otherwise be a pain in the ass when installed into the default nixos setup.

-The default set of packages I want to use.

-steam-devices udev rules.

-The latest low latency kernel, for music production. jackd is enabled, and the main user is in the audio group.

-GNOME Dock is set up with shortcuts automatically.

The laptop- version uses tlp instead of ppd, with all-powersave settings. I still need to test this.
The music- version installs everything directly. To grab vsts, I needed to search for them at the root level:
find / -iname vst
and then manually add them into my DAW. But it did work, I have Surge XT in Reaper.
music-configuration also doesn't use flatpak at all, so you can use the file by itself there.

To clean up the boot menu:
sudo nix-collect-garbage --delete-older-than 1d
sudo nixos-rebuild boot
