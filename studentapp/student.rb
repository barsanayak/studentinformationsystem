

get '/students' do
  @title = "students page"
  # get data from database
  @students=Student.all
  erb :students
end

get '/students/:id/update_student_image' do

  # protect the route by enforcing login
  halt erb(:login) unless session[:admin]

  @student=Student.get(params[:id])
  erb :upload_student_image


end

# update student details in database
post '/students/:id/save_image' do
  # protect the route by enforcing login
  halt erb(:login) unless session[:admin]
  begin
    @student=Student.get(params[:id])
  puts("saving........")
    @id = params[:id].to_s
    puts(@id)
  if params[:image] && params[:image][:filename]
    @filename = @id +"-"+  params[:image][:filename]
    file = params[:image][:tempfile]

    # Write file to disk
    File.open("./public/upload/#{@filename}", 'wb') do |f|
      f.write(file.read)
    end
    puts ( "hey ...................here is the filename ")
   puts(@filename)
   @filename = "./upload/"+@filename
  end
    # update student details
    student=Student.get(params[:id])
    student.update(photo:@filename)
    puts("student info...........")
    puts(student.id.to_s)
    puts(student.photo)
  rescue Exception
    puts "update student error: #{$!}"
  end

  # redirect to show student detail page
  @students=Student.all
  erb :save_image
end

# display adding new student page
get '/students/new' do
  # protect the route by enforcing login
  halt erb(:login) unless session[:admin]

  @title="new student page"
  erb :add_student
end


# add new student to database
post '/students/new' do
  # protect the route by enforcing login
  halt erb(:login) unless session[:admin]

  begin
    dob=Date.parse(params[:birthday]).strftime("%m/%d/%Y")
    photopath = "./image/empty.jpg"

    Student.create(studentid:params[:studentid],
                   firstname:params[:firstname],
                   lastname:params[:lastname],
                   address:params[:address],
                   grade:params[:grade],
                   birthday:dob,
                   photo:photopath
    )

  rescue Exception
    puts "create student error: #{$!}"
  end

  # redirect to students page
  redirect '/students'

end

# display student information for the given id
get '/students/:id' do
  # protect the route by enforcing login
  halt erb(:login) unless session[:admin]

  @title="View student page"
  # query this student details
  puts " get view student"
  puts (params[:id])
  @student=Student.get(params[:id])
  puts(@student)
  puts (" before i routes ")
  erb :view_student
end

# go to edit student page
get '/students/:id/update' do
  # protect the route by enforcing login
  halt erb(:login) unless session[:admin]

  @title="Update student page"
  @student=Student.get(params[:id])
  puts("before update redirecting")
  erb :update_studentinfo
end

# update student details in database
put '/students/:id' do
  # protect the route by enforcing login
  halt erb(:login) unless session[:admin]
  begin
    dob=Date.parse(params[:birthday]).strftime("%m/%d/%Y")


    # update student details
    student=Student.get(params[:id])
    student.update(firstname:params[:firstname],
                   lastname:params[:lastname],
                   address:params[:address],
                   grade:params[:grade],
                   birthday:dob)
  rescue Exception
    puts "update student error: #{$!}"
  end

  # redirect to show student detail page
  redirect "/students/#{student.id}"
end

# delete student from database
delete '/students/:id' do
  # protect the route by enforcing login
  halt erb(:login) unless session[:admin]

  @title="show student page"

  #delete student from db
  student=Student.get(params[:id])
  student.destroy

  # redirect to students list page
  redirect '/students'

end
