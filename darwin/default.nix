{ pkgs, ... }:
{

  imports = [ ./brew.nix ];

  #####################
  # NIX Configuration #
  #####################

  nix.package = pkgs.nix;
  nix.enable = true;
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 30d";
  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  ########################
  # System Configuration #
  ########################

  # networking.dns = [ "1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4"];
  networking.dns = [ ];
  networking.knownNetworkServices = [ "Wi-Fi" ];

  users.users.pablogq.home = "/Users/pablogq";
  users.users.pablogq.shell = pkgs.fish;

  environment.shells = [ pkgs.fish ];
  environment.systemPackages = [ pkgs.nixfmt-rfc-style ];
  environment.variables = {
    EDITOR = "vim";
  };

  programs.fish.enable = true;
  programs.nix-index.enable = true;

  system.primaryUser = "pablogq";
  system.defaults.dock.autohide = false;
  system.defaults.dock.orientation = "left";

  system.defaults.finder = {
    AppleShowAllExtensions = true;
  };

  system.defaults.NSGlobalDomain = {
    AppleShowAllExtensions = true;
    NSDocumentSaveNewDocumentsToCloud = false;
    AppleMeasurementUnits = "Centimeters";
    AppleTemperatureUnit = "Celsius";
    AppleMetricUnits = 1;
  };

  system.defaults.CustomUserPreferences = {
    "com.apple.symbolichotkeys" = {
      AppleSymbolicHotKeys = {
        # Disable 'Cmd + Space' for Spotlight Search, it will be handled by Raycast
        "64" = {
          enabled = false;
        };
        # Disable 'Cmd + Alt + Space' for Finder search window
        "65" = {
          enabled = false;
        };
      };
    };
  };

  # Add ability to used TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  # Following line should allow us to avoid a logout/login cycle
  system.activationScripts.postActivation.text = ''
    sudo -u pablogq /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
