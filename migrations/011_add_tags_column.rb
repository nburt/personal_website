Sequel.migration do
  change do
    alter_table(:posts) do
      add_column :tags, String
    end
  end
end