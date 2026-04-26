{ ... }: {
  config.plugins.neogit = {
    enable = true;
    settings = {
      integrations = {
        diffview = true;
        telescope = true;
      };
    };
  };
}
