module V1
  # 优惠码接口
  module Payment
    class Coupons < V1::Base
      namespace "payment" do
        resource :coupons do

          desc '优惠码校验'
          params do
            requires :code, type: String, desc: '优惠码'
          end
          post ':code/verify' do
            coupon = ::Payment::Coupon.find_by!(code: params[:code])
            if coupon
              present coupon, with: Entities::Payment::Coupon
            end
          end

        end
      end
    end
  end
end
