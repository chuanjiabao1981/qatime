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
        optional :avatar, type: File, desc: '头像'
        optional :gender, type: String, desc: '性别'
        optional :birthday, type: DateTime, desc: '生日'
        optional :desc, type: String, desc: '简介'
      end
      post "/:id/update" do
        teacher = ::Teacher.find(params[:id])
        update_params = ActionController::Parameters.new(params)
        if teacher.update({
          name: update_params[:name],
          avatar: update_params[:avatar],
          gender: update_params[:gender],
          birthday: update_params[:birthday],
          desc: update_params[:desc]
        })
          present teacher, with: Entities::Teacher
        else
          { error: "params error" }
        end
      end
    end
  end
end
