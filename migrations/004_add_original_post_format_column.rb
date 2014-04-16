Sequel.migration do
  change do
    alter_table(:posts) do
      add_column :original_post_format, String
    end
  end
end