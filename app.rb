require 'sinatra'
require './lib/posts_repository'
require './lib/blog_title_validator'
require './lib/post_formatter'
require './lib/comments_repository'

class App < Sinatra::Application

  enable :sessions

  def posts_repository
    @posts_repository ||= PostsRepository.new(DB)
  end

  get '/' do
    @title = "Nathanael Burt | Home"
    @meta_description = "Nathanael Burt is a web developer/software engineer specializing in test-driven development with Ruby on Rails."
    erb :index, :locals => {:logged_in => session[:logged_in]}
  end

  get '/login' do
    @title = "Login"
    erb :login, :locals => {:error_message => nil, :logged_in => session[:logged_in]}
  end

  post '/login' do
    if params[:password] == ENV['PASSWORD']
      session[:logged_in] = true
      redirect '/'
    else
      session[:logged_in] = false
      erb :login, :locals => {:error_message => "Incorrect password", :logged_in => session[:logged_in]}
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  get '/resume' do
    @title = "Nathanael Burt | Resume"
    @meta_description = "Check out Nathanael Burt's resume and learn why you should hire him for your next software project."
    erb :resume, :locals => {:logged_in => session[:logged_in]}
  end


  get '/blog' do
    posts_count = posts_repository.count
    if posts_count > 10
      older_posts = true
    else
      older_posts = false
    end
    @title = "Nathanael Burt | Blog"
    @meta_description = "Gain insight into the tech industry and learn with technical how-to blogs by Nathanael Burt."
    erb :blog, :locals => {:logged_in => session[:logged_in], :recent_posts => posts_repository.get_recent_posts, :older_posts => older_posts}
  end

  get '/blog/page/:page_number' do
    page_number = params[:page_number].to_i
    posts_count = posts_repository.count
    if posts_count > 10 * (page_number)
      older_posts = true
    else
      older_posts = false
    end
    @title = "Nathanael Burt | Blog Page #{page_number}"
    @meta_description = "Page #{params[:page_number]} of the list of Nathanael Burt's blogs."
    recent_posts = posts_repository.get_recent_posts(page_number - 1)
    erb :older_posts, :locals => {:logged_in => session[:logged_in], :next_page => page_number + 1, :previous_page => page_number - 1, :recent_posts => recent_posts, :older_posts => older_posts}
  end

  get '/blog/new' do
    logged_in = session[:logged_in]
    if logged_in
      @title = "Create Blog"
      erb :create_blog, :layout => :admin_layout, :locals => {:logged_in => logged_in}
    else
      redirect not_found
    end
  end

  post '/blog' do
    validation_result = BlogTitleValidator.new(DB).validate(params[:title], params[:subtitle])
    if validation_result.success?
      post = Post.new({:title => params[:title], :subtitle => params[:subtitle], :original_text => params[:original_text], :original_post_format => params[:post_format], :post_description => params[:post_description], :meta_description => params[:meta_description], :tags => params[:tags]})
      slug = post.create_slug
      rendered_text = post.render_text
      posts_repository.create(post.attributes)
      redirect "/blog/#{slug}"
    else
      session[:message] = validation_result.error_message
      redirect '/blog/new'
    end
  end

  get '/tags/:tag' do
    tag = params[:tag]
    posts = posts_repository.get_posts_by_tag(tag)
    erb :tags, :locals => {:logged_in => session[:logged_in], :posts => posts}
  end

  not_found do
    erb :not_found, :locals => {:logged_in => session[:logged_in]}
  end

  get '/blog/:full_title' do
    slug = params[:full_title]
    post = posts_repository.get_post_by_slug(slug)
    if post.nil?
      redirect not_found
    else
      @title = post.attributes[:title]
      @meta_description = post.attributes[:meta_description]
      post_id = posts_repository.get_id_by_slug(slug)
      comments_repository = CommentsRepository.new(DB, post_id)
      erb :individual_blog_page, locals: {
        :post => post.attributes,
        :logged_in => session[:logged_in],
        :recent_posts => posts_repository.get_recent_posts(0, 5),
        :slug => slug,
        :comments => comments_repository.display_all
      }
    end
  end

  post '/blog/:full_title' do
    post_id = posts_repository.get_id_by_slug(params[:full_title])
    comment = Comment.new({:name => params[:name], :comment => params[:comment]})
    comments_repository = CommentsRepository.new(DB, post_id)
    comments_repository.create(comment.attributes)
    redirect "/blog/#{params[:full_title]}"
  end

  get '/blog/:full_title/edit' do
    logged_in = session[:logged_in]
    if logged_in
      @title = "Edit Blog"
      post = posts_repository.get_post_by_slug(params[:full_title])
      erb :edit_blog, :layout => :admin_layout, :locals => {:logged_in => logged_in, :post => post.attributes}
    else
      redirect not_found
    end
  end

  get '/blog/:full_title/delete' do
    logged_in = session[:logged_in]
    if logged_in
      posts_repository.delete_by_slug(params[:full_title])
      redirect '/blog'
    else
      redirect not_found
    end
  end

  put '/blog' do
    original_slug = params[:slug]
    post = Post.new(:title => params[:title], :subtitle => params[:subtitle], :original_text => params[:original_text], :original_post_format => params[:post_format])
    slug = post.create_slug
    rendered_text = post.render_text
    posts_repository.update_by_slug(original_slug, post.attributes)
    redirect "blog/#{slug}"
  end

  get '/blog/:full_title/comment/:id' do
    slug = params[:full_title]
    logged_in = session[:logged_in]
    comment_id = params[:id]
    if logged_in
      post_id = posts_repository.get_id_by_slug(params[:full_title])
      comments_repository = CommentsRepository.new(DB, post_id)
      comment = comments_repository.get_comment_by_id(comment_id).attributes
      erb :show_comment, :layout => :admin_layout, :locals => {:logged_in => logged_in, :comment => comment, :slug => slug}
    else
      redirect not_found
    end
  end

  get '/blog/:full_title/comment/:id/edit' do
    slug = params[:full_title]
    logged_in = session[:logged_in]
    if logged_in
      post_id = posts_repository.get_id_by_slug(params[:full_title])
      comments_repository = CommentsRepository.new(DB, post_id)
      comment = comments_repository.get_comment_by_id(params[:id]).attributes
      erb :edit_comment, :layout => :admin_layout, :locals => {:logged_in => logged_in, :comment => comment, :slug => slug}
    else
      redirect not_found
    end
  end

  put '/blog/:full_title/comment/:id' do
    slug = params[:full_title]
    post_id = posts_repository.get_id_by_slug(params[:full_title])
    comments_repository = CommentsRepository.new(DB, post_id)
    comments_repository.update_by_id(params[:id], {:name => params[:name], :comment => params[:comment]})
    redirect "blog/#{slug}"
  end

  get '/portfolio' do
    @title = "Nathanael Burt | Portfolio"
    @meta_description = "Visit Nathanael Burt's portofolio to see the amazing web applications that he has built."
    erb :portfolio, :locals => {:logged_in => session[:logged_in]}
  end

end