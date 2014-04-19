require './lib/post'

class PostsRepository

  def initialize(db)
    @posts_table = db[:posts]
  end

  def create(attributes)
    @posts_table.insert(attributes)
  end

  def display_all
    @posts_table.all
  end

  def get_post_by_slug(slug)
    row = @posts_table[:slug => slug]
    if row.nil?
      nil
    else
      attributes = {
        :title => row[:title],
        :subtitle => row[:subtitle],
        :original_text => row[:original_text],
        :rendered_text => row[:rendered_text],
        :slug => slug,
        :date => row[:date].strftime('%-m/%-d/%Y')
      }

      Post.new(attributes)
    end
  end

  def get_recent_posts
    ordered_posts = @posts_table.order(:date).reverse
    recent_posts = ordered_posts.select(:title, :subtitle, :slug, :date, :post_description).limit(10).to_a
    recent_posts.map { |post| Post.new(post).recent_post }
  end

  def update_by_slug(slug, attributes)
    @posts_table.where(:slug => slug).update(attributes)
  end

  def get_date_by_slug(slug)
    @posts_table[:slug => slug][:date].strftime('%-m/%-d/%Y')
  end

  def delete_by_slug(slug)
    @posts_table.where(:slug => slug).delete
  end
end