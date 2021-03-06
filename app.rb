require 'sinatra'
require 'sinatra/cookies'
require 'keen'
require './lib/posts_repository'
require './lib/blog_title_validator'
require './lib/post_formatter'
require './lib/comments_repository'
require './lib/users_repository'
require './lib/email'
require './lib/keen_publisher'
require 'mail'


class App < Sinatra::Application

  helpers Sinatra::Cookies

  enable :sessions
  set :session_secret, ENV['SESSION_SECRET']

  def posts_repository
    @posts_repository ||= PostsRepository.new(DB)
  end

  def users_repository
    @users_repository ||= UsersRepository.new(DB)
  end

  # before do
  #   if cookies["user_id"] == nil
  #     response.set_cookie "user_id", {:value => users_repository.create_user, :expires => Time.now + (60 * 60 * 24 * 30 * 12 * 30), :path => "/"}
  #   end
  # end

  get '/' do
    @title = "Nathanael Burt | Home"
    @meta_description = "Nathanael Burt is a web developer/software engineer specializing in test-driven development with Ruby on Rails."
    if ENV['ANALYTICS'] != "false" && request.cookies["user_id"] != nil
      keen_id = users_repository.get_keen_id(request.cookies["user_id"])
      KeenPublisher.new(:home, :user => keen_id).publish
    end
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
    if ENV['ANALYTICS'] != "false"
      keen_id = users_repository.get_keen_id(request.cookies["user_id"])
      KeenPublisher.new(:resume, :user => keen_id).publish
    end
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
    @meta_description = "Page #{page_number} of the list of Nathanael Burt's blogs."
    recent_posts = posts_repository.get_recent_posts(page_number - 1)
    if ENV['ANALYTICS'] != "false"
      keen_id = users_repository.get_keen_id(request.cookies["user_id"])
      KeenPublisher.new(:blog_list, :user => keen_id, :page => "/blog/page/#{page_number}", :recent_posts => recent_posts).publish
    end
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
    if ENV['ANALYTICS'] != "false"
      keen_id = users_repository.get_keen_id(request.cookies["user_id"])
      KeenPublisher.new(:tags_list, :user => keen_id, :tag => tag).publish
    end
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
      if ENV['ANALYTICS'] != "false"
        keen_id = users_repository.get_keen_id(request.cookies["user_id"])
        KeenPublisher.new(:blog_post, :user => keen_id, :title => "#{post.attributes[:title]}: #{post.attributes[:subtitle]}", :tags => post.attributes[:tags]).publish
      end
      erb :individual_blog_page, locals: {
        :post => post.attributes,
        :logged_in => session[:logged_in],
        :recent_posts => posts_repository.get_recent_posts(0, 5),
        :slug => slug,
        :comments => comments_repository.display_all
      }
    end
  end

  # post '/blog/:full_title' do
  #   post_id = posts_repository.get_id_by_slug(params[:full_title])
  #   comment = Comment.new({:name => params[:name], :comment => params[:comment]})
  #   comments_repository = CommentsRepository.new(DB, post_id)
  #   comments_repository.create(comment.attributes)
  #   email = Email.new
  #   email.send(:to => "nathanael.burt@gmail.com", :from => "nathanael.burt@gmail.com", :subject => "Someone has commented on your blog", :body => "Blog page: #{request.base_url}/blog/#{params[:full_title]}")
  #   if ENV['ANALYTICS'] != "false"
  #     keen_id = users_repository.get_keen_id(request.cookies["user_id"])
  #     KeenPublisher.new(:comment, {:comment => comment.attributes, :user => keen_id, :blog_slug => params[:full_title], :comment_count => comments_repository.display_all.count}).publish
  #   end
  #   redirect "/blog/#{params[:full_title]}"
  # end

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

  delete '/blog/:full_title/delete' do
    posts_repository.delete_by_slug(params[:full_title])
    redirect '/blog'
  end

  put '/blog' do
    original_slug = params[:slug]
    post = Post.new(:title => params[:title], :subtitle => params[:subtitle], :original_text => params[:original_text], :original_post_format => params[:post_format])
    slug = post.create_slug
    post.render_text
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

  delete '/blog/:full_title/comment/:id' do
    slug = params[:full_title]
    post_id = posts_repository.get_id_by_slug(params[:full_title])
    comments_repository = CommentsRepository.new(DB, post_id)
    comments_repository.delete(params[:id])
    redirect "blog/#{slug}"
  end

  get '/portfolio' do
    @title = "Nathanael Burt | Portfolio"
    @meta_description = "Visit Nathanael Burt's portofolio to see the amazing web applications that he has built."
    if ENV['ANALYTICS'] != "false"
      keen_id = users_repository.get_keen_id(request.cookies["user_id"])
      KeenPublisher.new(:portfolio, :user => keen_id).publish
    end
    erb :portfolio, :locals => {:logged_in => session[:logged_in]}
  end

end