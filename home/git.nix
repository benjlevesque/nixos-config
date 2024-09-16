{ pkgs, ... }:

{
  programs.git = {
    enable = true;
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
