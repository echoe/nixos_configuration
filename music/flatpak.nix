# This is from reddit, https://www.reddit.com/r/NixOS/comments/1hzgxns/fully_declarative_flatpak_management_on_nixos/
{ config, pkgs, ... }:
let
  # We point directly to 'gnugrep' instead of 'grep'
  grep = pkgs.gnugrep;
  # 1. Declare the Flatpaks you *want* on your system
  desiredFlatpaks = [
    "com.valvesoftware.Steam"
    "com.obsproject.Studio"
    "com.obsproject.Studio.Plugin.DroidCam"
    "com.obsproject.Studio.Plugin.BackgroundRemoval"
    "com.obsproject.Studio.Plugin.CompositeBlur"
    "com.obsproject.Studio.Plugin.waveform"
    "fm.reaper.Reaper"
    "com.bitwig.BitwigStudio"
    "runtime/org.freedesktop.LinuxAudio.Plugins.swh/x86_64/24.08"
    "runtime/org.freedesktop.LinuxAudio.Plugins.TAP/x86_64/24.08"
    "runtime/org.freedesktop.LinuxAudio.Plugins.Calf/x86_64/24.08"
    "runtime/org.freedesktop.LinuxAudio.Plugins.LSP/x86_64/24.08"
    "runtime/org.freedesktop.LinuxAudio.Plugins.ZamPlugins/x86_64/24.08"
    "runtime/org.freedesktop.LinuxAudio.Plugins.MDA/x86_64/24.08"
    "runtime/org.freedesktop.LinuxAudio.Plugins.CMT/x86_64/24.08"
    "runtime/org.freedesktop.LinuxAudio.Plugins.Surge-XT/x86_64/24.08"
    "runtime/org.freedesktop.LinuxAudio.Plugins.x42Plugins/x86_64/24.08"
    "runtime/org.freedesktop.LinuxAudio.Plugins.Cardinal/x86_64/24.08"
    "runtime/org.freedesktop.LinuxAudio.Plugins.Helm/x86_64/24.08"
    "runtime/org.freedesktop.LinuxAudio.Plugins.sfizz/x86_64/24.08"
    "runtime/org.freedesktop.LinuxAudio.Plugins.Yoshimi/x86_64/24.08"
    "runtime/org.freedesktop.LinuxAudio.Plugins.Dexed/x86_64/24.08"
    "runtime/org.freedesktop.LinuxAudio.Plugins.Airwindows/x86_64/24.08"
    "runtime/org.freedesktop.LinuxAudio.Plugins.ChowDSP-Plugins/x86_64/24.08"
    "runtime/org.freedesktop.LinuxAudio.Plugins.Odin2/x86_64/24.08"
    "runtime/org.freedesktop.LinuxAudio.Plugins.Fabla/x86_64/24.08"
    "runtime/org.freedesktop.LinuxAudio.Plugins.Sorcer/x86_64/24.08"
    "runtime/org.freedesktop.LinuxAudio.Plugins.Tunefish4/x86_64/24.08"
    "runtime/org.freedesktop.LinuxAudio.Plugins.ArtyFX/x86_64/24.08"
    "runtime/org.freedesktop.LinuxAudio.Plugins.OBXd/x86_64/24.08"
    "runtime/org.freedesktop.LinuxAudio.Plugins.ChowTapeModel/x86_64/24.08"
    "runtime/org.freedesktop.LinuxAudio.Plugins.WhiteElephantAudio/x86_64/24.08"
    "runtime/org.freedesktop.LinuxAudio.Plugins.Stochas/x86_64/24.08"
    "runtime/org.freedesktop.LinuxAudio.Plugins.InfamousPlugins/x86_64/24.08"
    "runtime/org.freedesktop.LinuxAudio.Plugins.UhhyouPlugins/x86_64/24.08"
  ];
in {
  system.userActivationScripts.flatpakManagement = {
    text = ''
      # 2. Ensure the Flathub repo is added
      ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub \
        https://flathub.org/repo/flathub.flatpakrepo

      # 3. Get currently installed Flatpaks
      installedFlatpaks=$(${pkgs.flatpak}/bin/flatpak list --app --columns=application)

      # 4. Remove any Flatpaks that are NOT in the desired list
      for installed in $installedFlatpaks; do
        if ! echo ${toString desiredFlatpaks} | ${grep}/bin/grep -q $installed; then
          echo "Removing $installed because it's not in the desiredFlatpaks list."
          ${pkgs.flatpak}/bin/flatpak uninstall -y --noninteractive $installed
        fi
      done

      # 5. Install or re-install the Flatpaks you DO want
      for app in ${toString desiredFlatpaks}; do
        echo "Ensuring $app is installed."
        ${pkgs.flatpak}/bin/flatpak install -y flathub $app
      done

      # 6. Remove unused Flatpaks
      ${pkgs.flatpak}/bin/flatpak uninstall --unused -y

      # 7. Update all installed Flatpaks
      ${pkgs.flatpak}/bin/flatpak update -y
    '';
  };
}
