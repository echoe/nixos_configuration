A Useful(?) Default NixOS Configuration

# Table of contents
1. [Intro](#intro)
2. [Organization](#config)
3. [What to edit](#editing)
4. [General NixOS tips](#tips)
5. [Possible Expansion](#todo)

# Intro <a name="intro"></a>

My personal default nixos install, to be ran AFTER going through a general install with a USB NixOS installation drive. Featuring:

-Gnome display manager, because it's basic and Enlightenment breaks on 1366x768 screens.

-Flatpaks for anything that I think might get broken or otherwise be a pain in the ass when installed into the default nixos setup.

-The default set of packages I want to use.

-steam-devices udev rules.

-The latest low latency kernel for music production. jackd is enabled, and the main user is in the audio group. Latency for me is acceptable when I flip renoise to use jackd.

-GNOME Dock is set up with shortcuts automatically.

# Organization <a name="config"></a>

I've written a few different versions of my configuration.nix files. For the current scripts in this repo:

- The base configuration.nix has a base setup that doesn't install the VST's/etc. in a customized way.

- I have always had infinite issues setting up workstations for music production in linux. Therefore, the two scripts in music install everything directly - mostly using flatpak. You do need to:
- either remove renoise, or provide your own tarball and replace the path
- add one VST path: /app/extensions/plugins/(plugintype) - to the settings of the DAWs that are installed here to properly grab the plugins.

- The other folder is configurations that are in progress.

# What to Edit <a name="editing"></a>

From the top of configuration.nix down:
-Change my username to yours. Anywhere that has 'iris' in it, you'll want to replace that with your username. You should have picked your username when you went through initial NixOS setup.
-For all of the apps in 'favorite-apps', you will want to pick your own favorite apps. You can find the desktop extensions for all of your apps by running this command in a terminal:

ls /run/current-system/sw/share/applications/

If you have a specific app in mind, you can just run this to get its exact name, replacing name with the name:

ls /run/current-system/sw/share/applications/ | grep name

-In the 'environment.systemPackages' part, put any of your own packages there. You can find packages on NixOS's website: https://search.nixos.org/packages . This is how you pick the packages to install. (After you install a package you can then choose to put it in your gnome dock, even!)

-Finally, if you installed a different version of NixOS, you may want to set this config file so it agrees with your NixOS install version. It's possible that this won't work, though ... so for now this is 25.06 only.

-If you are using the music config, change the location of renoise to wherever you've downloaded your personal copy of renoise (linux). Sadly Renoise cannot use the installed plugins, but this doesn't affect my personal usage of it. 

-You also may want to edit the flatpak apps listed in flatpak.nix if you are using the music production version of this configuration: you can change them in there. Do note that if you don't declare the package you want precisely, flatpak may refuse to install without you specifying the package version.

And then ... you're done!

# Tips <a name="tips"></a>

-sudo nixos-rebuild switch applies your configuration changes.

-If something looks weird after sudo nixos-rebuild switch, you may just need to restart.

-If you tried to replace your desktop environment and broke the whole thing, you can ctrl+alt+f1 and edit the configuration.nix file, then rebuild again, and it should all be good on a reboot! Don't be too afraid! 

-To clean up the boot menu:
sudo nix-collect-garbage --delete-older-than 1d
sudo nixos-rebuild boot

-In general I've been able to do anything I want ... it just requires ... a lot of elbow grease. But you get there. And then hopefully you don't have to do it again. Also, you actually learn /how/ everything works in the process of setting this all up.

Happy trails!

# Possible expansions <a name="todo"></a>

I'd love to make this be a sort of add-on you can import into your automatic configuration.nix file, like my current configuration.nix file is doing with flatpak. So all you would need to do is point to the new file, and everything in the configuration.nix file would be the user customization stuff. I'll update if I figure out how to change to that.
