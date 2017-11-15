defmodule PrefixHelper do
  import Mix.Ecto, only: [source_repo_priv: 1]
  alias Ecto.Migrator
  alias Ecto.Adapters.SQL

  def create_schema(repo) do
    {:ok, _} = SQL.query(repo, "CREATE SCHEMA \"custom_prefix\"", [])
  end

  def migrate(repo) do
    Code.compiler_options(ignore_module_conflict: true)
    try do
      migrated_versions = Migrator.run(
        repo,
        Path.join(source_repo_priv(repo), "migrations"),
        :up,
        all: true,
        prefix: "custom_prefix"
      )

      {:ok, migrated_versions}
    after
      Code.compiler_options(ignore_module_conflict: false)
    end
  end
end
