{ config, ... }: {
  # Setup ~/.XCompose for windows-like us-intl. Working thanks to ibus.
  home.file = {
    ".XCompose".source = config.lib.file.mkOutOfStoreSymlink (builtins.fetchGit {
      url = "https://github.com/raelgc/win_us_intl";
      ref = "master";
      rev = "1257756d27be78024e360db69da85ef73fbe3617";
    }).outPath + "/.XCompose";
  };
}
