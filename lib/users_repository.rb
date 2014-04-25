class UsersRepository

  def initialize(db)
    @users_table = db[:users]
  end

  def create_user
    @users_table.insert(:keen_id => SecureRandom.uuid)
  end

  def get_keen_id(id)
    @users_table[:id => id][:keen_id]
  end

end