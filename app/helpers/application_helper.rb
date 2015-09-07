module ApplicationHelper
  def user_home_path
    return signin_path unless signed_in?

    case current_user.role
      when "teacher"
        #teachers_home_path
        questions_teacher_path(current_user.id)
      when "admin"
        admins_home_path
      when "student"
        students_home_path
      when "manager"
        managers_home_path
      else
        root_path
    end
  end

  def get_edit_or_create_model_string(o)
    if o.new_record?
      "创建"+o.model_name.human
    else
      "编辑"+o.model_name.human
    end
  end


  # Used for accepts_nested_attributes_for

  def link_to_add_fields(name, f, association, shared_dir)
    new_object = f.object.class.reflect_on_association(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}_#{id}") do |builder|
      render(shared_dir + association.to_s.singularize + "_fields", :f => builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end


end