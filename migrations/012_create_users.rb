Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      String :keen_id, :null=>false
    end
  end
end