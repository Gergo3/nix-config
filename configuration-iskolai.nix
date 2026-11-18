{ config, lib, pkgs, ... }:

{
  # 1. Imports
  imports = [
    ./hardware-configuration-iskolai.nix
  ];

  # 2. Boot
boot.loader.systemd-boot.enable = false;
boot.loader.grub = {
  enable = true;
  device = "/dev/sda";   # whole disk, not a partition
};


  # 3. Networking
# Networking
networking.hostName = "PC3_14";

networking.networkmanager = {
  enable = true;
  plugins = with pkgs; [
    networkmanager-openvpn
  ];
};


networking.firewall = {
  enable = true;
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
  libsForQt5.qt5ct
  qt6.qtwayland


  yt-dlp

  # Desktop / utilities
  vlc
  qalculate-qt
  thunderbird
  keepassxc
  gimp
  audacious

  # Development
  dbeaver-bin
  #jetbrains.rider
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
      command = "${pkgs.tuigreet}/bin/tuigreet -t -r -c 'uwsm start default'";
      user = "greeter";
    };
  };
};

services.flatpak = {
  enable = true;
};

services.gvfs.enable = true;

services.postgresql = {
  enable = true;
};

services.mysql = {
  enable = true;
  package = pkgs.mariadb;
};

# Audio
services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
  jack.enable = true;
};


# Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # useful for Steam/gaming
  };

  # 8. Programs
# Hyprland
programs.hyprland = {
  enable = true;
  withUWSM = true;
};
environment.sessionVariables.NIXOS_OZONE_WL = "1";

programs.nix-ld.enable = true;

  # 9. Nix configuration
# Nix
nix.settings.experimental-features = [
  "nix-command"
  "flakes"
];

nixpkgs.config.allowUnfree = true;


  # 10. Virtualisation
  virtualisation.docker.enable = true;

  virtualisation.oci-containers.backend = "docker";

  environment.etc."seaweedfs/s3.json".text = builtins.toJSON {
    identities = [{
      name = "dev";
      credentials = [{ accessKey = "devkey"; secretKey = "devsecret"; }];
      actions = [ "Admin" "Read" "Write" "List" "Tagging" ];
    }];
  };

  systemd.tmpfiles.rules = [ "d /var/lib/seaweedfs 0750 root root -" ];

  virtualisation.oci-containers.containers.seaweedfs = {
    image = "chrislusf/seaweedfs:latest";   # pin a version tag once things work
    cmd = [
      "server"
      "-dir=/data"
      "-master.volumeSizeLimitMB=256"
      "-volume.max=100"
      "-filer"
      "-s3"
      "-s3.config=/etc/seaweedfs/s3.json"
    ];
    volumes = [
      "/var/lib/seaweedfs:/data"
      "/etc/seaweedfs/s3.json:/etc/seaweedfs/s3.json:ro"
    ];
    ports = [
      "127.0.0.1:8333:8333"   # S3 API
      "127.0.0.1:8888:8888"   # filer UI
      "127.0.0.1:9333:9333"   # master UI
    ];
  };



  # 11. NixOS compatibility version
  system.stateVersion = "26.05";
}
