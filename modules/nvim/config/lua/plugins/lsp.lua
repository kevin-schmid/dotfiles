return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",

      -- completion
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",

      -- yaml / kubernetes schemas
      "b0o/schemastore.nvim",
      {
        "someone-stole-my-name/yaml-companion.nvim",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-telescope/telescope.nvim",
        },
      },

      -- formatting
      "stevearc/conform.nvim",
    },
    config = function()
      local servers = {
        "bashls",
        "dockerls",
        "gopls",
        "helm_ls",
        "jsonls",
        "terraformls",
        "yamlls",
        "lua_ls",
      }

      vim.diagnostic.config({
        virtual_text = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })

      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        completion = {
          completeopt = "menu,menuone,noselect",
        },
        performance = {
          debounce = 60,
          throttle = 30,
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-@>"] = cmp.mapping.complete(),
          ["<C-a>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<BS>"] = cmp.mapping(function(fallback)
            fallback()
            vim.schedule(function()
              local col = vim.fn.col(".") - 1
              local before = vim.fn.getline("."):sub(1, col)
              if before:match("[%w_]$") == nil then
                cmp.close()
              end
            end)
          end, { "i" }),
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
        sources = {
          { name = "nvim_lsp", keyword_length = 1 },
          { name = "luasnip", keyword_length = 2 },
          { name = "buffer", keyword_length = 3 },
        },
        experimental = {
          ghost_text = false,
        },
      })

      vim.o.completeopt = "menu,menuone,noselect"
      vim.o.shortmess = vim.o.shortmess .. "c"

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      local function on_attach(client, bufnr)
        -- nvim 0.11 removed client.workspace_did_change_configuration; yaml-companion still calls it
        if client and client.name == "yamlls" and not client.workspace_did_change_configuration then
          client.workspace_did_change_configuration = function(settings)
            client:notify("workspace/didChangeConfiguration", { settings = settings })
          end
        end

        local opts = { silent = true, buffer = bufnr }
        local tb = require("telescope.builtin")

        vim.keymap.set("n", "<C-d>", tb.lsp_definitions, opts)
        vim.keymap.set("n", "<C-r>", tb.lsp_references, opts)
        vim.keymap.set("n", "<C-t>", tb.lsp_type_definitions, opts)
        vim.keymap.set("n", "<C-i>", tb.lsp_implementations, opts)

        vim.keymap.set("n", "<C-k>", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<C-S>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("i", "<C-S>", vim.lsp.buf.signature_help, opts)

        vim.keymap.set("n", "<C-f>", function()
          vim.lsp.buf.format({ async = true })
        end, opts)

        -- standard g/K convention
        vim.keymap.set("n", "gd", tb.lsp_definitions, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
        vim.keymap.set("n", "gr", tb.lsp_references, vim.tbl_extend("force", opts, { desc = "References" }))
        vim.keymap.set("n", "gi", tb.lsp_implementations, vim.tbl_extend("force", opts, { desc = "Implementations" }))
        vim.keymap.set("n", "gy", tb.lsp_type_definitions, vim.tbl_extend("force", opts, { desc = "Type definition" }))
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Declaration" }))
        vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover docs" }))

        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
      end

      require("conform").setup({
        formatters_by_ft = {
          go = { "gofmt" },
          lua = { "stylua" },
        },
      })

      vim.keymap.set("n", "<leader>f", function()
        require("conform").format({ async = true })
      end, { silent = true, desc = "Format buffer" })

      require("mason").setup()

      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_enable = false,
      })

      for _, server in ipairs(servers) do
        if server ~= "yamlls" then
          vim.lsp.config(server, {
            capabilities = capabilities,
            on_attach = on_attach,
          })
          vim.lsp.enable(server)
        end
      end

      -- yamlls: kubernetes core manifests (auto) + CRDs (picker/modeline)
      local crd = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main"
      local crd_schemas = {
        { name = "ArgoCD Application",      uri = crd .. "/argoproj.io/application_v1alpha1.json" },
        { name = "ArgoCD ApplicationSet",   uri = crd .. "/argoproj.io/applicationset_v1alpha1.json" },
        { name = "ArgoCD AppProject",       uri = crd .. "/argoproj.io/appproject_v1alpha1.json" },
        { name = "cert-manager Certificate", uri = crd .. "/cert-manager.io/certificate_v1.json" },
        { name = "cert-manager Issuer",      uri = crd .. "/cert-manager.io/issuer_v1.json" },
        { name = "cert-manager ClusterIssuer", uri = crd .. "/cert-manager.io/clusterissuer_v1.json" },
        { name = "CNPG Cluster",            uri = crd .. "/postgresql.cnpg.io/cluster_v1.json" },
        { name = "CNPG Pooler",             uri = crd .. "/postgresql.cnpg.io/pooler_v1.json" },
        { name = "CNPG ScheduledBackup",    uri = crd .. "/postgresql.cnpg.io/scheduledbackup_v1.json" },
        { name = "OTel Collector",          uri = crd .. "/opentelemetry.io/opentelemetrycollector_v1beta1.json" },
        { name = "OTel Instrumentation",    uri = crd .. "/opentelemetry.io/instrumentation_v1alpha1.json" },
        { name = "Envoy Gateway EnvoyProxy", uri = crd .. "/gateway.envoyproxy.io/envoyproxy_v1alpha1.json" },
        { name = "Prometheus",              uri = crd .. "/monitoring.coreos.com/prometheus_v1.json" },
        { name = "Prometheus ServiceMonitor", uri = crd .. "/monitoring.coreos.com/servicemonitor_v1.json" },
        { name = "Prometheus PodMonitor",   uri = crd .. "/monitoring.coreos.com/podmonitor_v1.json" },
        { name = "Prometheus Rule",         uri = crd .. "/monitoring.coreos.com/prometheusrule_v1.json" },
        { name = "Alertmanager",            uri = crd .. "/monitoring.coreos.com/alertmanager_v1.json" },
        { name = "Istio VirtualService",    uri = crd .. "/networking.istio.io/virtualservice_v1beta1.json" },
        { name = "Istio Gateway",           uri = crd .. "/networking.istio.io/gateway_v1beta1.json" },
        { name = "Istio DestinationRule",   uri = crd .. "/networking.istio.io/destinationrule_v1beta1.json" },
        { name = "Flux Kustomization",      uri = crd .. "/kustomize.toolkit.fluxcd.io/kustomization_v1.json" },
        { name = "Flux HelmRelease",        uri = crd .. "/helm.toolkit.fluxcd.io/helmrelease_v2.json" },
        { name = "Flux GitRepository",      uri = crd .. "/source.toolkit.fluxcd.io/gitrepository_v1.json" },
        { name = "Gateway API Gateway",     uri = crd .. "/gateway.networking.k8s.io/gateway_v1.json" },
        { name = "Gateway API HTTPRoute",   uri = crd .. "/gateway.networking.k8s.io/httproute_v1.json" },
      }

      -- yaml-companion's on_init calls the dot-form client.notify(), which is
      -- deprecated in nvim 0.11. Swap the per-client wrapper for a non-warning one.
      local function silence_notify_deprecation(client)
        local cls = getmetatable(client)
        local meth = cls and cls.notify
        if meth then
          client.notify = function(...)
            local first = select(1, ...)
            if first and getmetatable(first) == cls then
              return meth(...)
            end
            return meth(client, ...)
          end
        end
        return true
      end

      local yaml_cfg = require("yaml-companion").setup({
        -- disabled: its aggregate all.json causes "matches multiple schemas".
        -- We assign a single precise per-kind schema below instead.
        builtin_matchers = {
          kubernetes = { enabled = false },
        },
        schemas = crd_schemas,
        lspconfig = {
          capabilities = capabilities,
          on_init = silence_notify_deprecation,
          on_attach = on_attach,
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
              validate = true,
              completion = true,
              hover = true,
              schemaStore = { enable = false, url = "" },
              schemas = require("schemastore").yaml.schemas(),
            },
          },
        },
      })
      vim.lsp.config("yamlls", yaml_cfg)
      vim.lsp.enable("yamlls")

      -- Auto-pick schema from apiVersion + kind:
      --  * built-in k8s groups -> single precise yannh per-kind schema (no all.json multi-match)
      --  * everything else      -> CRDs-catalog
      local yannh = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master-standalone-strict"
      local builtin_groups = {
        [""] = true,
        ["apps"] = true,
        ["batch"] = true,
        ["autoscaling"] = true,
        ["policy"] = true,
        ["networking.k8s.io"] = true,
        ["rbac.authorization.k8s.io"] = true,
        ["storage.k8s.io"] = true,
        ["apiextensions.k8s.io"] = true,
        ["admissionregistration.k8s.io"] = true,
        ["coordination.k8s.io"] = true,
        ["node.k8s.io"] = true,
        ["scheduling.k8s.io"] = true,
        ["certificates.k8s.io"] = true,
        ["authentication.k8s.io"] = true,
        ["authorization.k8s.io"] = true,
        ["events.k8s.io"] = true,
        ["discovery.k8s.io"] = true,
        ["flowcontrol.apiserver.k8s.io"] = true,
      }

      local function k8s_schema_for_buf(bufnr)
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 100, false)
        local api_version, kind
        for _, l in ipairs(lines) do
          if not api_version then
            api_version = l:match("^apiVersion:%s*[\"']?([%w%.%-/]+)")
          end
          if not kind then
            kind = l:match("^kind:%s*[\"']?([%w%.%-]+)")
          end
          if api_version and kind then
            break
          end
        end
        if not (api_version and kind) then
          return nil
        end
        local group, version = api_version:match("^(.-)/(.+)$")
        if not group then
          group, version = "", api_version
        end
        if group == "" or builtin_groups[group] then
          -- yannh naming: <kind>[-<group-first-segment>]-<version>.json
          local seg = ""
          if group ~= "" then
            seg = "-" .. group:match("^[^.]+")
          end
          return {
            name = kind .. " (kubernetes)",
            uri = string.format("%s/%s%s-%s.json", yannh, kind:lower(), seg, version),
          }
        end
        return {
          name = kind .. " (" .. group .. ")",
          uri = string.format("%s/%s/%s_%s.json", crd, group, kind:lower(), version),
        }
      end

      local function current_schema_uri(bufnr)
        local ok, res = pcall(require("yaml-companion").get_buf_schema, bufnr)
        if ok and res and res.result and res.result[1] then
          return res.result[1].uri
        end
      end

      local function yamlls_attached(bufnr)
        for _, c in ipairs(vim.lsp.get_clients({ bufnr = bufnr, name = "yamlls" })) do
          return c ~= nil
        end
        return false
      end

      local function apply_crd_schema(bufnr)
        if bufnr == nil or bufnr == 0 then
          bufnr = vim.api.nvim_get_current_buf()
        end
        if not vim.api.nvim_buf_is_valid(bufnr) or not yamlls_attached(bufnr) then
          return
        end
        local schema = k8s_schema_for_buf(bufnr)
        if not schema or current_schema_uri(bufnr) == schema.uri then
          return
        end
        pcall(require("yaml-companion").set_buf_schema, bufnr, schema)
      end

      -- Server + schema fetch are async; retry with backoff so it sticks on first open
      local function apply_crd_schema_retry(bufnr)
        apply_crd_schema(bufnr)
        for _, ms in ipairs({ 150, 500, 1200, 2500 }) do
          vim.defer_fn(function()
            apply_crd_schema(bufnr)
          end, ms)
        end
      end

      local crd_group = vim.api.nvim_create_augroup("K8sCRDSchema", { clear = true })
      vim.api.nvim_create_autocmd("LspAttach", {
        group = crd_group,
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "yamlls" then
            apply_crd_schema_retry(args.buf)
          end
        end,
      })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
        group = crd_group,
        pattern = { "*.yaml", "*.yml" },
        callback = function(args)
          apply_crd_schema(args.buf)
        end,
      })
      vim.keymap.set("n", "<leader>yd", function()
        apply_crd_schema_retry(0)
      end, { silent = true, desc = "Detect K8s schema (apiVersion/kind)" })

      for _, b in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(b) then
          apply_crd_schema_retry(b)
        end
      end

      pcall(function()
        require("telescope").load_extension("yaml_schema")
      end)
      vim.keymap.set("n", "<leader>ys", function()
        require("telescope").extensions.yaml_schema.yaml_schema()
      end, { silent = true, desc = "Select YAML/K8s schema" })
    end,
  },
}
