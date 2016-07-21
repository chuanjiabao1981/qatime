module Qatime
  class API < Grape::API
    mount V1::API
  end
end
