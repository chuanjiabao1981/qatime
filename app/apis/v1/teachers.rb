module V1
  # 学生接口
  class Teachers < Base
    resource :teachers do
      group do
        desc '教师公开主页'
        params do
          requires :id, type: Integer, desc: 'ID'
        end
        get "/:id/profile" do
          teacher = ::Teacher.find(params[:id])
          present teacher, with: Entities::TeacherProfile
        end
      end

      group do
        before do
          authenticate!
        end

        helpers do
          def auth_params
            @teacher = ::Teacher.find_by(id: params[:id])
          end
        end

        desc 'teacher info.' do
          headers 'Remember-Token' => {
            description: 'RememberToken',
            required: true
          }
        end
        params do
          requires :id, type: Integer, desc: 'ID'
        end
        get "/:id/info" do
          teacher = ::Teacher.find(params[:id])
          present teacher, with: Entities::TeacherInfo
        end

        desc 'teacher update.' do
          headers 'Remember-Token' => {
            description: 'RememberToken',
            required: true
          }
        end
        params do
          requires :id, type: Integer, desc: 'ID'
          requires :name, type: String, desc: '姓名'
          optional :avatar, type: Rack::Multipart::UploadedFile, desc: '头像'
          optional :subject, type: String, desc: '科目'
          optional :category, type: String, desc: '类型'
          optional :province_id, type: Integer, desc: '省ID'
          optional :city_id, type: Integer, desc: '城市ID'
          optional :school_id, type: Integer, desc: '学校ID'
          optional :teaching_years, type: String, desc: '执教年龄', values: ::Teacher.teaching_years.options.map(&:second)
          optional :grade_range, type: Array[String], coerce_with: ->(val) { val.split(/[\s,]+/) }, desc: '授课范围 用逗号或者空格隔开'
          optional :gender, type: String, desc: '性别'
          optional :birthday, type: DateTime, desc: '生日'
          optional :desc, type: String, desc: '简介'
        end
        put "/:id" do
          teacher = ::Teacher.find(params[:id])
          update_params = ActionController::Parameters.new(params).permit(:name, :avatar, :subject, :category, :province_id, :city_id,
                                                                          :school_id, :teaching_years,
                                                                          :gender, :birthday, :desc,
                                                                          grade_range: [])
          update_params[:avatar] = ActionDispatch::Http::UploadedFile.new(params[:avatar]) if params[:avatar]
          raise ActiveRecord::RecordInvalid, teacher unless teacher.update(update_params)
          present teacher, with: Entities::TeacherInfo
        end

        desc 'teacher update profile.' do
          headers 'Remember-Token' => {
            description: 'RememberToken',
            required: true
          }
        end
        params do
          requires :id, type: Integer, desc: 'ID'
          requires :name, type: String, desc: '姓名'
          optional :nick_name, type: String, desc: '昵称'
          requires :avatar, type: Rack::Multipart::UploadedFile, desc: '头像'
          optional :gender, type: String, desc: '性别'
          optional :birthday, type: DateTime, desc: '生日'
          optional :desc, type: String, desc: '简介'
          requires :subject, type: String, desc: '科目'
          requires :category, type: String, desc: '类型'
          optional :email, type: String, desc: '邮箱'
          optional :email_confirmation, type: String, desc: '邮箱确认'
          optional :school_id, type: Integer, desc: '学校ID'
          optional :province_id, type: Integer, desc: '省ID'
          optional :city_id, type: Integer, desc: '城市ID'
          optional :teaching_years, type: String, desc: '执教年龄', values: ::Teacher.teaching_years.options.map(&:second)
          optional :grade_range, type: Array[String], coerce_with: ->(val) { val.split(/[\s,]+/) }, desc: '授课范围 用逗号或者空格隔开'

          all_or_none_of :email, :email_confirmation
        end
        put "/:id/profile" do
          teacher = ::Teacher.find(params[:id])
          update_params = ActionController::Parameters.new(params).permit(:name, :nick_name, :gender, :subject, :category,
                                                                          :birthday, :desc, :email, :email_confirmation, :school_id,
                                                                          :province_id, :city_id, :teaching_years, grade_range: [])
          update_params[:avatar] = ActionDispatch::Http::UploadedFile.new(params[:avatar])

          raise ActiveRecord::RecordInvalid, teacher unless teacher.update(update_params)
          present teacher, with: Entities::Teacher
        end
      end
    end
  end
end
