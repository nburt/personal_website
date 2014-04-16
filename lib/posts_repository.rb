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
    attributes = {
      :title => row[:title],
      :subtitle => row[:subtitle],
      :rendered_text => row[:rendered_text],
      :date => row[:date].strftime('%-m/%-d/%Y')
    }

    Post.new(attributes)
  end

  def get_recent_posts
    recent_posts_array = []
    ordered_posts = @posts_table.order(:date).reverse
    recent_posts_hash = ordered_posts.select(:title, :subtitle, :slug, :date).limit(10).to_a
    recent_posts_hash.each do |post|
      if post[:subtitle].empty?
        hash_to_insert = {:recent_titles => post[:title], :recent_urls => post[:slug], :date => post[:date]}
        recent_posts_array << hash_to_insert
      else
        hash_to_insert = {:recent_titles => "#{post[:title]}: #{post[:subtitle]}", :recent_urls => post[:slug], :date => post[:date]}
        recent_posts_array << hash_to_insert
      end
    end
    recent_posts_array
  end
end