{ config, pkgs, ... }:

{
  # 1. Imports
  imports = [
    ./hardware-configuration.nix
  ];

  # 2. Boot
# Boot
boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;

  # 3. Networking
# Networking
networking.hostName = "nix";
networking.networkmanager.enable = true;

  # 4. Localization
time.timeZone = "Europe/Budapest";

i18n.defaultLocale = "en_US.UTF-8";

i18n.extraLocaleSettings = {
  LC_ADDRESS = "hu_HU.UTF-8";
  LC_IDENTIFICATION = "hu_HU.UTF-8";
  LC_MEASUREMENT = "hu_HU.UTF-8";
  LC_MONETARY = "hu_HU.UTF-8";
  LC_NAME = "hu_HU.UTF-8";
  LC_NUMERIC = "hu_HU.UTF-8";
  LC_PAPER = "hu_HU.UTF-8";
  LC_TELEPHONE = "hu_HU.UTF-8";
  LC_TIME = "hu_HU.UTF-8";
};

services.xserver.xkb.layout = "hu";
console.keyMap = "hu";

  # 5. Users
# Users
users.users.gergo = {
  isNormalUser = true;

  extraGroups = [
    "wheel"
    "networkmanager"
  ];
};

  # 6. Packages
environment.systemPackages = with pkgs; [
  # Editors
  vim

  # Development / CLI
  git
  wget
  curl

  # System utilities
  htop
  tree
  unzip
  zip
];

  # 7. Services
  # services....

  # 8. Programs
  # programs....

  # 9. Nix configuration
# Nix
nix.settings.experimental-features = [
  "nix-command"
  "flakes"
];

  # 10. NixOS compatibility version
  system.stateVersion = "26.05";
}
