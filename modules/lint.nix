{ ... }: {
  config.plugins.lint = {
    enable = true;
    autoCmd.event = [ "BufWritePost" "InsertLeave" ];
  };
}
