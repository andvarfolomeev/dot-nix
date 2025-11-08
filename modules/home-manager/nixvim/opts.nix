{
  opts = {
    compatible = false;

    swapfile = false;
    backup = false;
    writebackup = false;

    undofile = true;
    undolevels = 1000;

    autoread = true;
    confirm = true;

    inccommand = "split";
    splitbelow = true;
    splitright = true;

    ignorecase = true;
    smartcase = true;
    showmatch = true;
    magic = true;

    wrap = false;
    number = true;
    relativenumber = true;
    scrolloff = 3;

    background = "dark";
    statusline = "%f %= %y %l, %c";
    laststatus = 3;

    foldmethod = "marker";
    signcolumn = "yes:2";

    completeopt = [
      "menu"
      "menuone"
      "noselect"
    ];
    sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions";

    langmap =
      "ËЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;~QWERTYUIOP{}ASDFGHJKL:\\\"ZXCVBNM<>,"
      + "ёйцукенгшщзхъфывапролджэячсмить;`qwertyuiop[]asdfghjkl;'zxcvbnm";

    shiftwidth = 2;
    tabstop = 2;
    softtabstop = 2;
  };

  extraConfigVim = ''
    filetype plugin indent on
  '';
}
