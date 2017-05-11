# 数据格式化
module BodyFormatter
  def self.call(object, _env)
    return object.to_json if object.is_a?(Hash) && (object.key?(:swagger) || object.key?(:code))

    result = { status: 1 }

    result[:data] = object

    if object.is_a?(Hash) && object.key?(:data)
      result[:data] = object[:data]
      result[:ext] = %i[total_pages page per_page].each_with_object({}) { |key, hash| hash[key] = object[key] if object.key?(key) }
    end

    # 去除nil值
    result[:data].try(:compact!)

    result.to_json
  end
end

# 错误格式化
module ErrorFormatter
  def self.call(message, _backtrace, _options, env)
    return message.to_json if message.is_a?(Hash) && message.key?(:swaggerVersion)

    result = {
      status: 0,
      error: message
    }
    Rails.logger.error "end   [#{env['REQUEST_METHOD']}] #{env['REQUEST_PATH']}, output: #{result.to_h}"
    result.to_json
  end
end
