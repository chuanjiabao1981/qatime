module V1
  # 辅导班接口
  module Recommend
    class Positions < V1::Base
      namespace "recommend" do
        resource :positions do
          desc '推荐位列表'
          params do
            optional :page, type: Integer, desc: '当前页面'
            optional :per_page, type: Integer, desc: '每页记录数'
          end
          get do
            positions = ::Recommend::Position.all.paginate(page: params[:page], per_page: params[:per_page])
            present positions, with: Entities::Recommend::Position
          end

          desc '推荐位详情'
          get ':kee' do
            position = ::Recommend::Position.find_by!(kee: params[:kee])
            present position, with: Entities::Recommend::Position
          end

          desc '推荐列表'
          params do
            optional :page, type: Integer, desc: '当前页面'
            optional :per_page, type: Integer, desc: '每页记录数'
          end
          get ':kee/items' do
            position = ::Recommend::Position.find_by!(kee: params[:kee])
            items = position.items.all.paginate(page: params[:page], per_page: params[:per_page])
            present items, with: "Entities::#{position.klass_name}".constantize
          end

          desc '推荐列表批量接口'
          params do
            optional :page, type: Integer, desc: '当前页面'
            optional :per_page, type: Integer, desc: '每页记录数'
            requires :kees, type: String, desc: '多个kee使用中横线分割'
          end
          get ':kees/items/batch' do
            kees = params[:kees].to_s.split('-')
            result = {}
            positions = ::Recommend::Position.where(kee: kees).includes(:items)
            positions.each do |position|
              present position.items, with: "Entities::#{position.klass_name}".constantize, root: position.kee
            end
          end
        end
      end
    end
  end
end
