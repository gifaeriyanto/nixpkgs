{ ... }:

let
  gifaeriyanto = {
    name = "Gifa Eriyanto";
    email = "gifa.eriyanto@gmail.com";
    signingKey = "78621E1AED00697E";
  };

  gitDefaultConfig = {
    contents = {
      user = gifaeriyanto;
      init = {
        defaultBranch = "main";
      };
    };
  };
in
{
  programs = {
    git = {
      enable = true;
      userName = gifaeriyanto.name;
      userEmail = gifaeriyanto.email;

      signing = {
        key = gifaeriyanto.signingKey;
        signByDefault = true;
        gpgPath = "gpg";
      };

      ignores = [
        "*~"
        ".DS_Store"
        "*.swp"
      ];

      aliases = {
        st = "status";
        co = "checkout";
        cb = "checkout -b";
        rb = "rebase";
        rba = "rebase --abort";
        rbc = "rebase --continue";
        rbi = "rebase -i";
        pf = "push --force-with-lease";
        undo = "reset --soft HEAD~";
      };

      diff-so-fancy.enable = true;

      includes = [
        gitDefaultConfig

        {
          condition = "gitdir:~/.config/nixpkgs/";
          contents.commit.gpgSign = false;
        }
      ];
    };
  };
}
