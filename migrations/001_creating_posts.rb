Sequel.migration do
  change do
    create_table(:posts) do
      primary_key :id
      String :title, :null=>false
      String :subtitle
      String :post_body, :null=>false
      Date :date, :null=>false
    end
  end
end