class StudentsController < ApplicationController
  def index
    @students = Student.all.paginate(page: params[:page],:per_page => 10)

  end
  def search
    @students = Student.all
                .where("name =? or email = ?",params[:search][:name],params[:search][:name])
  end
end
