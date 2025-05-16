{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.programs.editors.helix;
  inherit (config.modules.system) username;
  inherit (lib) mkIf getExe;
in {
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lldb # lldb debugger for C, C++, Rust etc.tinymist
      jdt-language-server # java language server
      tinymist # typst lsp
      nil # nix lsp
      bash-language-server # Bash lsp
      shellcheck
      marksman # markdown
      haskell-language-server
      clippy
    ];
    home-manager.users.${username} = {
      programs.helix.languages = {
        language = let
          extraFormatter = lang: {
            command = getExe pkgs.deno;
            args = ["fmt" "-" "--ext" lang];
          };
        in [
          {
            name = "nix";
            auto-format = true;
            formatter.command = "${getExe pkgs.alejandra} -q";
          }
          {
            name = "bash";
            auto-format = true;
            formatter = {
              command = getExe pkgs.shfmt;
              args = ["-i" "2"];
            };
          }
          {
            name = "clojure";
            injection-regex = "(clojure|clj|edn|boot|yuck)";
            file-types = ["clj" "cljs" "cljc" "clje" "cljr" "cljx" "edn" "boot" "yuck"];
          }
          {
            name = "cmake";
            auto-format = true;
            language-servers = ["cmake-language-server"];
            formatter = {
              command = getExe pkgs.cmake-format;
              args = ["-"];
            };
          }
          {
            name = "javascript";
            auto-format = true;
            language-servers = ["dprint" "typescript-language-server"];
          }
          {
            name = "java";
            auto-format = false;
            language-servers = ["jdtls"];
          }
          {
            name = "json";
            formatter = extraFormatter "json";
          }
          {
            name = "markdown";
            auto-format = true;
            formatter = extraFormatter "md";
          }
          {
            name = "python";
            language-servers = ["pyright"];
            formatter = {
              command = getExe pkgs.black;
              args = ["-" "--quiet" "--line-length 100"];
            };
          }
          {
            name = "typescript";
            auto-format = true;
            language-servers = ["dprint" "typescript-language-server"];
          }
          {
            name = "qml";
            auto-format = true;
            language-servers = ["qmlls"];
          }
        ];

        language-server = {
          rust-analyzer.config = {
            check = {
              command = "clippy";
              extraArgs = ["--" "-W" "clippy::pedantic" "-W" "clippy::nursery" "-W" "clippy::perf"];
            };
            cargo.features = "all";
          };

          bash-language-server = {
            command = getExe pkgs.bash-language-server;
            args = ["start"];
          };

          clangd = {
            command = "${pkgs.clang-tools}/bin/clangd";
            clangd.fallbackFlags = ["-std=c++2b"];
          };

          cmake-language-server = {
            command = getExe pkgs.cmake-language-server;
          };

          dprint = {
            command = getExe pkgs.dprint;
            args = ["lsp"];
          };

          nil = {
            command = getExe pkgs.nil;
            config.nil.formatting.command = ["${getExe pkgs.alejandra}" "-q"];
          };

          pyright = {
            command = "${pkgs.pyright}/bin/pyright-langserver";
            args = ["--stdio"];
            config = {
              reportMissingTypeStubs = false;
              analysis = {
                typeCheckingMode = "basic";
                autoImportCompletions = true;
              };
            };
          };

          # typescript-language-server = {
          #   command = getExe pkgs.nodePackages.typescript-language-server;
          #   args = ["--stdio"];
          #   config = let
          #     inlayHints = {
          #       includeInlayEnumMemberValueHints = true;
          #       includeInlayFunctionLikeReturnTypeHints = true;
          #       includeInlayFunctionParameterTypeHints = true;
          #       includeInlayParameterNameHints = "all";
          #       includeInlayParameterNameHintsWhenArgumentMatchesName = true;
          #       includeInlayPropertyDeclarationTypeHints = true;
          #       includeInlayVariableTypeHints = true;
          #     };
          #   in {
          #     typescript-language-server.source = {
          #       addMissingImports.ts = true;
          #       fixAll.ts = true;
          #       organizeImports.ts = true;
          #       removeUnusedImports.ts = true;
          #       sortImports.ts = true;
          #     };
          #
          #     typescript = {inherit inlayHints;};
          #     javascript = {inherit inlayHints;};
          #
          #     hostInfo = "helix";
          #   };
          # };

          # vscode-css-language-server = {
          #   command = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-css-languageserver";
          #   args = ["--stdio"];
          #   config = {
          #     provideFormatter = true;
          #     css.validate.enable = true;
          #     scss.validate.enable = true;
          #   };
          # };
        };
      };
    };
  };
}
