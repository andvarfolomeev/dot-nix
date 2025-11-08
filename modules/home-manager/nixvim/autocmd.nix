{
  autoCmd = [
    {
      event = "FileType";
      pattern = "markdown";
      command = "setlocal linebreak";
    }
    {
      event = "FileType";
      pattern = "python";
      command = "setlocal shiftwidth=4 tabstop=4 softtabstop=4";
    }
    {
      event = "FileType";
      pattern = [
        "lua"
        "javascript"
        "typescript"
        "json"
        "markdown"
      ];
      command = "setlocal shiftwidth=2 tabstop=2 softtabstop=2";
    }
    {
      event = "BufWritePre";
      pattern = "*";
      command = ''
        if expand('<afile>:p') !~ '^\w\w\+:[\\/][\\/]'
          call mkdir(fnamemodify(expand('<afile>:p'), ':p:h'), 'p')
        endif
      '';
    }
    {
      event = "FileType";
      pattern = "NvimTree";
      callback.__raw = ''
        function()
          vim.opt_local.statusline = ""
        end
      '';
    }
  ];
}
