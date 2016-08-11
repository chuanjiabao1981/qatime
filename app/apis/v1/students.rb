module V1
  # 学生接口
  class Students < Base
    resource :students do
      desc 'student info.' do
        headers 'Remember-Token' => {
                    description: 'RememberToken',
                    required: true
                  }
      end
      get :info do
        student = current_user
        present student, with: Entities::Student
      end

      desc 'student update.' do
        headers 'Remember-Token' => {
                    description: 'RememberToken',
                    required: true
                  }
      end
      params do
        requires :name, type: String, desc: '姓名'
        requires :grade, type: String, desc: '年级'
        optional :avatar, type: File, desc: '头像'
        optional :gender, type: String, desc: '性别'
        optional :birthday, type: DateTime, desc: '生日'
        optional :desc, type: String, desc: '简介'
      end
      post :update do
        student = current_user
        update_params = ActionController::Parameters.new(params)
        if student.update({
          name: update_params[:name],
          grade: update_params[:grade],
          avatar: update_params[:avatar],
          gender: update_params[:gender],
          birthday: update_params[:birthday],
          desc: update_params[:desc]
        })
          present student, with: Entities::Student
        else
          { error: "params error" }
        end
      end
    end
  end
end
