module V1
  # 一对一直播接口
  module LiveStudio
    class InstantLessons < V1::Base
      namespace "live_studio" do
        namespace :customized_groups do
          route_param :group_id do
            before do
              authenticate!
            end

            helpers do
              def auth_params
                @group ||= ::LiveStudio::CustomizedGroup.find(params[:group_id])
              end
            end

            resource :instant_lessons do
              desc '创建答疑课程' do
                headers 'Remember-Token' => {
                  description: 'RememberToken',
                  required: true
                }
              end
              params do
                optional :t, type: String, desc: '时间戳可不传'
              end
              post '' do
                @lesson = @group.instant_lessons.create(teacher: current_user) if current_user.teacher?
                raise ActiveRecord::RecordInvalid, @lesson if @lesson.errors.any?
                present lesson, with: Entities::LiveStudio::InstantLesson
              end
            end
          end
        end
      end
    end
  end
end
