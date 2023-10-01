users.users.YourUsername = {
  extraGroups = [
    "networkmanager"
  ];
};
programs.hyprland = {
  enable = true; 
  xwayland.hidpi = true;
  xwayland.enable = true;
};

# Hint Electon apps to use wayland
environment.sessionVariables = {
  NIXOS_OZONE_WL = "1";
};
services.dbus.enable = true;
xdg.portal = {
  enable = true;
  wlr.enable = true;
  extraPortals = [
    pkgs.xdg-desktop-portal-gtk
  ];
};
environment.systemPackages = with pkgs; [
  hyprland
  swww # for wallpapers
  xdg-desktop-portal-gtk
  xdg-desktop-portal-hyprland
  xwayland
];
nixpkgs.overlays = [
  (self: super: {
    waybar = super.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    });
  })
];
environment.systemPackages = with pkgs; [
  meson
  wayland-protocols
  wayland-utils
  wl-clipboard
  wlroots
  firefox
  gcc
  # common utilities
  busybox 
  scdoc
  mpv
  gcc
  git
  # notification daemon
  dunst
  # terminal emulator
  kitty
  # networking
  networkmanagerapplet # GUI for networkmanager
  # app launchers
  rofi-wayland
  nano
];
fonts.fonts = with pkgs; [
  nerdfonts
  meslo-lgs-nf
];
sound.enable = true;
security.rtkit.enable = true;
services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
};
