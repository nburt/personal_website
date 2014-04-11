require 'sinatra'
require './lib/posts_repository'
require './lib/blog_title_validator'

class App < Sinatra::Application

  enable :sessions

  def posts_repository
    @posts_repository ||= PostsRepository.new(DB)
  end

  get '/' do
    @title = "Nathanael Burt | Home"
    erb :index
  end

  get '/resume' do
    @title = "Nathanael Burt | Resume"
    erb :resume
  end

  get '/blog' do
    @title = "Nathanael Burt | Blog"
    erb :blog
  end

  get '/blog/new' do
    @title = "Create Blog"
    erb :create_blog
  end

  post '/blog' do
    validation_result = BlogTitleValidator.new(DB).validate(params[:title], params[:subtitle])
    if validation_result.success?
      id = posts_repository.create(params[:title], params[:post_body], params[:subtitle])
      title = params[:title].gsub(' ', '-').downcase
      subtitle = params[:subtitle].gsub(' ', '-').downcase
      full_title = "#{title}-#{subtitle}"
      redirect "/blog/#{id}/#{full_title}"
    else
      session[:message] = validation_result.error_message
      redirect '/blog/new'
    end
  end

  get '/blog/:id/:full_title' do
    id = params[:id]
    @title = posts_repository.get_title(id)
    erb :individual_blog_page, locals: {:title => @title,
                                        :subtitle => posts_repository.get_subtitle(id),
                                        :post_body => posts_repository.get_post_body(id),
                                        :date => posts_repository.get_date(id).strftime('%-m/%-d/%Y')}
  end


  get '/portfolio' do
    @title = "Nathanael Burt | Portfolio"
    erb :portfolio
  end

end

