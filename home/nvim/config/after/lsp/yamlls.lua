local schema_companion = require("schema-companion")

return schema_companion.setup_client(
  schema_companion.adapters.yamlls.setup({
    sources = {
      schema_companion.sources.matchers.kubernetes.setup({ version = "master" }),
      schema_companion.sources.lsp.setup(),
      schema_companion.sources.none.setup(),
    },
  }),
  {
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
  }
)
