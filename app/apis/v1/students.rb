module V1
  # 学生接口
  class Students < Base
    resource :students do
      before do
        authenticate!
      end

      helpers do
        def auth_params
          @student = ::Student.find_by(id: params[:id])
        end
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
        present student, with: Entities::StudentInfo
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
        optional :province_id, type: Integer, desc: '省ID'
        optional :city_id, type: Integer, desc: '城市ID'
        optional :avatar, :type => Rack::Multipart::UploadedFile, desc: '头像'
        optional :gender, type: String, desc: '性别'
        optional :birthday, type: DateTime, desc: '生日'
        optional :desc, type: String, desc: '简介'
      end
      put "/:id" do
        student = ::Student.find(params[:id])
        update_params = ActionController::Parameters.new(params).permit(:name, :gender, :grade, :province_id, :city_id, :birthday, :desc)
        update_params[:avatar] = ActionDispatch::Http::UploadedFile.new(params[:avatar]) if params[:avatar]
        if student.update(update_params)
          present student, with: Entities::StudentInfo
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
        optional :province_id, type: Integer, desc: '省ID'
        optional :city_id, type: Integer, desc: '城市ID'
        requires :avatar, :type => Rack::Multipart::UploadedFile, desc: '头像'
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
        update_params = ActionController::Parameters.new(params).permit(:name, :gender, :grade, :province_id, :city_id, :birthday, :desc, :email, :email_confirmation, :parent_phone, :parent_phone_confirmation)
        update_params[:avatar] = ActionDispatch::Http::UploadedFile.new(params[:avatar])

        if student.update(update_params)
          present student, with: Entities::Student
        else
          raise(ActiveRecord::RecordInvalid.new(student))
        end
      end

      desc '验证登录密码,获取修改家长手机ticket_token.' do
        headers 'Remember-Token' => {
                    description: 'RememberToken',
                    required: true
                }
      end
      params do
        requires :id, type: Integer, desc: 'ID'
        requires :current_password, type: String, desc: '当前登录密码'
      end
      post "/:id/verify_current_password" do
        student = ::Student.find(params[:id])
        UserService::PasswordVerifyManager.new(student).check_password(params[:current_password])
        ::TicketToken.instance_token(student, :parent_phone)
      end

      desc 'update parent_phone with ticket_token.' do
        headers 'Remember-Token' => {
                    description: 'RememberToken',
                    required: true
                  }
      end
      params do
        requires :id, type: Integer, desc: 'ID'
        requires :ticket_token, type: String, desc: '验证登录密码的ticket_token'
        requires :parent_phone, type: String, desc: '新家长手机'
        requires :captcha_confirmation, type: String, desc: '新家长手机验证码'
      end
      put "/:id/parent_phone_ticket_token" do
        student = ::Student.find(params[:id])
        # 校验ticket_token
        password_verify_manager = UserService::PasswordVerifyManager.new(student)
        password_verify_manager.check_token(:parent_phone, params[:ticket_token])

        parent_phone_params = ActionController::Parameters.new(params).permit(:parent_phone, :captcha_confirmation)
        captcha_manager = UserService::CaptchaManager.new(parent_phone_params[:parent_phone])

        student.captcha = captcha_manager.captcha_of(:send_captcha)
        if student.update_with_captcha(parent_phone_params)
          present student, with: Entities::Student
        else
          raise(ActiveRecord::RecordInvalid.new(student))
        end
      end

      desc 'update parent_phone.' do
        headers 'Remember-Token' => {
                    description: 'RememberToken',
                    required: true
                }
      end
      params do
        requires :id, type: Integer, desc: 'ID'
        requires :current_password, type: String, desc: '当前登录密码'
        requires :parent_phone, type: String, desc: '新家长手机'
        requires :captcha_confirmation, type: String, desc: '新家长手机验证码'
      end
      put "/:id/parent_phone" do
        student = ::Student.find(params[:id])
        parent_phone_params = ActionController::Parameters.new(params).permit(:current_password, :parent_phone, :captcha_confirmation)
        captcha_manager = UserService::CaptchaManager.new(parent_phone_params[:parent_phone])

        student.captcha = captcha_manager.captcha_of(:send_captcha)
        student.captcha_required!

        if student.update_with_password(parent_phone_params)
          present student, with: Entities::Student
        else
          raise(ActiveRecord::RecordInvalid.new(student))
        end
      end

    end
  end
end
