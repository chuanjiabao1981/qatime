Rails.application.routes.draw do

  resources :teachers
  mount CourseLibrary::Engine => "/course_library/teachers/:teacher_id"
end
