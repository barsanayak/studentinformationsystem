



# list all comments and a create-new-comment button.
get '/comments' do
  @title = "comments page"
  puts( " get comment")
  # get data from database
  @comments=Comment.all
  erb :comments
end

# add new comment
get '/comments/new' do

  @title="new comment page"
  # show the add new comment view
  erb :add_comment
end

# add new comment to database
post '/comments/new' do

  # add to database
  Comment.create(name:params[:name],
                 content:params[:content])

  # redirect to comments page
  redirect '/comments'

end

# display comment information for the given id
get '/comments/:id' do

  @title="show comment page"
  # query this student details
  @comment=Comment.get(params[:id])
  erb :view_comment
end
