module ApplicationHelper
  include SessionsHelper

  # 显示序号
  def show_index(index, per = 30)
    params[:page] ||= 1
    (params[:page].to_i - 1) * per.to_i + index + 1
  end

  def echart(html_id, opts = {}, html_options = {})
    chart = javascript_tag("
      $(function () {
        var myChart = echarts.init(document.getElementById('#{html_id}'));
        myChart.setOption(#{opts.to_json.html_safe.gsub('=>',': ').gsub("\"[", '[').gsub("]\"", ']')});
        window.onresize = myChart.resize;
      }); ") + content_tag(:div, nil, {id: html_id}.merge(html_options))
    chart
  end

  # 简单线性图
  def echarts_line(dom_id, options = {}, html_options = {})
    opts = {
        tooltip: { trigger: 'axis' },
        grid: { left: '1%', right: '10%', bottom: '3%', containLabel: true }
    }

    os = opts.merge(options)
    os[:tooltip] = opts[:tooltip].merge(options[:tooltip]) if options[:tooltip]
    if os[:series]
      os[:series] = [os[:series].merge({type: 'line'})] if os[:series].is_a?(Hash)
      os[:series] = os[:series].map {|h| h.merge({type: 'line'}) } if os[:series].is_a?(Array)
    end
    echart(dom_id, os, html_options)
  end

  # 截取字符长度,中英文兼容
  def truncate_u(text, options = {})
    return '' if text.blank?
    opts = { :length => 30, :omission => '...' }
    options = opts.merge(options)
    length = 0
    max = options[:length] * 2
    text.chars.each_with_index do |char, index|
      length += (char.ascii_only? ? 1 : 2)
      if length >= max
        return text[0..index] + (index < text.length - 1 ? options[:omission] : '')
      end
    end
    text
  end

  def set_city
    cookie_city = cookies[:selected_cities].try(:split, '-').try(:first)
    @location_city = City.find_by(id: params[:city_id]) || City.find_by(name: params[:city_name] || cookie_city)
    # return if @city.blank?
    selected_cities = cookies[:selected_cities].try(:split, '-') || []
    selected_cities.delete(@location_city.name) if @location_city && selected_cities.include?(@location_city.name)
    selected_cities = selected_cities.insert(0, @location_city.try(:name) || 'country')
    cookies[:selected_cities] = selected_cities.uniq.try(:join, '-')
    @location_workstation = @location_city.workstations.first if @location_city
    @location_city
  end

  # 登录跳转调整
  def after_sign_in_path
    return main_app.signin_path(redirect_url: request.original_url) unless signed_in?

    case current_user.role
    when "admin"
      main_app.admins_course_intros_path
    when "manager"
      main_app.station_workstation_home_index_path(current_user.default_workstation)
    when "waiter"
      main_app.station_workstation_home_index_path(current_user.workstation_id)
    when "seller"
      main_app.station_workstation_home_index_path(current_user.workstation_id)
    else
      main_app.home_path
    end
  end

  # 退出跳转
  def after_sign_out_path
    params[:redirect_url].presence || main_app.home_path
  end

  def user_home_path
    return main_app.signin_path(redirect_url: request.original_url) unless signed_in?

    case current_user.role
      when "teacher"
        #teachers_home_path
        main_app.solutions_teacher_path(current_user.id)
      when "admin"
        main_app.admins_home_path
      when "student"
        main_app.students_home_path
      when "manager"
        main_app.station_workstation_home_index_path(current_user.default_workstation)
      when "waiter"
        main_app.station_workstation_home_index_path(current_user.workstation_id)
      when "seller"
        main_app.station_workstation_home_index_path(current_user.workstation_id)
      else
        root_path
    end
  end

  def user_payment_passwd_path
    case current_user.role
      when "teacher"
        main_app.edit_teacher_path(current_user, cate: 'security_setting')
      when "student"
        main_app.edit_student_path(current_user, cate: 'security_setting')
      else
        user_home_path
    end
  end

  def wap_user_home_path
    unless signed_in?
      redirect_url = params[:redirect_url].presence || request.original_url
      return main_app.new_wap_session_path(redirect_url: redirect_url)
    end
    main_app.root_path
  end

  def wap_after_sign_in_path
    params[:redirect_url].presence || root_path
  end

  def get_edit_or_create_model_string(o, c_name=nil)
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
    link_to(name, '###', class: "add_fields add-course", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def link_to_append_fields(name, f, association, shared_dir, options = {})
    new_object = f.object.class.reflect_on_association(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: "new_#{association}_#{id}") do |builder|
      render(shared_dir + association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '###', class: "append_fields #{options[:class]}", "append-to" => options['append-to'], data: { id: id, fields: fields.delete("\n") })
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
    user_notifications_path(current_user)
  end

  def render_qa_object_avatar(qa_object)
    render partial: "#{qa_object.model_name.route_key}/brief_info/avatar",
           locals:  {qa_object.model_name.singular_route_key.to_sym => qa_object}
  rescue
    image_tag qa_object.author.try(:avatar).try(:normal).try(:url)
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
    return if qa_object.nil? or not qa_object.respond_to?(:template) or qa_object.template.nil? or current_user.student?
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

  def state_css_v1_style(object)
    if object.state == "new"
      "new"
    elsif object.state == "in_progress"
      "correct"
    elsif object.state == "completed"
      "end"
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

  def student_sidebar_nav_is?(nav)
    case nav.to_s.to_sym
    when :setting
      r = controller_name == 'students' && (
            action_name == 'info' || action_name == 'edit'
          )
    when :cash
      r = controller_name == 'users' && action_name.in?(%w(recharges withdraws consumptione_records earning_records refunds))
    when :orders
      r = controller_name == 'orders' && action_name == 'index'
    when :courses
      r = controller_name == 'courses'
    when :interactive_courses
      r = controller_name == 'interactive_courses'
    when :video_courses
      r = controller_name == 'video_courses'
    when :schedules
      r = controller_name == 'students' && action_name == 'schedules'
    when :tastes
      r = controller_name == 'students' && action_name == 'tastes'
    when :solutions
      r = controller_name == 'students' && action_name == 'solutions'
    when :my_homework
      r = controller_name == 'students' && %w[solutions customized_tutorial_topics homeworks questions topics].include?(action_name)
    when :teachers
      r = controller_name == 'students' && action_name == 'teachers'
    when :notifications
      r = controller_name == 'notifications'
    when :customized_courses
      r = controller_name == 'students' && action_name == 'customized_courses'
    else
      r = false
    end
    r
  end

  def teacher_sidebar_nav_is?(nav)
    case nav.to_s.to_sym
    when :setting
      r = controller_name == 'teachers' && (
            action_name == 'info' || action_name == 'edit'
          )
    when :cash
      r = controller_name == 'users' && action_name.in?(%w(recharges withdraws consumptione_records earning_records refunds))
    when :my_courses
      r = controller_name == 'courses' && action_name == 'index'
    when :my_interactive_courses
      r = controller_name == 'interactive_courses'
    when :my_video_courses
      r = controller_name == 'video_courses'
    when :schedule
      r = controller_name == 'teachers' && action_name == 'schedules'
    when :teacher_students
      r = controller_name == 'teachers' && action_name == 'students'
    when :notification
      r = controller_name == 'notifications'
    when :teacher_syllabuses
      r = controller_name == 'syllabuses' && action_name == 'index'
    when :customized_courses
      r = controller_name == 'teachers' && action_name == 'customized_courses'
    when :lessons_state
      r = controller_name == 'teachers' && action_name == 'lessons_state'
    when :curriculums
      r = controller_name == 'teachers' && action_name == 'curriculums'
    when :homeworks
      r = controller_name == 'teachers' && action_name == 'homeworks'
    when :my_homework
      r = controller_name == 'teachers' && %w[solutions customized_tutorial_topics homeworks questions topics].include?(action_name)
    else
      r = false
    end
    r
  end

  def manager_sidebar_nav_is?(nav)
    case nav.to_s.to_sym
    when :home
      r = %w[station/home station/workstations payment/station/sale_tasks].include?(params[:controller]) && %w[index statistics teaching_lessons action_records].include?(action_name)
    when :station
      r = params[:controller] == 'station/workstations' && %w[show fund change_records].include?(action_name)
    when :resources
      r = %w[station/students station/teachers station/schools].include?(params[:controller])
    when :all_courses
      my_courses_page = (params[:controller] == 'live_studio/station/courses' && action_name == 'my_courses')
      course_page = (params[:controller] == 'live_studio/courses' && %w[new update_class_date].include?(action_name))
      interactive_courses_page = (params[:controller] == 'live_studio/station/interactive_courses' && action_name == 'index')
      interactive_course_page = (params[:controller] == 'live_studio/interactive_courses' && %w[new update_class_date].include?(action_name))
      video_courses_page = (params[:controller] == 'live_studio/station/video_courses' && %w[audits list edit].include?(action_name))
      lessons_state_page = (params[:controller] == 'station/lessons' && action_name == 'state')
      customized_courses_page = (params[:controller] == 'station/workstations' && action_name == 'customized_courses')
      r = my_courses_page || course_page || interactive_courses_page || interactive_course_page || video_courses_page || lessons_state_page || customized_courses_page
    when :seller_courses
      r = %w[live_studio/station/courses live_studio/station/video_courses].include?(params[:controller]) && action_name == 'index'
    when :webpage
      r = %w[recommend/station/banner_items recommend/station/choiceness_items recommend/station/teacher_items recommend/station/topic_items recommend/station/replay_items].include?(params[:controller])
    when :sellers
      r = %w[station/workstations station/sellers station/waiters].include?(params[:controller]) && %w[sellers waiters new edit].include?(action_name)
    else
      r = false
    end
    r
  end

  # 系统所有的标签
  def tags_with_group
    TagGroup.includes(:tags)
  end

  def beautify_index index
    "%02d"%(index+1)
  end

  # 支付密码提示信息
  # 密码2小时内不可用
  def payment_password_hint(user)
    default_text = content_tag(:i, t('view.common.payment_password_not_set'), class: 'prompt-info')
    return default_text unless user.cash_account_password?
    return default_text if user.cash_account.try(:password_set_at).blank?

    time_now = Time.now
    expire_time = user.cash_account.password_set_at + 2.hours
    if expire_time > time_now
      leave_time = Util.duration_in_words((expire_time - time_now).to_i).gsub(/.\d秒/, '')
      content_tag :i, class: 'prompt-info' do
        t('view.common.payment_password_expire_time', time: leave_time)
      end
    else
      content_tag :i do
        t('view.common.password_not_visible')
      end
    end
  end

  def format_duration(duration)
    return unless duration.to_i > 0
    second = format('%02d', duration % 60)
    duration /= 60
    minute = format('%02d', duration % 60)
    duration /= 60
    hour = format('%02d', duration % 60)
    "#{hour}:#{minute}:#{second}"
  end

  def with_none_tips(content)
    content || I18n.t('view.tips.none')
  end

  def today_live_status(lesson)
    if lesson.status_wating?
      ''
    elsif lesson.status_living?
      'active'
    else
      'finish'
    end
  end

  def today_live_status_text(lesson)
    if lesson.status_wating?
      I18n.t('view.today_lives.live_padding')
    elsif lesson.status_living?
      I18n.t('view.today_lives.living')
    else
      I18n.t('view.today_lives.live_end')
    end
  end

  # 直播课回放按钮
  def replay_button_of(lesson, preview = false)
    return lesson.status_text if current_user.blank?
    return lesson.status_text(current_user.try(:role)) unless lesson.replayable
    return lesson.status_text(current_user.try(:role)) unless allow?("live_studio/lessons", "replay", lesson)
    my_replay_times = lesson.user_left_times(current_user)

    if preview
      render 'live_studio/courses/show/replay_button_preview', { lesson: lesson, my_replay_times: my_replay_times}
    else
      render 'live_studio/courses/show/replay_button', { lesson: lesson, my_replay_times: my_replay_times}
    end
  end
end
