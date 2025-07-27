A Useful(?) Default NixOS Configuration

# Table of contents
1. [Intro](#intro)
2. [Organization](#config)
3. [What to edit](#editing)
4. [General NixOS tips](#tips)

# Intro <a name="intro"></a>

My personal default nixos install, to be ran AFTER going through a general install with a USB NixOS installation drive. Featuring:

-Gnome display manager, because it's basic and Enlightenment breaks on 1366x768 screens.

-Flatpaks for anything that I think might get broken or otherwise be a pain in the ass when installed into the default nixos setup.

-The default set of packages I want to use.

-steam-devices udev rules.

-The latest low latency kernel for music production. jackd is enabled, and the main user is in the audio group. Latency for me is acceptable when I flip renoise to use jackd.

-GNOME Dock is set up with shortcuts automatically.

# Organization <a name="config"></a>

Well, this is two questions. For the first one, I have written different configuration files because sometimes you need different settings depending on what different computers are required to do. For the current scripts in this repo:

- I have always had infinite issues setting up workstations for music. Therefore, the two scripts in music install everything directly, using flatpak. You do need to add /app/extensions/plugins/(plugintype) to the settings of the DAWs that are installed here to properly grab the plugins.

- The base configuration.nix has a base setup.

- The other folder is configurations that are in progress.

# What to Edit <a name="editing"></a>

From the top down:
-Change my username to yours. Anywhere that has 'iris' in it, you'll want to replace that with your username. You should have picked your username when you went through initial NixOS setup.
-For all of the apps in 'favorite-apps', you will want to pick your own favorite apps. You can find the desktop extensions for all of your apps by running this command in a terminal:

ls /run/current-system/sw/share/applications/

If you have a specific app in mind, you can just run this to get its exact name, replacing name with the name:

ls /run/current-system/sw/share/applications/ | grep name

-In the 'environment.systemPackages' part, put any of your own packages there. You can find packages on NixOS's website: https://search.nixos.org/packages . This is how you pick the packages to install. (After you install a package you can then choose to put it in your gnome dock, even!)

-Finally, if you installed a different version of NixOS, you may want to set this config file so it agrees with your NixOS install version. It's possible that this won't work, though ... so for now this is 25.06 only.

-If you are using the music config, change the location of renoise to wherever you've downloaded your personal copy of renoise (linux). Sadly Renoise cannot use the installed plugins, but this doesn't affect my personal usage of it. 

Then you're done!

# Tips <a name="tips"></a>

-sudo nixos-rebuild switch applies your configuration changes.

-If something looks weird after sudo nixos-rebuild switch, you may just need to restart.

-If you tried to replace your desktop environment and broke the whole thing, you can ctrl+alt+f1 and edit the configuration.nix file, then rebuild again, and it should all be good on a reboot! Don't be too afraid! 

-To clean up the boot menu:
sudo nix-collect-garbage --delete-older-than 1d
sudo nixos-rebuild boot

-In general I've been able to do anything I want ... it just requires ... a lot of elbow grease. But you get there. And then hopefully you don't have to do it again. Also, you actually learn /how/ everything works in the process of setting this all up.

Happy trails!
