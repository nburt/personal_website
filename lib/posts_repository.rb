class PostsRepository

  def initialize(db)
    @posts_table = db[:posts]
  end

  def create(title, post_body, subtitle)
    if subtitle == ''
      @posts_table.insert(:title => title, :post_body => post_body, :subtitle => nil, :date => Date.today)
    else
      @posts_table.insert(:title => title, :post_body => post_body, :subtitle => subtitle, :date => Date.today)
    end
  end

  def display_all
    @posts_table.all
  end

  def get_post_body(title)
    @posts_table[:title => title][:post_body]
  end

  def get_subtitle(title)
    @posts_table[:title => title][:subtitle]
  end

  def get_date(title)
    @posts_table[:title => title][:date]
  end

end