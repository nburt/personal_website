Sequel.migration do
  change do
    create_table(:comments) do
      primary_key :id
      String :name, :null=>false
      String :comment, :null=>false
      Integer :post_id, :null=>false
    end
  end
end