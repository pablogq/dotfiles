{ ... }: {
  system.activationScripts.preUserActivation.text = ''
    if ! xcode-select --version 2>/dev/null; then
      $DRY_RUN_CMD xcode-select --install
    fi
    if ! /opt/homebrew/bin/brew --version 2>/dev/null; then
      $DRY_RUN_CMD /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
  '';

  homebrew.enable = true;
  homebrew.onActivation = {
    autoUpdate = false; # Don't update during rebuild
    cleanup = "zap"; # Uninstall all programs not declared
    upgrade = true;
  };
  homebrew.casks = [
    "1password"
    "discord"
    "google-chrome"
    "mongodb-compass"
    "slack"
    "visual-studio-code"
    "zoom"
  ];
  # installing pnpm and yarn from nixpgks have an issue with hardcoded node versions
  # https://github.com/NixOS/nixpkgs/issues/145634
  homebrew.brews = [
    "pnpm"
    "yarn"
    "libpng"
    "pkg-config"
  ];
}
