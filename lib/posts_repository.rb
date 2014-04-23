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

  def count
    @posts_table.count
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
        :post_description => row[:post_description],
        :slug => slug,
        :time => row[:time].strftime('%-m/%-d/%Y'),
        :meta_description => row[:meta_description],
        :tags => row[:tags]
      }

      Post.new(attributes)
    end
  end

  def get_posts_by_tag(tag)
    rows = @posts_table.where(:tags => /#{tag}/i)
    rows_array = []
    if rows.nil?
      nil
    else
      rows.each do |row|
        attributes = {
          :title => row[:title],
          :subtitle => row[:subtitle],
          :rendered_text => row[:rendered_text],
          :post_description => row[:post_description],
          :slug => row[:slug],
          :time => row[:time].strftime('%-m/%-d/%Y'),
          :meta_description => row[:meta_description],
          :tags => row[:tags]
        }

        rows_array << Post.new(attributes).attributes
      end
      rows_array
    end
  end

  def get_id_by_slug(slug)
    @posts_table[:slug => slug][:id]
  end

  def get_recent_posts(page_number = 0, per_page = 10)
    ordered_posts = @posts_table.order(:time).reverse
    recent_posts = ordered_posts.select(:title, :subtitle, :slug, :time, :post_description).offset(page_number * per_page).limit(per_page).to_a
    recent_posts.map { |post| Post.new(post).recent_post }
  end

  def update_by_slug(slug, attributes)
    @posts_table.where(:slug => slug).update(attributes)
  end

  def get_time_by_slug(slug)
    @posts_table[:slug => slug][:time].strftime('%-m/%-d/%Y')
  end

  def delete_by_slug(slug)
    @posts_table.where(:slug => slug).delete
  end
end