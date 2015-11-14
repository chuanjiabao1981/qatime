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
  def container_resource(params={})
    k = resource_name_from_params(params)
    if k
      "#{k}".camelize.constantize.find(params["#{k}_id".to_sym])
    end
  end

  def build_solution(solutioncontainer,resource_name,params2={})
    solutioncontainer.send("#{resource_name}_solutions").build(params2)
  end

  def build_correction(solution,resource_name,params)
    solution.send("#{resource_name}_corrections").build(params)
  end
  def solution_show_prepare
    @corrections  = @solution.corrections.order(Correction.order_column => Correction.order_type).paginate(page: params[:page])
    # @qa_files     = @solution.qa_files.order(:created_at => "ASC")
  end
end