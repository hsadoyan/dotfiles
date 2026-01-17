-- ==========================================================================
-- NEOVIM CONFIGURATION - Native LSP + nvim-cmp + lazy.nvim
-- ==========================================================================

vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- ==========================================================================
-- CORE SETTINGS
-- ==========================================================================

local opt = vim.opt

opt.background = "dark"
opt.termguicolors = true
opt.textwidth = 120
opt.linebreak = true

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- Line numbers (hybrid relative/absolute)
opt.number = true
opt.relativenumber = true

-- Search
opt.incsearch = true
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true

-- UI
opt.showcmd = true
opt.showmatch = true
opt.wildmenu = true
opt.wildmode = "longest:full,full"
opt.wildignore:append({ "*/node_modules/*", "*/vendor/*", "*/.git/*", "*.o", "*.pyc", "*/deps/*"})
opt.laststatus = 2
opt.signcolumn = "yes"
opt.scrolloff = 5
opt.sidescrolloff = 5
opt.ruler = true
opt.confirm = true
opt.mouse = "a"
opt.updatetime = 250
opt.timeoutlen = 400
opt.completeopt = "menu,menuone,noselect"

-- Behavior
opt.hidden = true
opt.backspace = "indent,eol,start"
opt.startofline = false
opt.splitright = true
opt.splitbelow = true

-- Disable bells
opt.belloff = "all"

-- Persistent undo
opt.undofile = true

-- No swap/backup
opt.backup = false
opt.writebackup = false
opt.swapfile = false

-- Better diff
opt.diffopt:append({ "vertical", "algorithm:patience" })

-- Use ripgrep if available
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --smart-case"
  opt.grepformat = "%f:%l:%c:%m"
end

-- ==========================================================================
-- BOOTSTRAP LAZY.NVIM
-- ==========================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ==========================================================================
-- PLUGINS
-- ==========================================================================

require("lazy").setup({
  -- Colorscheme

  {
    "olimorris/onedarkpro.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme onedark")
    end,
  },

  -- FZF
  {
    "junegunn/fzf",
    build = function() vim.fn["fzf#install"]() end,
  },
  { "junegunn/fzf.vim" },

  -- Navigation
  { "christoomey/vim-tmux-navigator" },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 35 },
      })
    end,
  },

  -- Editing
  { "tpope/vim-unimpaired" },
  { "tpope/vim-surround" },
  { "tpope/vim-repeat" },

  {
    "numToStr/Comment.nvim",
    config = function() require("Comment").setup() end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function() require("nvim-autopairs").setup() end,
  },

  -- Git
  { "tpope/vim-fugitive" },
  { "tpope/vim-rhubarb" },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
      })
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
      })
    end,
  },

  -- Treesitter (parser installation only - Neovim 0.11 handles highlighting natively)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- Ensure parsers are installed
      local ensure_installed = {
        "lua", "vim", "vimdoc",
        "elixir", "heex", "eex",
        "python",
        "go", "gomod", "gosum",
        "javascript", "typescript",
        "json", "yaml", "html", "css",
      }
      
      -- Auto-install missing parsers
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local ft = args.match
          local lang = vim.treesitter.language.get_lang(ft) or ft
          local ok = pcall(vim.treesitter.language.inspect, lang)
          if not ok then
            -- Parser not installed, try to install it
            vim.cmd("TSInstall " .. lang)
          end
        end,
      })
    end,
  },

  -- LSP configs (nvim-lspconfig provides default configs in lsp/ directory)
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      -- nvim-lspconfig just provides the default configs
      -- We use vim.lsp.config() and vim.lsp.enable() (Neovim 0.11+)
    end,
  },

  -- Elixir (handles ElixirLS automatically)
  {
    "elixir-tools/elixir-tools.nvim",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("elixir").setup({
        nextls = { enable = false },
        elixirls = {
          enable = true,
          settings = require("elixir.elixirls").settings({
            dialyzerEnabled = true,
            enableTestLenses = false,
            fetchDeps = false,
          }),
        },
        projectionist = { enable = true },
      })
    end,
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
      })

      -- Cmdline completion
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
      })

      -- Integrate autopairs
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
  {
    "coder/claudecode.nvim",
    config = function()
      require("claudecode").setup({
        -- Uses snacks.nvim terminal by default, or native terminal
      })
    end,
    keys = {
      { "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
    },
  },
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
  },
  -- Utilities
  { "tpope/vim-eunuch" },

}, {
  -- lazy.nvim options
  checker = { enabled = false },
  change_detection = { notify = false },
})

-- ==========================================================================
-- TREESITTER HIGHLIGHTING (Neovim 0.11+ native)
-- ==========================================================================

-- Automatically enable treesitter highlighting for supported filetypes
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local bufnr = args.buf
    local lang = vim.treesitter.language.get_lang(args.match) or args.match
    local ok = pcall(vim.treesitter.language.inspect, lang)
    if ok then
      vim.treesitter.start(bufnr, lang)
    end
  end,
})

-- ==========================================================================
-- LSP CONFIGURATION (Neovim 0.11+ native API)
-- ==========================================================================

-- Diagnostic display settings
vim.diagnostic.config({
  virtual_text = { prefix = "●" },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded" },
})

