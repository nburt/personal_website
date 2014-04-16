require 'sinatra'
require './lib/posts_repository'
require './lib/blog_title_validator'
require './lib/post_formatter'

class App < Sinatra::Application

  enable :sessions

  def posts_repository
    @posts_repository ||= PostsRepository.new(DB)
  end

  get '/' do
    @title = "Nathanael Burt | Home"
    erb :index, locals: {:logged_in => session[:logged_in]}
  end

  get '/login' do
    @title = "Login"
    erb :login, locals: {:error_message => nil, :logged_in => session[:logged_in]}
  end

  post '/login' do
    if params[:password] == ENV['PASSWORD']
      session[:logged_in] = true
      redirect '/'
    else
      session[:logged_in] = false
      erb :login, locals: {:error_message => "Incorrect password", :logged_in => session[:logged_in]}
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  get '/resume' do
    @title = "Nathanael Burt | Resume"
    erb :resume, locals: {:logged_in => session[:logged_in]}
  end

  get '/blog' do
    @title = "Nathanael Burt | Blog"
    erb :blog, locals: {:logged_in => session[:logged_in], :recent_posts => posts_repository.get_recent_posts, :url_host => request.base_url}
  end

  get '/blog/new' do
    if session[:logged_in]
      @title = "Create Blog"
      erb :create_blog, locals: {:logged_in => session[:logged_in]}
    else
      redirect '/'
    end
  end

  post '/blog' do
    validation_result = BlogTitleValidator.new(DB).validate(params[:title], params[:subtitle])
    if validation_result.success?
      post = Post.new({:title => params[:title], :subtitle => params[:subtitle], :original_text => params[:original_text], :original_post_format => params[:post_format]})
      slug = post.create_slug
      rendered_text = post.render_text
      posts_repository.create(post.attributes)
      redirect "/blog/#{slug}"
    else
      session[:message] = validation_result.error_message
      redirect '/blog/new'
    end
  end

  get '/blog/:full_title' do
    slug = params[:full_title]
    post = posts_repository.get_post_by_slug(slug)
    erb :individual_blog_page, locals: {
      :post => post.attributes,
      :logged_in => session[:logged_in],
      :recent_posts => posts_repository.get_recent_posts,
      :url_host => request.base_url
    }
  end

  get '/portfolio' do
    @title = "Nathanael Burt | Portfolio"
    erb :portfolio, locals: {:logged_in => session[:logged_in]}
  end

end

