module V1
  # 模考接口
  module Exam
    module Students
      class Results < V1::Base
        namespace "exam" do
          resource :students do
            route_param :student_id do
              before do
                authenticate!
              end
              resource :results do
                desc '考试记录' do
                  headers 'Remember-Token' => {
                    description: 'RememberToken',
                    required: true
                  }
                end
                params do
                  requires :status, type: String, desc: '状态', values: ::Exam::Result.statuses.keys
                end

                get do
                  @results = current_user.exam_results.where(status: params[:status])
                  @results = @results.paginate(page: params[:page], per_page: params[:per_page])
                  present @results, with: Entities::Exam::Result
                end
              end
            end
          end
        end
      end
    end
  end
end
