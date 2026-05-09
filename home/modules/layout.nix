{ config, ... }: {
  # Setup ~/.XCompose for windows-like us-intl. Working thanks to ibus.
  home.file = {
    ".XCompose".source = config.lib.file.mkOutOfStoreSymlink (builtins.fetchGit {
      url = "https://github.com/raelgc/win_us_intl";
      ref = "master";
      rev = "aa3b4cbb19f0877b62ad0b25aed1d6bd49ff6e8c";
    }).outPath + "/.XCompose";
  };
}
