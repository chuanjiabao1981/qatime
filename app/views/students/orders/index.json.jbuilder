json.array!(@students_orders) do |students_order|
  json.extract! students_order, :id, :order_no, :product_id
  json.url students_order_url(students_order, format: :json)
end
