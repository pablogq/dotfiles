{ pkgs, ... }: {

  imports = [ ./brew.nix ];

  #####################
  # NIX Configuration #
  #####################

  nix.package = pkgs.nix;
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

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  users.users.pablogq.home = "/Users/pablogq";
  users.users.pablogq.shell = pkgs.fish;

  environment.shells = [ pkgs.fish ];
  environment.systemPackages = [ ];
  environment.variables = {
    EDITOR = "vim";
  };

  programs.fish.enable = true;
  programs.nix-index.enable = true;

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

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
