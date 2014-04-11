class PostsRepository

  def initialize(db)
    @posts_table = db[:posts]
  end

  def create(title, post_body, subtitle, slug)
    if subtitle == ''
      @posts_table.insert(:title => title, :post_body => post_body, :subtitle => nil, :date => Date.today, :slug => slug)
    else
      @posts_table.insert(:title => title, :post_body => post_body, :subtitle => subtitle, :date => Date.today, :slug => slug)
    end
  end

  def display_all
    @posts_table.all
  end

  def get_title(slug)
    @posts_table[:slug => slug][:title]
  end

  def get_post_body(slug)
    @posts_table[:slug => slug][:post_body]
  end

  def get_subtitle(slug)
    @posts_table[:slug => slug][:subtitle]
  end

  def get_date(slug)
    @posts_table[:slug => slug][:date]
  end

end