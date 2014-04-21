Sequel.migration do
  change do
    alter_table(:comments) do
      add_column :time, Time
      add_column :user_id, Integer
    end
  end
end