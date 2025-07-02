{ pkgs, ... }:
let
  gitShellAliases = {
    gco = "git checkout";
    gcb = "git checkout -b";
    gst = "git status";
    grb = "git rebase";
    grbc = "git rebase --continue";
    gp = "git push";
    gpf = "git push --force-with-lease";
    gcm = "git commit --message";
    glog = "git log --oneline --decorate --graph";
    pr = "${pkgs.gh}/bin/gh pr create --fill-first";
    ghst = "${pkgs.gh}/bin/gh status";
  };
in
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
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = true;
      };
      column.ui = "auto";
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
      init.defaultBranch = "main";
      log.date = "relative";
      rebase.autoStash = true;
      rerere.enabled = true;
      tag.sort = "-v:refname";
      # tag.sort = "version:refname";
      push = {
        default = "current";
        #  default = simple
        autoSetupRemote = true;
        followTags = true;
      };
      pull = {
        ff = "only";
        rebase = true;
      };
    };
    ignores = [
      ".vscode"

      "devenv.nix"
      "devenv.lock"
      "devenv.yaml"
      ".devenv.flake.nix"
      ".devenv/"
      ".direnv/"
      ".envrc"
    ];
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      aliases = {
        co = "pr checkout";
      };
    };

  };

  programs.bash.shellAliases = gitShellAliases;
  programs.nushell.shellAliases = gitShellAliases;

  programs.bash.initExtra = ''
    source ${pkgs.git}/share/bash-completion/completions/git
    _git_checkout_no_tags() {
        __gitcomp_nl "$(__git_heads)"
    }
    __git_complete gco _git_checkout_no_tags
  '';


}
