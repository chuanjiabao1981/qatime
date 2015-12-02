module SolutionsHelper

  def solution_correction_state(solution)
    a={
        no_handle_and_timeout: {
           content: "超时未批改",
           style: 'color: red'
        },
        no_handle:{
            content: "未批改",
            style: 'color: #B00100'
        },
        handle_timeout: {
            content:"超时批改",
            style:'color: green'
        },
        handle_in_time: {
            content: "已批改",
            style:'color: green'
        }
    }
    _state_tag solution,a
  end

  def _state_tag(solution,a)
    if a[solution.handle_state]
      content_tag :span ,style: a[solution.handle_state][:style] do
        a[solution.handle_state][:content]
      end
    end
  end


end
