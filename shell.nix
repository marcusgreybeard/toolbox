{ pkgs ? import <nixpkgs> {} }:

pkgs.buildEnv {
  name = "marcus-toolbox";
  paths = with pkgs; [
    # Dev tools
    gh            # GitHub CLI
    railway       # Railway CLI
    jq            # JSON processor

    # Web
    caddy         # Web server

    # Secrets
    sops          # Encrypted secrets management
    age           # Modern encryption (SOPS backend)
  ];
}
