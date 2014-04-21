Sequel.migration do
  change do
    alter_table(:posts) do
      rename_column :date, :time
    end
  end
end