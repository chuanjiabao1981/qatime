json.array!(@managers_sellers) do |managers_seller|
  json.extract! managers_seller, :id, :name, :email, :password, :password_confirmation, :mobile
  json.url managers_seller_url(managers_seller, format: :json)
end
