module ApplicationHelper
  def success_with_msg(msg="")
    [200, [], {:message => msg}.to_json]
  end

  def success_with_data(data, headers={}, status=200)
    [status, headers, data.to_json]
  end

end
