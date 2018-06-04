require 'sinatra'
require 'sinatra/reloader' if development?
require 'dm-core'
require 'dm-migrations'
require 'dm-timestamps'
require 'date'

require './student'
require './comment'


configure do
  # enable use of session
  use Rack::Session::Cookie,
      :key => 'rack.session',
      :path => '/',
      :expire_after => 14400, # In seconds
      :secret => 'change_me'

  # login credentials
  set :username, "barsa"
  set :password, "newnew"

  # handle server exceptions
  set :show_exceptions,false

end

configure :development, :test do
  url="sqlite3://#{Dir.pwd}/student_db.db"
  # connect to database
  DataMapper.setup(:default, url)
end

configure :production do
  # connect to deployment server database url
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end


class Student
  include DataMapper::Resource
  property :id, Serial
  property :studentid, String,  :required => true
  property :firstname, String,  :required => true
  property :lastname, String, :required => true
  property :address, Text
  property :grade, Integer
  property :birthday, Date
  property :photo, String
end


class Comment
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true
  property :content, Text, :required => true
  property :created_at, DateTime
end



DataMapper.finalize

Student.auto_upgrade! #upgrades with new schema
Comment.auto_upgrade! #upgrades with new schema


# home page
['/','/home/?','/index/?'].each do |route|
  get route do
    @title = "home page"
    erb :home
  end
end

get '/about' do
  @title = "About page"
  erb :about
end

get '/contact' do
  @title = "Contact page"
  erb :contact
end

get '/students' do
  @title = "Students page"
  erb :students
end

get '/comment' do
  @title = "Comment page"
  erb :comments
end

get '/video' do
  @title = "Video page"
  erb :video
end


get '/login' do
  @title = "Login page"
  erb :login
end


# login post method
post '/login' do
  # check if login data matches the values set in settings
  if params[:username] == settings.username && params[:password] == settings.password
    # mark as logged in
    session[:admin] = true
    session[:username] = settings.username
    puts "session set to true by #{params[:username] }"
    # redirect to students page
    redirect '/students'
  else
    @error="Incorrect username/password."
    erb :login
  end
end

# logout method
get '/logout' do
  session.clear
  redirect '/login'
end

get '/style.css' do
  scss :style
end

not_found do
  @title = "sinatra Student page"
  erb :notfound
end







