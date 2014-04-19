Sequel.migration do
  change do
    alter_table(:posts) do
      add_column :post_description, String, :size => 250
    end
  end
end