{
  keymaps = [
    {
      mode = [
        "i"
        "n"
      ];
      key = "<esc>";
      action = "<cmd>noh<cr><esc>";
    }
    {
      mode = [
        "n"
        "x"
      ];
      key = "j";
      action = "v:count == 0 ? 'gj' : 'j'";
      options.expr = true;
    }
    {
      mode = [
        "n"
        "x"
      ];
      key = "k";
      action = "v:count == 0 ? 'gk' : 'k'";
      options.expr = true;
    }
    {
      mode = "n";
      key = "<leader>wo";
      action = "<cmd>only<cr>";
    }
    {
      mode = "n";
      key = "<leader>x";
      action = "<cmd>bd<cr>";
    }
    {
      mode = "v";
      key = "<";
      action = "<gv";
    }
    {
      mode = "v";
      key = ">";
      action = ">gv";
    }
    {
      mode = "n";
      key = "<leader>e";
      action.__raw = "vim.diagnostic.open_float";
    }
    {
      mode = "n";
      key = "K";
      action.__raw = "vim.lsp.buf.hover";
    }
    {
      mode = "n";
      key = "<leader>a";
      action.__raw = "vim.lsp.buf.code_action";
    }
    {
      mode = "n";
      key = "<leader>r";
      action.__raw = "vim.lsp.buf.rename";
    }
  ];
}
