module V1
  # 模考接口
  module Exam
    class Papers < V1::Base
      namespace "exam" do
        resource :papers do
          desc '试卷列表' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: false
            }
          end
          params do
            optional :page, type: Integer, desc: '当前页面'
            optional :per_page, type: Integer, desc: '每页记录数'
            optional :q, type: Hash, default: {} do
              optional :grade_category_eq, type: String, desc: '年级', values: APP_CONSTANT['categories']
              optional :subject_eq, type: String, desc: '科目', values: APP_CONSTANT['subjects']
            end
            optional :sort_by, type: String, desc: '排序方式', values: %w(price price.asc published_at published_at.asc users_count users_count.asc)
          end
          get 'search' do
            search_params = ActionController::Parameters.new(params).permit(:sort_by, q: [:grade_category_eq, :subject_eq])
            search_params[:q][:s] =
              if search_params[:sort_by].present?
                by, direction = search_params[:sort_by].split('.')
                "#{by} #{direction || 'desc'}"
              else
                'published_at desc'
              end

            @q = ::Exam::Paper.for_sell.ransack(search_params[:q])
            @papers = @q.result.paginate(page: params[:page], per_page: params[:per_page])
            present @papers, with: Entities::Exam::Paper
          end

          desc '试卷详情' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: false
            }
          end
          params do
            requires :id, type: Integer, desc: '试卷ID'
          end
          get '/:id' do
            paper = ::Exam::Paper.find(params[:id])
            if current_user && current_user.student?
              ticket = paper.tickets.find_by(student_id: current_user.id)
              present ticket, root: :ticket, with: Entities::Exam::Ticket
            end
            present paper, root: :paper, with: Entities::Exam::PaperDetail
          end

          route_param :paper_id do
            before do
              authenticate!
            end
            desc '试卷购买' do
              headers 'Remember-Token' => {
                description: 'RememberToken',
                required: true
              }
            end
            params do
              requires :paper_id, desc: '辅导班ID'
              requires :pay_type, type: String, values: ::Payment::Order.pay_type.values, desc: '支付方式'
            end
            post '/:id/orders' do
              paper = ::Exam::Paper.find(params[:paper_id])
              order = ::Payment::Order.new(paper.order_params.merge(pay_type: params[:pay_type],
                                                                    remote_ip: client_ip,
                                                                    source: :student_app, user: current_user))
              order.save
              raise ActiveRecord::RecordInvalid, order if order.errors.any?
              present order, with: Entities::Payment::Order
            end
          end
        end
      end
    end
  end
end
