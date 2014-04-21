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
    erb :resume, :locals => {:logged_in => session[:logged_in]}
  end

  get '/blog' do
    @title = "Nathanael Burt | Blog"
    erb :blog, :locals => {:logged_in => session[:logged_in], :recent_posts => posts_repository.get_recent_posts, :url_host => request.base_url}
  end

  get '/blog/page/:page_number' do
    recent_posts = posts_repository.get_recent_posts(params[:page_number].to_i - 1)
    erb :older_posts, :locals => {:logged_in => session[:logged_in], :next_page => params[:page_number].to_i + 1, :previous_page => params[:page_number].to_i - 1, :recent_posts => recent_posts, :url_host => request.base_url}
  end

  get '/blog/new' do
    if session[:logged_in]
      @title = "Create Blog"
      erb :create_blog, :layout => :admin_layout, :locals => {:logged_in => session[:logged_in]}
    else
      redirect '/'
    end
  end

  post '/blog' do
    validation_result = BlogTitleValidator.new(DB).validate(params[:title], params[:subtitle])
    if validation_result.success?
      post = Post.new({:title => params[:title], :subtitle => params[:subtitle], :original_text => params[:original_text], :original_post_format => params[:post_format], :post_description => params[:post_description]})
      slug = post.create_slug
      rendered_text = post.render_text
      posts_repository.create(post.attributes)
      redirect "/blog/#{slug}"
    else
      session[:message] = validation_result.error_message
      redirect '/blog/new'
    end
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
      post_id = posts_repository.get_id_by_slug(slug)
      comments_repository = CommentsRepository.new(DB, post_id)
      erb :individual_blog_page, locals: {
        :post => post.attributes,
        :logged_in => session[:logged_in],
        :recent_posts => posts_repository.get_recent_posts(0, 5),
        :url_host => request.base_url,
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
    if session[:logged_in]
      @title = "Edit Blog"
      post = posts_repository.get_post_by_slug(params[:full_title])
      erb :edit_blog, :layout => :admin_layout, :locals => {:logged_in => session[:logged_in], :post => post.attributes}
    else
      redirect '/blog/:full_title'
    end
  end

  get '/blog/:full_title/delete' do
    if session[:logged_in]
      posts_repository.delete_by_slug(params[:full_title])
      redirect '/blog'
    else
      redirect '/blog/:full_title'
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

  get '/portfolio' do
    @title = "Nathanael Burt | Portfolio"
    erb :portfolio, :locals => {:logged_in => session[:logged_in]}
  end

end