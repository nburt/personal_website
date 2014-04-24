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

  def update_by_id(id, attributes)
    @comments_table.where(:id => id).update(attributes)
  end

  def delete(id)
    @comments_table.where(:id => id).delete
  end

  def get_comment_by_id(id)
    comment = @comments_table[:id => id]
    if comment.nil?
      nil
    else
      attributes = {
        :id => comment[:id],
        :name => comment[:name],
        :comment => comment[:comment]
      }
    Comment.new(attributes)
    end
  end
end
