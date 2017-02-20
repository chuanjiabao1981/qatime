json.array!(@workstation_sellers) do |workstation_seller|
  json.extract! workstation_seller, :id
  json.url workstation_seller_url(workstation_seller, format: :json)
end
