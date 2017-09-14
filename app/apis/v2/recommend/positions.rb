module V2
  # 辅导班接口
  module Recommend
    class Positions < V1::Base
      namespace "recommend" do
        resource :positions do
          desc '推荐列表'
          params do
            optional :page, type: Integer, desc: '当前页面'
            optional :per_page, type: Integer, desc: '每页记录数'
            optional :city_name, type: String, desc: '城市名称, 不填不限定城市'
          end
          get ':kee/items' do
            position = ::Recommend::Position.find_by!(kee: params[:kee])
            items = DataService::HomeData.position_query(position, params[:city_name]).paginate(page: params[:page], per_page: params[:per_page])
            present items, with: "::Entities::#{position.klass_name}".constantize
          end
        end
      end
    end
  end
end
