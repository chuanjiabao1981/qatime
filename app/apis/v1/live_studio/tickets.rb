module V1
  # 辅导班接口
  module LiveStudio
    class Courses < V1::Base
      namespace "live_studio" do
        before do
          authenticate!
        end
        namespace :students do
          route_param :student_id do
            helpers do
              def auth_params
                @student ||= ::Student.find_by(id: params[:student_id])
              end

              def courses_cate_of(cate)
                return @student.live_studio_taste_tickets.includes(:course) if cate == 'taste'
                @student.live_studio_tickets.visiable.includes(course: [:teacher, :lessons])
                        .where(live_studio_lessons: { class_date: Date.today })
              end
            end

            resource :tickets do
              desc '学生辅导列表' do
                headers 'Remember-Token' => {
                  description: 'RememberToken',
                  required: true
                }
              end
              params do
                optional :page, type: Integer, desc: '当前页面'
                optional :per_page, type: Integer, desc: '每页记录数'
                optional :cate, type: String, desc: '分类 today: 今日; taste: 试听', values: %w(today taste)
                optional :status, type: String, desc: '辅导班状态 published: 待开课; teaching: 已开课; completed: 已结束', values: %w(published teaching completed)
              end
              get do
                params.delete(:status)
                tickets =
                  if params[:cate].present?
                    courses_cate_of(params[:cate])
                  else
                    @student.live_studio_tickets.includes(:course).where(course: { status: params[:status] })
                  end
                tickets = tickets.paginate(page: params[:page], per_page: params[:per_page])
                present tickets, with: Entities::LiveStudio::Ticket, type: :default, current_user: current_user
              end
            end
          end
        end
      end
    end
  end
end
