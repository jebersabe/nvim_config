
return {
    'nvimtools/none-ls.nvim',
    dependencies = {
        "nvimtools/none-ls-extras.nvim",
        "jayp0521/mason-null-ls.nvim",
    },
    config = function()
        local null_ls = require "null-ls"
        local formatting = null_ls.builtins.formatting

        require("mason-null-ls").setup {
            ensure_installed = {
                "stylua",
                "shfmt",
                "ruff",
                "prettier",
            },
            automatic_installation = true,
        }

        local sources = {
            formatting.shfmt.with { args = {"-i", "4"} },
            formatting.prettier.with { filetypes = { "html", "json", "yaml", "markdoown" } },
            formatting.stylua,
            require("none-ls.formatting.ruff").with { extra_args = { "--extend-select","I" } },
            require "none-ls.formatting.ruff_format",
        }

        local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
        null_ls.setup {
            sources = sources,
            on_attach = function(client, bufnr)
                if client.supports_method 'textDocument/Formatting' then
                    vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
                    vim.api.nvim_create_autocmd('BufWritePre', {
                        group = augroup,
                        buffer = bufnr,
                        calback = function()
                            vim.lsp.buf.format { async = false }
                        end
                    })
            end
    end,
    }
    end,
}

