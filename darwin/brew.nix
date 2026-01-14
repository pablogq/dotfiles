{ ... }:
{
  system.activationScripts.preActivation.text = ''
    if ! xcode-select --version 2>/dev/null; then
      $DRY_RUN_CMD sudo -u pablogq xcode-select --install
    fi
    if ! /opt/homebrew/bin/brew --version 2>/dev/null; then
      $DRY_RUN_CMD sudo -u pablogq /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
  '';

  homebrew.enable = true;
  homebrew.onActivation = {
    autoUpdate = false; # Don't update during rebuild
    upgrade = true; # Upgrade outdated casks, formulae, and App Store apps
    cleanup = "zap"; # Uninstall all programs not declared
  };
  homebrew.casks = [
    "1password"
    "citrix-workspace"
    "cloudflare-warp"
    "discord"
    "docker-desktop"
    "ghostty"
    "google-chrome"
    "mattermost"
    "mongodb-compass"
    "raycast"
    "redis-insight"
    "slack"
    "visual-studio-code"
    "zoom"
  ];
  # installing pnpm and yarn from nixpgks have an issue with hardcoded node versions
  # https://github.com/NixOS/nixpkgs/issues/145634
  homebrew.brews = [
    "libpng"
    "pkg-config"
    "pnpm"
    "sst/tap/opencode"
    "uv"
    "yarn"
  ];
}
