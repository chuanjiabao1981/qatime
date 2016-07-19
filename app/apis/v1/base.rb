require "grape-swagger"

module V1
  class Base < Grape::API
    include SessionsHelper
  end
end
