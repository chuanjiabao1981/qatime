module Resource
  # 资源引用模块
  module Quotable
    extend ActiveSupport::Concern

    included do
      has_many :quotes, as: :quoter, dependent: :destroy, class_name: 'Resource::Quote'
      has_many :files, through: :quotes, class_name: 'Resource::File'
    end
  end
end
