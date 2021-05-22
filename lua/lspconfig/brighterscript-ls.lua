local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = "brighterscript-ls"

configs[server_name] = {
  default_config = {
    cmd = {"brighterscript-ls", "--stdio"};
    filetypes = {"brs", "br", "xml"};
    root_dir = function (pattern)
      local cwd  = vim.loop.cwd();
      local root = util.root_pattern("package.json", ".git")(pattern);

      -- prefer cwd if root is a descendant
      return util.path.is_descendant(cwd, root) and cwd or root;
    end;
    handlers = {
      ['workspace/workspaceFolders'] = function(a, b, params, client_id)
        local client = vim.lsp.get_client_by_id(client_id);

        local workspaceFolders = {{
          uri = vim.uri_from_fname(client.config.root_dir);
          name = string.format("%s", client.config.root_dir);
        }};

        return workspaceFolders;
      end;
    };
  };
  docs = {
    description = [[
    brighterscript-ls
]];
    default_config = {
      cmd = {"brighterscript-ls", "--stdio"};
      root_dir = [[root_pattern("package.json", ".git")]];
    };
  };
}

-- vim:et ts=2 sw=2
