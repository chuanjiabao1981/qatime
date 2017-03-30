module Qatime
  module Stripable
    extend ActiveSupport::Concern
    class_methods do
      def strip_field(*attrs)
        attrs.each do |attr_name|
          define_method "#{attr_name}=" do |value|
            value.strip! if value.is_a? String
            super(value)
          end
        end
      end
    end
  end
end
