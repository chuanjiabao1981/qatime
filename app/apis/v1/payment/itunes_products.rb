module V1
  # 优惠码接口
  module Payment
    class ItunesProducts < V1::Base
      namespace "payment" do
        before do
          authenticate!
        end

        resource :itunes_products do
          desc '苹果充值卡列表' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          get do
            present ::Payment::ItunesProduct.available, with: Entities::Payment::ItunesProduct
          end
        end
      end
    end
  end
end
