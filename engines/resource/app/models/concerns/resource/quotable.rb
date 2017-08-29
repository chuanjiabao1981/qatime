module Resource
  # 资源引用模块
  module Quotable
    extend ActiveSupport::Concern

    included do
      has_one :quote, -> { includes :file }, as: :quoter, class_name: 'Resource::Quote' # 单个资源文件引用
      has_many :quotes, -> { includes :file }, as: :quoter, dependent: :destroy, class_name: 'Resource::Quote' # 多个资源文件引用
      has_many :files, through: :quotes, class_name: 'Resource::File' # 资源文件
    end
  end
end
