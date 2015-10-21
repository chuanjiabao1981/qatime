module QaSolution
  extend ActiveSupport::Concern

  def resource_name_from_params(params={})
    k = nil
    params.keys.each do |key|
      m = key.to_s.match("(.*)_id")
      if m
        k = m[1]
        break
      end
    end
    k
  end
  def solution_container_resource(params={})
    k = resource_name_from_params(params)
    if k
      "#{k}".camelize.constantize.find(params["#{k}_id".to_sym])
    end
  end

  def build_solution(solutioncontainer,resource_name,params2={})
    solutioncontainer.send("#{resource_name}_solutions").build(params2)
  end
end