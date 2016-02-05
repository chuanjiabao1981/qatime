module ApplicationHelper
  def user_home_path
    return signin_path unless signed_in?

    case current_user.role
      when "teacher"
        #teachers_home_path
        solutions_teacher_path(current_user.id)
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

  def get_edit_or_create_model_string(o,c_name=nil)
    if c_name.nil?
      c_name = "创建"
    end
    if o.new_record?
      "#{c_name}#{o.model_name.human}"
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

  def _get_super_model_name(o_class)
    return o_class.model_name if o_class.superclass.name == "ActiveRecord::Base"
    _get_super_model_name(o_class.superclass)
  end

  def link_to_edit(o,use_super_controller = false)
    if use_super_controller
      m = _get_super_model_name(o.class)
    else
      m = o.class.model_name
    end
    if allow? m.plural , :edit,o
      k = link_to "", send("edit_#{m.singular}_path",o), class: "glyphicon glyphicon-edit"
    end
    k
  end

  def link_to_destroy(o,use_super_controller = false)
    if use_super_controller
      m = _get_super_model_name(o.class)
    else
      m = o.class.model_name
    end
    if allow? m.plural , :destroy ,o
      s = link_to "", send("#{m.singular}_path", o),:method => :delete, 'data-confirm' => 'Are you sure?',
                  class: "glyphicon glyphicon-remove"
    end
    s
  end

  def second_to_minutes(duration)
    return unless duration
    seconds = duration % 60
    minutes = duration / 60

    format("%02d分钟%02d秒", minutes, seconds)
  end

  def video_duration_format(object)
    if object.video and object.video.duration and object.video.duration > 0
       content = " • 视频时长" + second_to_minutes(object.video.duration)
    else
      content = ""
    end
    content
  end

  def user_notification_path
    return unless signed_in?
    send "notifications_#{current_user.model_name.singular_route_key}_path",current_user
  end

  def render_qa_object_avatar(qa_object)
    render partial: "#{qa_object.model_name.route_key}/brief_info/avatar",
           locals:  {qa_object.model_name.singular_route_key.to_sym => qa_object}
  rescue
    image_tag qa_object.author.avatar.normal.url
  end

  def render_qa_object_title(qa_object)
    render partial: "#{qa_object.model_name.route_key}/brief_info/title",
           locals:  {qa_object.model_name.singular_route_key.to_sym => qa_object}
  rescue
    link_to qa_object.title,send("#{qa_object.model_name.singular_route_key}_path",qa_object)
  end

  def render_qa_object_info(qa_object)
    render partial: "#{qa_object.model_name.route_key}/brief_info/info",
           locals: {qa_object.model_name.singular_route_key.to_sym => qa_object}
  end

  def animate_class(object_item)
    param_key = "#{object_item.model_name.singular_route_key}_animate".to_sym
    return "animated pulse" if params[param_key] and params[param_key] == object_item.id.to_s
  end
  def need_animate?(object_item)
    param_key = "#{object_item.model_name.singular_route_key}_animate".to_sym
    return true if params[param_key] and params[param_key] == object_item.id.to_s
  end
  def object_item_id(object_item)
    return "#{object_item.model_name.singular_route_key}_#{object_item.id}"
  end

  def render_qa_object_item_avatar(qa_object_item)
    render partial: "#{qa_object_item.model_name.route_key}/detail_info/avatar",
           locals:  {qa_object_item.model_name.singular_route_key.to_sym => qa_object_item}
  rescue
    image_tag qa_object_item.author.avatar.normal.url
  end

  def render_object_info(qa_object_item)
    render partial: "#{qa_object_item.model_name.route_key}/detail_info/info",
           locals: {qa_object_item.model_name.singular_route_key.to_sym => qa_object_item}
  end

  def object_form_url(parent,object)
      if object.new_record?
        send("#{parent.model_name.singular_route_key}_#{object.model_name.plural}_path",parent,anchor: "new_#{object.model_name.singular_route_key}")
      else
        send("#{object.model_name.singular_route_key}_path",object)
      end
  end

  def template_url(qa_object,span=false)
    return if qa_object.nil? or qa_object.try(:template).nil? or current_user.student?
    template = qa_object.template
    str      = "在备课中心查看详情"
    if not span
      concat "• "
    end
    link_to course_library.send("#{template.model_name.singular_route_key}_path",template) do
      if span
        content_tag('span',"#{str}",class: 'label label-success')
      else
        "#{str}"
      end
    end
  end

  def overwrite_content_for(name, content = nil, &block)
    @_content_for       = {} if @_content_for.nil?
    content             = capture(&block) if block_given?
    @_content_for[name] = content if content
    @_content_for[name] unless content
  end

  def state_css_style(object)
    if object.state == "new"
      "warning"
    elsif object.state == "in_progress"
      "info"
    elsif object.state == "completed"
      "success"
    end
  end


  def completed_duration(object)
    a={
        timeout: {
            style: 'color: red',
            content: '批改时间超过48小时'

        },
        in_time:{
            style: 'color: #B00100',
            content: '在48小时内完成批改'
        },
        good: {
            style:'color: green',
            content: '在24小时完成批改'
        }
    }
    if object.state == "completed" and not object.completed_at.nil?
      duration          = (object.completed_at - object.created_at) / 3600.0
      duration_type     = :timeout
      if duration <= 24
        duration_type   = :good
      elsif duration <= 48
        duration_type   = :in_time
      end
      _duration_tag(a,duration_type)
    end
  end

  def _duration_tag(a,duration_type)
    if a[duration_type]
      content_tag :span ,style: a[duration_type][:style] do
        a[duration_type][:content]
      end
    end
  end
end