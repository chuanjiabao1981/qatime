json.array!(@workstation_workstations) do |workstation_workstation|
  json.extract! workstation_workstation, :id
  json.url workstation_workstation_url(workstation_workstation, format: :json)
end
