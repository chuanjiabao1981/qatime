json.array!(@managers_waiters) do |managers_waiter|
  json.extract! managers_waiter, :id, :name, :email, :password, :password_confirmation, :mobile
  json.url managers_waiter_url(managers_waiter, format: :json)
end