-- Diagnostic signs
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- LSP keymaps on attach
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local opts = { noremap = true, silent = true, buffer = bufnr }

    -- Navigation (some are defaults in 0.11, but explicit is nice)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)

    -- 0.11 defaults: grr=references, gri=implementation, grn=rename, gra=code_action
    -- Adding our preferred mappings too
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>qf", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "<leader>fm", function() vim.lsp.buf.format({ async = true }) end, opts)
  end,
})

-- Format Elixir on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.ex", "*.exs", "*.heex" },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Add nvim-cmp capabilities to all LSP servers
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  callback = function()
    local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if ok then
      local capabilities = cmp_nvim_lsp.default_capabilities()
      vim.lsp.config("*", { capabilities = capabilities })
    end
  end,
})

-- Go (gopls)
vim.lsp.config("gopls", {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.mod", "go.work", ".git" },
  settings = {
    gopls = {
      analyses = { unusedparams = true, shadow = true },
      staticcheck = true,
      gofumpt = true,
    },
  },
})

-- Python (pyright)
vim.lsp.config("pyright", {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git" },
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
})

-- Lua (lua_ls - for Neovim config editing)
vim.lsp.config("lua_ls", {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", ".git" },
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})

-- Enable all configured LSP servers
vim.lsp.enable({ "gopls", "pyright", "lua_ls" })

-- ==========================================================================
-- AUTOCOMMANDS
-- ==========================================================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Toggle relative numbers
augroup("numbertoggle", { clear = true })
autocmd({ "InsertEnter", "FocusLost" }, {
  group = "numbertoggle",
  callback = function() vim.opt_local.relativenumber = false end,
})
autocmd({ "InsertLeave", "FocusGained" }, {
  group = "numbertoggle",
  callback = function() vim.opt_local.relativenumber = true end,
})

-- Quickfix auto-open
augroup("quickfix", { clear = true })
autocmd("QuickFixCmdPost", {
  group = "quickfix",
  pattern = "[^l]*",
  command = "cwindow",
})

-- Filetype settings
augroup("filetypes", { clear = true })
autocmd("FileType", {
  group = "filetypes",
  pattern = "python",
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
  end,
})
autocmd("FileType", {
  group = "filetypes",
  pattern = "go",
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- ==========================================================================
-- KEYMAPS
-- ==========================================================================

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Basics
keymap("n", "Y", "y$", opts)
keymap("n", "<leader>l", ":nohlsearch<CR>", opts)
keymap("n", "<leader>b", ":ls<CR>:b<space>", { noremap = true })

-- Semicolon/comma toggle
keymap("n", ";;", [[:s/\v(.)$/\=submatch(1)==';' ? '' : submatch(1).';'<CR>:noh<CR>]], opts)
keymap("n", ",,", [[:s/\v(.)$/\=submatch(1)==',' ? '' : submatch(1).','<CR>:noh<CR>]], opts)

-- Quote toggling
keymap("n", "<leader>'", [[:s/"/'/g<CR>:noh<CR>]], opts)
keymap("n", '<leader>"', [[:s/'/"/g<CR>:noh<CR>]], opts)

-- FZF
keymap("n", "<leader>f", ":Files<CR>", opts)
keymap("n", "<leader>F", ":GFiles?<CR>", opts)
keymap("n", "<leader>g", ":Rg<CR>", opts)
keymap("n", "<leader>G", ":grep!<space>", { noremap = true })
keymap("n", "<leader>h", ":History:<CR>", opts)
keymap("n", "<leader>/", ":BLines<CR>", opts)
keymap("n", "<leader>t", ":Tags<CR>", opts)
keymap("n", "<leader>T", ":BTags<CR>", opts)

-- nvim-tree
keymap("n", "<C-n>", ":NvimTreeToggle<CR>", opts)

-- Git
keymap("n", "<leader>dt", ":diffget //2<CR>", opts)
keymap("n", "<leader>dm", ":diffget //3<CR>", opts)
keymap("n", "<leader>du", ":diffupdate<CR>", opts)

-- Gitsigns
keymap("n", "]c", ":Gitsigns next_hunk<CR>", opts)
keymap("n", "[c", ":Gitsigns prev_hunk<CR>", opts)
keymap("n", "<leader>hs", ":Gitsigns stage_hunk<CR>", opts)
keymap("n", "<leader>hr", ":Gitsigns reset_hunk<CR>", opts)
keymap("n", "<leader>hp", ":Gitsigns preview_hunk<CR>", opts)

-- ==========================================================================
-- FZF COMMANDS
-- ==========================================================================

-- Use fd for file finding (faster than default find)
vim.env.FZF_DEFAULT_COMMAND = 'fd --type f --hidden --follow --exclude .git'

vim.cmd([[
  command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>),
    \   fzf#vim#with_preview(), <bang>0)
]])

-- ==========================================================================
-- INSTALL NOTES
-- ==========================================================================
-- Language servers to install:
--   Go:     go install golang.org/x/tools/gopls@latest
--   Python: pip install pyright
--   Lua:    brew install lua-language-server
--   Elixir: Automatic via elixir-tools.nvim!
--
-- Just open Neovim - lazy.nvim installs everything automatically.
