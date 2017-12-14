module Permissions
  module API
    def api_allow?(method, path, *params)
      allowed = @allowed_apis[method].find {|k, _v| path =~ k }
      allowed = allowed.last if allowed
      allowed.respond_to?(:call) ? allowed.call(*params) : allowed
    end

    def api_allow(method, path_reg, &block)
      path_reg = Regexp.new(path_reg) unless path_reg.is_a? Regexp
      @allowed_apis ||= {}
      @allowed_apis[method.to_s] ||= {}
      @allowed_apis[method.to_s][path_reg] = block || true
    end
  end

  class BasePermission
    include API

    def allow?(controller, action, resource = nil)
      allowed = @allow_all || @allowed_actions[[controller.to_s, action.to_s]]
      resource.is_a?(Array) && resource << action
      allowed && (allowed == true || resource && allowed.call(resource))
    end

    def allow_all
      @allow_all = true
    end

    def allow(controllers, actions, &block)
      @allowed_actions ||= {}
      Array(controllers).each do |controller|
        Array(actions).each do |action|
          @allowed_actions[[controller.to_s, action.to_s]] = block || true
        end
      end
    end

    def allow_param(resources, attributes)
      @allowed_params ||= {}
      Array(resources).each do |resource|
        @allowed_params[resource] ||= []
        @allowed_params[resource] += Array(attributes)
      end
    end

    def allow_param?(resource, attribute)
      if @allow_all
        true
      elsif @allowed_params && @allowed_params[resource]
        @allowed_params[resource].include? attribute
      end
    end

    def permit_params!(params)
      if @allow_all
        params.permit!
      elsif @allowed_params
        @allowed_params.each do |resource, attributes|
          if params[resource].respond_to? :permit
            params[resource] = params[resource].permit(*attributes)
          end
        end
      end
    end
  end
end