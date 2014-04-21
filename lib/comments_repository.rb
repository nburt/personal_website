require './lib/comment'

class CommentsRepository

  def initialize(db, post_id)
    @comments_table = db[:comments]
    @post_id = post_id
  end

  def create(attributes)
    @comments_table.insert(attributes.merge(:post_id => @post_id))
  end

  def display_all
    @comments_table.where(:post_id => @post_id).all
  end

end
