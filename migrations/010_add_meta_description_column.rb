Sequel.migration do
  change do
    alter_table(:posts) do
      add_column :meta_description, String, :size => 160
    end
  end
end

