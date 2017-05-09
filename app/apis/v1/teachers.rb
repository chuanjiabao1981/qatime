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
          optional :avatar, :type => Rack::Multipart::UploadedFile, desc: '头像'
          optional :gender, type: String, desc: '性别'
          optional :birthday, type: DateTime, desc: '生日'
          optional :desc, type: String, desc: '简介'
        end
        put "/:id" do
          teacher = ::Teacher.find(params[:id])
          update_params = ActionController::Parameters.new(params).permit(:name, :avatar, :gender, :birthday, :desc)
          update_params[:avatar] = ActionDispatch::Http::UploadedFile.new(params[:avatar]) if params[:avatar]
          if teacher.update(update_params)
            present teacher, with: Entities::TeacherInfo
          else
            raise(ActiveRecord::RecordInvalid.new(teacher))
          end
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
          requires :avatar, :type => Rack::Multipart::UploadedFile, desc: '头像'
          optional :gender, type: String, desc: '性别'
          optional :birthday, type: DateTime, desc: '生日'
          optional :desc, type: String, desc: '简介'
          requires :subject, type: String, desc: '科目'
          requires :category, type: String, desc: '类型'
          optional :email, type: String, desc: '邮箱'
          optional :email_confirmation, type: String, desc: '邮箱确认'
          optional :school_id, type: Integer, desc: '学校ID'

          all_or_none_of :email, :email_confirmation
        end
        put "/:id/profile" do
          teacher = ::Teacher.find(params[:id])
          update_params = ActionController::Parameters.new(params).permit(:name, :nick_name, :gender, :subject, :category, :birthday, :desc, :email, :email_confirmation, :school_id)
          update_params[:avatar] = ActionDispatch::Http::UploadedFile.new(params[:avatar])

          raise ActiveRecord::RecordInvalid, teacher unless teacher.update(update_params)
          present teacher, with: Entities::Teacher
        end
      end
    end
  end
end
