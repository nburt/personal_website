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
    session[:logged_in] = false #change to session.clear ?
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
      title = params[:title].gsub(' ', '-').downcase
      subtitle = params[:subtitle].gsub(' ', '-').downcase
      full_title = "#{title}-#{subtitle}"
      if subtitle.empty?
        full_title = "#{title}"
      end
      if params[:blog_format] == "markdown"
        rendered_text = BlogFormatter.new(params[:original_text]).format
        posts_repository.create(params[:title], params[:original_text], params[:subtitle], full_title, rendered_text)
        redirect "/blog/#{full_title}"
      else
        rendered_text = params[:original_text]
        posts_repository.create(params[:title], params[:original_text], params[:subtitle], full_title, rendered_text)
        redirect "/blog/#{full_title}"
      end
    else
      session[:message] = validation_result.error_message
      redirect '/blog/new'
    end
  end

  get '/blog/:full_title' do
    slug = params[:full_title]
    @title = posts_repository.get_title(slug)
    erb :individual_blog_page, locals: {
      :post => {
        :title => @title,
        :subtitle => posts_repository.get_subtitle(slug),
        :rendered_text => posts_repository.get_rendered_text(slug),
        :date => posts_repository.get_date(slug).strftime('%-m/%-d/%Y'),
      },
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

