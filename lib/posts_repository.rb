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

  def get_title(id)
    @posts_table[:id => id][:title]
  end

  def get_post_body(id)
    @posts_table[:id => id][:post_body]
  end

  def get_subtitle(id)
    @posts_table[:id => id][:subtitle]
  end

  def get_date(id)
    @posts_table[:id => id][:date]
  end

end