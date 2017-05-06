# desc "Explaining what the task does"
# task :payment do
#   # Task goes here
# end

namespace :payment do
  desc "迁移用户充值记录"
  task itunes_product: :environment do
    Payment::ItunesProduct.all.destroy_all
    [['Charge_50', 34.30],
     ['Charge_108', 74.10],
     ['Charge_158', 108.40],
     ['Charge_208', 142.70],
     ['Charge_258', 177.01],
     ['Charge_308', 211.31]].each do |product_id, amount|
      price = product_id.split('_').last.to_i
      Payment::ItunesProduct.create(name: "#{price}元充值卡", product_id: product_id, price: price, amount: amount, online: true)
    end
  end
end
