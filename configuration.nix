{ config, pkgs, ... }:

{
  # 1. Imports
  imports = [
    ./hardware-configuration.nix
  ];

  # 2. Boot
  # boot....

  # 3. Networking
  # networking....

  # 4. Localization
  # time....
  # i18n....

  # 5. Users
  # users....

  # 6. Packages
  # environment.systemPackages = ...

  # 7. Services
  # services....

  # 8. Programs
  # programs....

  # 9. Nix configuration
  # nix....

  # 10. NixOS compatibility version
  system.stateVersion = "26.05";
}
