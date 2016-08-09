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
        current_user
        present current_user, with: Entities::Student
      end
    end
  end
end
