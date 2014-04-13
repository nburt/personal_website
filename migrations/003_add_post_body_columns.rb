Sequel.migration do
  change do
    alter_table(:posts) do
      add_column :rendered_text, String
      rename_column :post_body, :original_text
    end
  end
end