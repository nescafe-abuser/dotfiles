if vim.g.neovide then
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_cursor_vfx_mode = "railgun"
  vim.g.neovide_cursor_vfx_opacity = 200.0
  vim.keymap.set('v', '<C-c>', '"+y') 
  vim.keymap.set('n', '<C-v>', '"+P') 
  vim.keymap.set('v', '<C-v>', '"+P') 
  vim.keymap.set('i', '<C-v>', '<ESC>l"+Pli') 
end

vim.api.nvim_set_keymap('', '<C-v>', '+p<CR>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('!', '<C-v>', '<C-R>+', { noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<C-v>', '<C-R>+', { noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '<C-v>', '<C-R>+', { noremap = true, silent = true})


vim.cmd("set expandtab")
vim.cmd("set relativenumber")
vim.cmd("syntax enable")
vim.cmd("let g:vimtex_view_general_viewer = 'zathura'")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
--vim.cmd("set cursorline")
vim.cmd("colorscheme PaperColor")
vim.opt.guicursor = "n-v-i-c:block-Cursor"
vim.g.mapleader = " "
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')
vim.keymap.set('n', '<c-y>', ':TagbarToggle<CR>')
vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')
vim.wo.number = true
vim.keymap.set('n', '<leader>y', '"*y')
vim.keymap.set('n', '<leader>p', '"*p')

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local lsp_zero = require('lsp-zero')
require('lspconfig').rust_analyzer.setup{
  autostart=true;  
}

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

require('mason').setup({})
require('mason-lspconfig').setup({
  -- Replace the language servers listed here 
  -- with the ones you want to install
  ensure_installed = {'clangd'},
  handlers = {
    lsp_zero.default_setup,
  },
})

lsp_zero.format_on_save({
  format_opts = {
    async = false,
    timeout_ms = 10000,
  },
  servers = {
    ['rust_analyzer'] = {'rust'},
    ['clangd'] = {'c'},
  }
})

local cmp = require('cmp')
local cmp_format = require('lsp-zero').cmp_format({details = true})

cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
    {name = 'buffer'},
  },
  formatting = cmp_format,
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm({select = false}),
    ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior, count = 1 }),
    ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior, count = 1 }),
    ['<C-d>'] = cmp.mapping.open_docs(),
    ['<C-D>'] = cmp.mapping.close_docs(),
  })
})

require('ayu').setup({
    overrides = {
        Normal = { bg = "None" },
        ColorColumn = { bg = "None" },
        SignColumn = { bg = "None" },
        Folded = { bg = "None" },
        FoldColumn = { bg = "None" },
        CursorLine = { bg = "None" },
        CursorColumn = { bg = "None" },
        WhichKeyFloat = { bg = "None" },
        VertSplit = { bg = "None" },
    },
})

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
--[[  require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
  }
  ]]--
  use 'NLKNguyen/papercolor-theme'
  use 'fcpg/vim-fahrenheit'
  use 'artanikin/vim-synthwave84'
  use 'Shatur/neovim-ayu'
  use 'preservim/tagbar'
  use 'Raimondi/delimitMate'
  use 'xiyaowong/transparent.nvim'
  use 'lervag/vimtex'
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.6',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  local builtin = require('telescope.builtin')
  vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
  vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
  vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
  vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
  vim.keymap.set('n', '<leader>fm', builtin.man_pages	, {})
  use "akinsho/toggleterm.nvim"
  vim.keymap.set("n", "<leader>cc", ":!gcc % -o %< <CR>",{})
  require("toggleterm").setup{
    open_mapping = [[<c-t>]]
  }
  use { 'AlphaTechnolog/pywal.nvim', as = 'pywal' }
  use {
      'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
      }
  use 'morhetz/gruvbox'
  use {
    'nvim-neo-tree/neo-tree.nvim',
    branch = "v3.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      vim.keymap.set("n", "<C-n>", ":Neotree toggle<CR>", {})
      vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", {})
    end,
  }
  use {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v3.x',
  requires = {
    {'williamboman/mason.nvim'},
    {'williamboman/mason-lspconfig.nvim'},
    {'neovim/nvim-lspconfig'},
    {'hrsh7th/nvim-cmp'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'L3MON4D3/LuaSnip'},
  }
}
  if packer_bootstrap then
    require('packer').sync()
  end
end)
