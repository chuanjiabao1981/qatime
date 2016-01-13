Rails.application.routes.draw do

  mount CourseLibrary::Engine => "/course_library"
end
