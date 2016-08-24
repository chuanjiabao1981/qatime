module V1
  # 学生接口
  class Students < Base
    resource :students do
      before do
        authenticate!
      end

      desc 'student info.' do
        headers 'Remember-Token' => {
                    description: 'RememberToken',
                    required: true
                  }
      end
      params do
        requires :id, type: Integer, desc: 'ID'
      end
      get "/:id/info" do
        student = ::Student.find(params[:id])
        present student, with: Entities::Student
      end

      desc 'student update.' do
        headers 'Remember-Token' => {
                    description: 'RememberToken',
                    required: true
                  }
      end
      params do
        requires :id, type: Integer, desc: 'ID'
        requires :name, type: String, desc: '姓名'
        requires :grade, type: String, desc: '年级'
        optional :avatar, :type => Rack::Multipart::UploadedFile, desc: '头像'
        optional :gender, type: String, desc: '性别'
        optional :birthday, type: DateTime, desc: '生日'
        optional :desc, type: String, desc: '简介'
      end
      put "/:id" do
        student = ::Student.find(params[:id])
        update_params = ActionController::Parameters.new(params).permit(:name, :gender, :grade, :birthday, :desc)
        update_params[:avatar] = ActionDispatch::Http::UploadedFile.new(params[:avatar])
        if student.update(update_params)
          present student, with: Entities::Student
        else
          raise(ActiveRecord::RecordInvalid.new(student))
        end
      end

      desc 'student update profile.' do
        headers 'Remember-Token' => {
                    description: 'RememberToken',
                    required: true
                  }
      end
      params do
        requires :id, type: Integer, desc: 'ID'
        requires :name, type: String, desc: '姓名'
        requires :avatar, type: File, desc: '头像'
        optional :gender, type: String, desc: '性别'
        requires :grade, type: String, desc: '年级'
        optional :avatar, :type => Rack::Multipart::UploadedFile, desc: '头像'
        optional :birthday, type: DateTime, desc: '生日'
        optional :desc, type: String, desc: '简介'
        optional :email, type: String, desc: '邮箱'
        optional :email_confirmation, type: String, desc: '邮箱确认'
        optional :parent_phone, type: String, desc: '家长手机'
        optional :parent_phone_confirmation, type: String, desc: '家长手机确认'
        all_or_none_of :email, :email_confirmation
        all_or_none_of :parent_phone, :parent_phone_confirmation
      end
      put "/:id/profile" do
        student = ::Student.find(params[:id])
        update_params = ActionController::Parameters.new(params).permit(:name, :gender, :grade, :birthday, :desc, :email, :email_confirmation, :parent_phone, :parent_phone_confirmation)
        update_params[:avatar] = ActionDispatch::Http::UploadedFile.new(params[:avatar])
        if student.update(update_params)
          present student, with: Entities::Student
        else
          raise(ActiveRecord::RecordInvalid.new(student))
        end
      end
    end
  end
end
