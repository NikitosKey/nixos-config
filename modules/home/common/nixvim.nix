{ pkgs, config, inputs, ... }:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  programs.nixvim = {
    enable = true;

    globals.mapleader = " ";

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

      avante = {
        enable = false;
        settings = {
          provider = "gemini-cli";
          auto_suggestions_provider = "gemini-cli";
          acp_providers = {
            "gemini-cli" = {
              command = "gemini";
              args = [ "--experimental-acp" ];
              env = {
                NODE_NO_WARNINGS = "1";
                GEMINI_API_KEY = config.sops.secrets."llm/gemini_api_key".path;
              };
            };
          };
        };
      };
      
      web-devicons.enable = true;

      which-key = {
        enable = true;
        settings = {
          delay = 200; 
          preset = "modern";
          spec = [
            { __unkeyed = "<leader>f"; group = "Find (Telescope)"; icon = "🔍"; }
            { __unkeyed = "<leader>c"; group = "Code/LSP"; icon = ""; }
            { __unkeyed = "<leader>e"; group = "Explorer"; icon = "📂"; }
            { __unkeyed = "<leader>t"; group = "Terminal"; icon = ""; }
            { __unkeyed = "<leader>g"; group = "Git"; icon = ""; }
            { __unkeyed = "<leader>u"; group = "UndoTree"; icon = ""; }

            
            { __unkeyed = "g"; group = "Go / Extended"; icon = "🚀"; }
            
            { __unkeyed = "z"; group = "Folds / View"; icon = "📖"; }
            
            { __unkeyed = "["; group = "Prev ..."; icon = "cx"; }
            { __unkeyed = "]"; group = "Next ..."; icon = "cx"; }

            { __unkeyed = "\""; group = "Registers"; icon = ""; }
            
            { __unkeyed = "'"; group = "Marks"; icon = ""; }
            
            { __unkeyed = "<C-w>"; group = "Window"; icon = "wm"; }
          ];
        };
      };

      lsp = {
        enable = true;
        servers = {
          clangd.enable = true;
          nixd.enable = true;
          cmake.enable = true;
          docker_compose_language_service.enable = true;
          dockerls.enable = true;
          html.enable = true;
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
      luasnip.enable = true;

      neo-tree = {
        enable = true;
        settings = {
          close_if_last_window = true;
          window = {
            position = "float";
            width = 30;
            
            mappings = {
              "<ESC>" = "cancel";
              "q" = "close_window";
            };

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

      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader>fb" = "buffers";
          "<leader>fh" = "help_tags";
        };
      };


      auto-session = {
        enable = true;
        settings = {
          auto_restore_enabled = false;
          auto_save_enabled = true;
          suppressed_dirs = [ "~/" "~/Downloads" "/tmp" ];
        };
      };

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
        
        treesitter.enable = true;
        
        settings = {
          matchup_matchparen_enabled = 1;
          matchup_matchparen_offscreen = {
            method = "popup"; 
          };
        };
      };

      treesitter-context = {
        enable = true;
        settings = {
          max_lines = 3; 
        };
      };

      lazygit.enable = true;
      
      gitsigns = {
        enable = true;
        settings.current_line_blame = true;
      };
      
      clipboard-image.enable = true;
      
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

      copilot-lua.enable = true;
      copilot-lsp.enable = true;
      copilot-chat.enable = true;
      
      undotree = {
        enable = true;
        settings = {
          FocusOnToggle = true;
        };
      };

      markdown-preview.enable = true;
    }; 

    keymaps = [
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Neotree toggle<CR>";
        options.desc = "Toggle Explorer"; 
      }
      {
        mode = ["n" "t"]; 
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
