{ config, lib, pkgs, ... }:

{
  # 1. Imports
  imports = [
    ./hardware-configuration.nix
  ];

  # 2. Boot
# Boot
boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;

boot.initrd.systemd.enable = true;       # initramfs

boot.blacklistedKernelModules = [ "nouveau" ];


  # 3. Networking
# Networking
networking.hostName = "nix";
networking.networkmanager.enable = true;


networking.firewall = {
  enable = true;

  allowedTCPPorts = [
    25565
  ];
};

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

users.users.public = {
  isSystemUser = true;
  group = "public";
  shell = "${pkgs.util-linux}/sbin/nologin";
};

users.groups.public = {};

  # 6. Packages
environment.systemPackages = with pkgs; [
  # Editors
  vim

  # Development / CLI
  git
  wget
  curl
  gnupg
  pinentry-qt

  # System utilities
  htop
  tree
  unzip
  zip

  # System
  networkmanager-openvpn

  #desktop
  waybar
  hyprpaper
  hyprlock
  hyprpolkitagent
  rofi
  terminator
  doublecmd
  librewolf
  qbittorrent
  swaynotificationcenter
  wl-clipboard
  cliphist
  playerctl
  usbguard-notifier
  pavucontrol

  libsForQt5.qtwayland
  qt6.qtwayland

  # Desktop / utilities
  vlc
  qalculate-qt
  thunderbird
  keepassxc
  gimp
  audacious
  vesktop

  # Gaming
  lutris
  prismlauncher

  # Development
  dbeaver-bin
  jetbrains.rider
  jetbrains.webstorm

  # HTTP client
  bruno
];

  # 7. Services
# Login manager
services.greetd = {
  enable = true;

  settings = {

    terminal.vt = lib.mkForce 2;


    default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet -t -r -c 'uwsm start select'";
      user = "greeter";
    };
  };
};

services.usbguard = {
  enable = true;
  dbus.enable = true;

  rules = ''
    allow id 1d6b:0002
    allow id 1d6b:0003
    allow id 1d6b:0002
    allow id 1d6b:0003
    allow id 1d6b:0002
    allow id 1d6b:0003
    allow id 1d6b:0002
    allow id 1d6b:0003
    
    allow id 09da:90c0
    
    allow id 09da:56c6
  
  '';
};

services.postgresql = {
  enable = true;
};

services.mysql = {
  enable = true;
  package = pkgs.mariadb;
};


services.samba = {
  enable = true;
  openFirewall = true;

  settings = {
    global = {
      workgroup = "WORKGROUP";
      "server string" = "Public LAN File Share";

      "server min protocol" = "SMB2";
      "server max protocol" = "SMB3";

      security = "user";

      "hosts allow" =
        "127. 10. 172.16.0.0/12 192.168. ::1 fe80::/10 fc00::/7";
      "hosts deny" = "0.0.0.0/0 ::";

      "log file" = "/var/log/samba/%m.log";
      "log level" = "1";
    };

    public = {
      path = "/srv/smb/public";
      writable = true;

      "valid users" = "public";
      "force user" = "public";
      "force group" = "public";

      "create mask" = "0666";
      "directory mask" = "0777";
      "force create mode" = "0666";
      "force directory mode" = "0777";
    };
  };
};
system.activationScripts.sambaPublicUser = ''
  if ! ${pkgs.samba}/bin/pdbedit -L | ${pkgs.gnugrep}/bin/grep -q '^public:'; then
    ${pkgs.samba}/bin/smbpasswd -a -s public <<EOF
public
public
EOF
  fi
'';

# Audio
services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
  jack.enable = true;
};

  # 8. Programs
# Hyprland
programs.hyprland = {
  enable = true;
  withUWSM = true;
};
environment.sessionVariables.NIXOS_OZONE_WL = "1";

programs.steam.enable = true;


programs.nix-ld.enable = true;

  # 9. Nix configuration
# Nix
nix.settings.experimental-features = [
  "nix-command"
  "flakes"
];

nixpkgs.config.allowUnfree = true;



  # 10. NixOS compatibility version
  system.stateVersion = "26.05";
}
