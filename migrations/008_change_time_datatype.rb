Sequel.migration do
  up do
    alter_table(:posts) do
      set_column_type :time, Time
    end
  end

  down do
    alter_table(:posts) do
      set_column_type :time, Date
    end
  end
end