class PostsRepository

  def initialize(db)
    @posts_table = db[:posts]
  end

  def create(title, original_text, subtitle, slug, rendered_text)
    if subtitle == ''
      @posts_table.insert(:title => title, :original_text => original_text, :subtitle => nil, :date => Date.today, :slug => slug, :rendered_text => rendered_text)
    else
      @posts_table.insert(:title => title, :original_text => original_text, :subtitle => subtitle, :date => Date.today, :slug => slug, :rendered_text => rendered_text)
    end
  end

  def display_all
    @posts_table.all
  end

  def get_title(slug)
    @posts_table[:slug => slug][:title]
  end

  def get_original_text(slug)
    @posts_table[:slug => slug][:original_text]
  end

  def get_subtitle(slug)
    @posts_table[:slug => slug][:subtitle]
  end

  def get_date(slug)
    @posts_table[:slug => slug][:date]
  end

  def get_rendered_text(slug)
    @posts_table[:slug => slug][:rendered_text]
  end

  def get_recent_posts
    recent_posts_array = []
    ordered_posts = @posts_table.order(:date).reverse
    recent_posts_hash = ordered_posts.select(:title, :subtitle, :slug, :date).limit(10).to_a
    recent_posts_hash.each do |post|
      if post[:subtitle].nil?
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