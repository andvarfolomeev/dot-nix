{
  ...
}:

{

  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "eza"
        "brew"
        "chezmoi"
        "fzf"
        "ssh"
        "gh"
        "git"
        "gitignore"
        "docker"
        "docker-compose"
        "kubectl"
        "nvm"
        "npm"
      ];
    };

    sessionVariables = {
      EDITOR = "hx";
      COLORTERM = "truecolor";
      TERM = "xterm-256color";
    };

    shellAliases = {
      lg = "lazygit";
      ld = "lazydocker";
      g = "git";
      ga = "git add";
      glg = "git log --graph";
      gds = "git diff --staged";
      glo = "git log --pretty=format:'%C(Yellow)%h  %C(reset)%ad (%C(Green)%cr%C(reset))%x09 %C(Cyan)%an: %C(reset)%s'";
      n = "nvim";
      m = "nvim -u ~/.config/nvim/minimal.lua";
      kgn = "kubectl get ns";
      kgp = "kubectl get pods";
      k = "kubectl";
    };

    initContent = ''
      # export $(grep -v '^#' ~/.env | xargs)

      zstyle ':omz:plugins:eza' 'icons' yes

      gupdate() {
        (
          set -e
          git pull origin
          git merge origin/master
          git push --no-verify
        )
      }

      kexec() {
        local ns pod
        ns=$(kubectl get ns -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | fzf) || return
        pod=$(kubectl get pods -n "$ns" -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | fzf) || return
        kubectl exec -n "$ns" -it "$pod" -- /bin/sh
      }
    '';
  };
}
