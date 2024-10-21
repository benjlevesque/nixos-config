{ pkgs, ... }:

{
  programs.git = {
    enable = true;

    userEmail = "14175665+benjlevesque@users.noreply.github.com";
    userName = "Benjamin Levesque";
    signing = {
      key = "0x7B58E6DDBA4ECC8D";
    };
    extraConfig = {
      branch.sort = "-committerdate";
      commit.gpgsign = true;
      core.abrrev = 7;
      "diff \"gpg\"".textconv = "gpg --no-tty --decrypt";
      fetch.prune = true;
      init.defaultBranch = "main";
      log.date = "relative";
      rebase.autoStash = true;
      rerere.enabled = true;
      tag.sort = "-v:refname";
      push = {
        default = "current";
        autoSetupRemote = true;
      };
      pull = {
        ff = "only";
        rebase = true;
      };
    };
  };
  home.packages = with pkgs; [
    gh
  ];
  home.shellAliases = {
    gco = "git checkout";
    gst = "git status";
    grb = "git rebase";
    grbc = "git rebase --continue";
    gp = "git push";
    gcm = "git commit --message";
    glog = "git log --oneline --decorate --graph";
    pr = "git push && ${pkgs.gh}/bin/gh pr create --fill-first";
    ghst = "${pkgs.gh}/bin/gh status";
  };
}
