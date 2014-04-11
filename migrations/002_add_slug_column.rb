Sequel.migration do
  change do
    add_column :posts, :slug, String
  end
end