{ pkgs, ... }: {
  config = {
    extraPackages = [
      pkgs.nixpkgs-fmt
    ];

    plugins.conform-nvim.settings.formatters_by_ft = {
      nix = [ "nixpkgs_fmt" ];
    };

    plugins.lint.lintersByFt = {
      nix = [ "nix" ];
    };

    plugins.lsp.servers.nixd.enable = true;
  };
}
