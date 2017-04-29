module ErrorHelper
  def error_400(message)
    error_with_code(400, message)
  end

  def error_401(message="401 Unauthorized")
    error_with_code(401, message)
  end

  def error_402(message)
    error_with_code(402, message)
  end

  def error_403(message="403 Forbidden")
    error_with_code(403, message)
  end

  def error_404(message="404 Not Found")
    error_with_code(404, message)
  end

  def error_409(message="Conflict")
    error_with_code(409, message)
  end

  def error_500(message)
    error_with_code(500, message)
  end

  def error_500_for_ar(object)
    error_500 object.errors.full_messages.join('\n')
  end

  def error_with_code(code, message)
    halt code, {'Content-Type' => 'application/json'}, {:message => message}.to_json
  end
end
