module Qatime
  class API < Grape::API
    mount V1::API
    mount V2::API
  end
end
