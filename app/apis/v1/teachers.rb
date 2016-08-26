module V1
  # 学生接口
  class Teachers < Base
    resource :teachers do
      before do
        authenticate!
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
        present teacher, with: Entities::Teacher
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
          present teacher, with: Entities::Teacher
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

        all_or_none_of :email, :email_confirmation
      end
      put "/:id/profile" do
        teacher = ::Teacher.find(params[:id])
        update_params = ActionController::Parameters.new(params).permit(:name, :nick_name, :gender, :subject, :category, :birthday, :desc, :email, :email_confirmation)
        update_params[:avatar] = ActionDispatch::Http::UploadedFile.new(params[:avatar])

        if teacher.update(update_params)
          present teacher, with: Entities::Teacher
        else
          raise(ActiveRecord::RecordInvalid.new(teacher))
        end
      end
    end
  end
end
