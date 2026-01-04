{ pkgs, ... }:

{
  programs.nixvim = {
    enable = true;

    globals.mapleader = " ";

    colorschemes.catppuccin = {
     enable = true;
     settings.flavour = "mocha"; 
    };

    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      smartindent = true;
      ignorecase = true;
      smartcase = true;
      scrolloff = 8;
      undofile = true;
    };

    plugins = {
      lualine.enable = true;
      
      web-devicons.enable = true;

      which-key = {
        enable = true;
        settings = {
          delay = 200; 
          preset = "modern";
          spec = [
            # --- Твои Leader бинды ---
            { __unkeyed = "<leader>f"; group = "Find (Telescope)"; icon = "🔍"; }
            { __unkeyed = "<leader>c"; group = "Code/LSP"; icon = ""; }
            { __unkeyed = "<leader>e"; group = "Explorer"; icon = "📂"; }
            { __unkeyed = "<leader>t"; group = "Terminal"; icon = ""; }
            { __unkeyed = "<leader>g"; group = "Git"; icon = ""; }
            { __unkeyed = "<leader>u"; group = "UndoTree"; icon = ""; }

            # --- Стандартные Vim префиксы ---
            
            # Группа g (очень полезно, там LSP переходы, комментарии и т.д.)
            { __unkeyed = "g"; group = "Go / Extended"; icon = "🚀"; }
            
            # Группа z (фолдинг/сворачивание кода)
            { __unkeyed = "z"; group = "Folds / View"; icon = "📖"; }
            
            # Квадратные скобки (часто используются для навигации по диагностике)
            { __unkeyed = "["; group = "Prev ..."; icon = "cx"; }
            { __unkeyed = "]"; group = "Next ..."; icon = "cx"; }

            # Регистры (буфер обмена) - нажав ", увидишь список регистров
            { __unkeyed = "\""; group = "Registers"; icon = ""; }
            
            # Метки (закладки в коде)
            { __unkeyed = "'"; group = "Marks"; icon = ""; }
            
            # Окна (Ctrl+w) - полезно, если забываешь как разбить экран
            { __unkeyed = "<C-w>"; group = "Window"; icon = "wm"; }
          ];
        };
      };

      # LSP (Language Server Protocol)
      lsp = {
        enable = true;
        servers = {
          clangd.enable = true;
          nixd.enable = true;
          cmake.enable = true;
          docker_compose_language_service.enable = true;
          dockerls.enable = true; # docker_language_server переименован в dockerls в новых версиях
          html.enable = true;
          # fish_lsp.enable = true; # Часто вызывает проблемы при сборке, раскомментируй если нужно
          bashls.enable = true;
          autotools_ls.enable = true;
          lua_ls.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };
          yamlls.enable = true;
          postgres_lsp.enable = true;
          ruff.enable = true;
          markdown_oxide.enable = true;
        };

        # Самое важное: бинды для LSP
        keymaps.lspBuf = {
          "gd" = "definition";
          "gD" = "declaration";
          "gr" = "references";
          "gi" = "implementation";
          "K" = "hover";
          "<leader>rn" = "rename";
          "<leader>ca" = "code_action";
        };

      };

      # Автодополнение (вместо coq)
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
            { name = "luasnip"; }
          ];
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-e>" = "cmp.mapping.close()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          };
        };
      };
      cmp-nvim-lsp.enable = true;
      cmp-path.enable = true;
      cmp-buffer.enable = true;
      luasnip.enable = true; # Сниппеты

      # Файловый менеджер
      neo-tree = {
        enable = true;
        # Все настройки Lua теперь живут внутри settings
        settings = {
          close_if_last_window = true; # Обрати внимание на snake_case
          window = {
            position = "float";
            width = 30;
            
            # Настройки маппингов (клавиш) ВНУТРИ дерева
            mappings = {
              "<ESC>" = "cancel";
              "q" = "close_window";
            };

            # Настройки всплывающего окна
            popup = {
              size = {
                height = "80%";
                width = "50%";
              };
              position = "50%";
              border = {
                style = "rounded";
                padding = [ 0 1 ];
              };
            };
          };
        };
      };

      # Нечеткий поиск (Telescope)
      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader>fb" = "buffers";
          "<leader>fh" = "help_tags";
        };
      };


      # Сессии
      auto-session = {
        enable = true;
        settings = {
          auto_restore_enabled = false;
          auto_save_enabled = true;
          suppressed_dirs = [ "~/" "~/Downloads" "/tmp" ];
        };
      };

      # Подсветка синтаксиса
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          bash json lua make markdown nix regex toml vim vimdoc xml yaml python c cpp rust
        ];
      };

      vim-matchup = {
        enable = true;
        
        # Интеграция с treesitter (для лучшей точности)
        treesitter.enable = true;
        
        settings = {
          matchup_matchparen_enabled = 1;
          matchup_matchparen_offscreen = {
            method = "popup"; 
            # Можно настроить цвета или убрать, если мешает
            # full_width = 1;
            # highlight = "Normal";
          };
        };
      };

      treesitter-context = {
        enable = true;
        settings = {
          max_lines = 3; # Сколько строк контекста показывать максимум
        };
      };

      # Утилиты
      comments.enable = true;
      lazygit.enable = true;
      
      gitsigns = {
        enable = true;
        settings.current_line_blame = true;
      };
      
      clipboard-image.enable = true;
      
      # Терминал
      toggleterm = {
        enable = true;
        settings = {
          direction = "float";
          float_opts = {
            border = "curved";
            width = 130;
            height = 30;
          };
          open_mapping = "[[<C-\\>]]";
        };
      };

      dashboard.enable = true;

      # Debug Adapter Protocol
      dap = {
        enable = true;
        signs = {
          dapBreakpoint = { text = "●"; texthl = "DapBreakpoint"; };
          dapBreakpointCondition = { text = "●"; texthl = "DapBreakpointCondition"; };
          dapLogPoint = { text = "◆"; texthl = "DapLogPoint"; };
        };
      };
      dap-ui.enable = true;
      dap-python.enable = true;
      # dap-lldb # Внимание: требует настройки путей, часто проще использовать codelldb через mason или вручную

      # Отключенные плагины (как у тебя в конфиге)
      copilot-lua.enable = true;
      copilot-lsp.enable = true;
      copilot-chat.enable = true;
      
      undotree = {
        enable = true;
        settings = {
          FocusOnToggle = true;
        };
      };
    };

    # Общие горячие клавиши
    keymaps = [
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Neotree toggle<CR>";
        options.desc = "Toggle Explorer"; # ЭТО покажет which-key
      }
      {
        mode = ["n" "t"]; # Работает и в нормальном режиме, и в режиме терминала
        key = "<leader>tf";
        action = "<cmd>ToggleTerm direction=float<CR>";
        options.desc = "Toggle Floating Terminal";
      }
      {
        mode = "n";
        key = "<leader>lg";
        action = "<cmd>LazyGit<CR>";
        options.desc = "Open LazyGit";
      }
      {
        mode = "n";
        key = "<leader>u";
        action = "<cmd>UndotreeToggle<CR>";
        options.desc = "Undo Tree";
      }
    ];
  };
}
