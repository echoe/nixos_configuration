# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
# Unnecessary parts have been trimmed to taste.

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./flatpak.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enabling realtime kernel.
  boot.kernelPackages = pkgs.linuxPackages-rt_latest;

  # Enabling SteamOS controller support.
  hardware.steam-hardware.enable = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable Gnome.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Set proper plugin paths.
  environment.variables = let
    makePluginPath = format:
      (lib.makeSearchPath format [
        "$HOME/.nix-profile/lib"
        "/run/current-system/sw/lib"
        "/etc/profiles/per-user/$USER/lib"
      ])
      + ":$HOME/.${format}";
  in {
    DSSI_PATH   = makePluginPath "dssi";
    LADSPA_PATH = makePluginPath "ladspa";
    LV2_PATH    = makePluginPath "lv2";
    LXVST_PATH  = makePluginPath "lxvst";
    VST_PATH    = makePluginPath "vst";
    VST3_PATH   = makePluginPath "vst3";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’. Audio group added.
  users.users.iris = {
    isNormalUser = true;
    description = "iris";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # set Gnome dock apps
  programs.dconf.profiles.user = {
    databases = [{
      lockAll = true;
      settings = {
        "org/gnome/shell" = {
          favorite-apps = ["org.gnome.Console.desktop" "firefox.desktop" "cockos-reaper.desktop" "discord.desktop" "steam.desktop" "com.obsproject.Studio.desktop" "code.desktop"];
        };
      };
    }];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "iris";

  # Install flatpak.
  services.flatpak.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    git
    nextcloud-client
    # gnome dock
    gnomeExtensions.dash-to-dock
    gnomeExtensions.blur-my-shell
    steam
    discord
    krita
    obsidian
    # Renoise only. Everything else is in flatpak :)
    renoise
  ];
  #Custom stuff to install my specific version of renoise.
  nixpkgs.overlays = [ (self: super: {
    renoise = super.renoise.override {
      releasePath = /home/iris/Downloads/rns_351_linux_x86_64.tar.gz;
    };
  })];

  # Manage power settings. This is auto-cpufreq, as per https://nixos.wiki/wiki/Laptop
  # Also gotta disable the default.
  #services.power-profiles-daemon.enable = false;
  #services.auto-cpufreq.enable = true;
  #services.auto-cpufreq.settings = {
  #  battery = {
  #     governor = "powersave";
  #     turbo = "never";
  #  };
  #  charger = {
  #     governor = "powersave";
  #     turbo = "never";
  #  };
  #};

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
